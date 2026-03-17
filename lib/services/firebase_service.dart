import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  // ─── UTILISATEUR COURANT ─────────────────────────────────
  static String? get uid => _auth.currentUser?.uid;

  static DocumentReference get _userDoc =>
      _db.collection('users').doc(uid);

  // ─── INITIALISER UN NOUVEL UTILISATEUR ───────────────────
  static Future<void> initUser() async {
    if (uid == null) return;
    final doc = await _userDoc.get();
    if (!doc.exists) {
      await _userDoc.set({
        'createdAt': FieldValue.serverTimestamp(),
        'score': 0,
        'streak': 0,
        'totalTextes': 0,
        'totalFautes': 0,
        'lastSeen': FieldValue.serverTimestamp(),
      });
    } else {
      // Met à jour lastSeen
      await _userDoc.update({'lastSeen': FieldValue.serverTimestamp()});
    }
  }

  // ─── LIRE LES STATS ──────────────────────────────────────
  static Future<Map<String, dynamic>> getStats() async {
    if (uid == null) return _defaultStats();
    try {
      final doc = await _userDoc.get();
      if (!doc.exists) return _defaultStats();
      final data = doc.data() as Map<String, dynamic>;
      return {
        'score': data['score'] ?? 0,
        'streak': data['streak'] ?? 0,
        'totalTextes': data['totalTextes'] ?? 0,
        'totalFautes': data['totalFautes'] ?? 0,
      };
    } catch (_) {
      return _defaultStats();
    }
  }

  static Map<String, dynamic> _defaultStats() => {
        'score': 0,
        'streak': 0,
        'totalTextes': 0,
        'totalFautes': 0,
      };

  // ─── LIRE LES FAUTES ─────────────────────────────────────
  static Future<List<Map<String, dynamic>>> getFautes({int limit = 10}) async {
    if (uid == null) return [];
    try {
      final snap = await _userDoc
          .collection('fautes')
          .orderBy('count', descending: true)
          .limit(limit)
          .get();
      return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
    } catch (_) {
      return [];
    }
  }

  // ─── LIRE LES FAUTES (mots seulement, pour Gemini) ───────
  static Future<List<String>> getFauteMots({int limit = 10}) async {
    final fautes = await getFautes(limit: limit);
    return fautes
        .map((f) => f['mot']?.toString() ?? '')
        .where((m) => m.isNotEmpty)
        .toList();
  }

  // ─── SAUVEGARDER LES FAUTES APRÈS UN TEXTE ───────────────
  static Future<void> saveFautes(List<Map<String, dynamic>> erreurs) async {
    if (uid == null || erreurs.isEmpty) return;
    try {
      final batch = _db.batch();
      final fautesRef = _userDoc.collection('fautes');

      for (final e in erreurs) {
        final mot = e['context']?['text'] ?? '';
        final correction = (e['replacements'] as List?)?.isNotEmpty == true
            ? e['replacements'][0]['value']
            : '';
        if (mot.isEmpty) continue;

        // Clé unique par mot
        final docRef = fautesRef.doc(mot.replaceAll(' ', '_'));
        batch.set(
          docRef,
          {
            'mot': mot,
            'correction': correction,
            'count': FieldValue.increment(1),
            'lastSeen': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        );
      }

      // Met à jour les stats globales
      batch.update(_userDoc, {
        'totalFautes': FieldValue.increment(erreurs.length),
        'totalTextes': FieldValue.increment(1),
      });

      await batch.commit();
      await _updateScore();
    } catch (_) {}
  }

  // ─── SAUVEGARDER LES FAUTES DU JEU ──────────────────────
  static Future<void> saveGameFautes(
      List<Map<String, dynamic>> erreursJeu) async {
    if (uid == null || erreursJeu.isEmpty) return;
    try {
      final batch = _db.batch();
      final fautesRef = _userDoc.collection('fautes');

      for (final e in erreursJeu) {
        final mot = e['reponseChoisie']?.toString() ?? '';
        final correction = e['bonneReponse']?.toString() ?? '';
        if (mot.isEmpty) continue;

        final docRef = fautesRef.doc(mot.replaceAll(' ', '_'));
        batch.set(
          docRef,
          {
            'mot': mot,
            'correction': correction,
            'count': FieldValue.increment(1),
            'lastSeen': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        );
      }

      await batch.commit();
    } catch (_) {}
  }

  // ─── STREAK ──────────────────────────────────────────────
  static Future<void> updateStreak() async {
    if (uid == null) return;
    try {
      final doc = await _userDoc.get();
      final data = doc.data() as Map<String, dynamic>? ?? {};
      final lastSeen = (data['lastSeen'] as Timestamp?)?.toDate();
      final now = DateTime.now();

      int streak = data['streak'] ?? 0;

      if (lastSeen != null) {
        final diff = now.difference(lastSeen).inDays;
        if (diff == 1) {
          streak++; // jour consécutif
        } else if (diff > 1) {
          streak = 1; // streak cassé
        }
        // diff == 0 → même jour, pas de changement
      } else {
        streak = 1;
      }

      await _userDoc.update({
        'streak': streak,
        'lastSeen': FieldValue.serverTimestamp(),
      });
    } catch (_) {}
  }

  // ─── SCORE ───────────────────────────────────────────────
  static Future<void> _updateScore() async {
    if (uid == null) return;
    try {
      final doc = await _userDoc.get();
      final data = doc.data() as Map<String, dynamic>? ?? {};
      final totalTextes = (data['totalTextes'] ?? 0) as int;
      final totalFautes = (data['totalFautes'] ?? 0) as int;

      if (totalTextes == 0) return;
      final moyenneFautes = totalFautes / totalTextes;
      // Score : 100 - (moyenne fautes * 5), min 0, max 100
      final score = (100 - (moyenneFautes * 5)).clamp(0, 100).round();

      await _userDoc.update({'score': score});
    } catch (_) {}
  }

  // ─── FAUTES PAR JOUR (pour le graphique) ─────────────────
  static Future<List<Map<String, dynamic>>> getFautesParJour() async {
    if (uid == null) return [];
    try {
      final sept = DateTime.now().subtract(const Duration(days: 6));
      final snap = await _userDoc
          .collection('sessions')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(sept))
          .orderBy('date')
          .get();

      return snap.docs.map((d) => d.data()).toList();
    } catch (_) {
      return [];
    }
  }

  // ─── SAUVEGARDER UNE SESSION ─────────────────────────────
  static Future<void> saveSession(int nbFautes) async {
    if (uid == null) return;
    try {
      await _userDoc.collection('sessions').add({
        'date': FieldValue.serverTimestamp(),
        'nbFautes': nbFautes,
      });
    } catch (_) {}
  }

  // ─── PROGRESSION DES LEÇONS ──────────────────────────────
  static Future<Map<String, dynamic>> getLessonProgress(String lessonId) async {
    if (uid == null) return {'consecutiveSuccesses': 0, 'totalAttempts': 0};
    try {
      final doc =
          await _userDoc.collection('lessonProgress').doc(lessonId).get();
      if (!doc.exists) return {'consecutiveSuccesses': 0, 'totalAttempts': 0};
      return doc.data() as Map<String, dynamic>;
    } catch (_) {
      return {'consecutiveSuccesses': 0, 'totalAttempts': 0};
    }
  }

  static Future<void> saveLessonResult({
    required String lessonId,
    required bool success,
    required int durationSeconds,
    required String lessonTitre,
    required String lessonEmoji,
  }) async {
    if (uid == null) return;
    try {
      final ref = _userDoc.collection('lessonProgress').doc(lessonId);
      final doc = await ref.get();
      final data =
          doc.exists ? doc.data() as Map<String, dynamic> : <String, dynamic>{};
      final prev = (data['consecutiveSuccesses'] ?? 0) as int;
      final consec = success ? prev + 1 : 0;
      final durations = List<int>.from(data['durations'] ?? []);
      durations.add(durationSeconds);
      if (durations.length > 10) durations.removeAt(0);

      await ref.set({
        'lessonId': lessonId,
        'lessonTitre': lessonTitre,
        'lessonEmoji': lessonEmoji,
        'consecutiveSuccesses': consec,
        'totalAttempts': FieldValue.increment(1),
        'isAcquise': consec >= 3,
        'durations': durations,
        'lastAttempt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (_) {}
  }

  static Future<List<Map<String, dynamic>>> getAcquisLecons() async {
    if (uid == null) return [];
    try {
      final snap = await _userDoc
          .collection('lessonProgress')
          .where('isAcquise', isEqualTo: true)
          .orderBy('lastAttempt', descending: true)
          .get();
      return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<int> getTempsMoyenLecon() async {
    if (uid == null) return 600;
    try {
      final snap = await _userDoc
          .collection('lessonProgress')
          .orderBy('lastAttempt', descending: true)
          .limit(10)
          .get();
      final allDurations = <int>[];
      for (final doc in snap.docs) {
        final durations = List<int>.from(doc.data()['durations'] ?? []);
        allDurations.addAll(durations);
      }
      if (allDurations.isEmpty) return 600;
      return (allDurations.reduce((a, b) => a + b) / allDurations.length)
          .round();
    } catch (_) {
      return 600;
    }
  }

  // ─── LEÇONS SAUVEGARDÉES ─────────────────────────────────
  static Future<void> saveLecon(
      String lessonId, Map<String, dynamic> data) async {
    if (uid == null) return;
    try {
      await _userDoc.collection('savedLecons').doc(lessonId).set({
        ...data,
        'savedAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {}
  }

  static Future<void> unsaveLecon(String lessonId) async {
    if (uid == null) return;
    try {
      await _userDoc.collection('savedLecons').doc(lessonId).delete();
    } catch (_) {}
  }

  static Future<bool> isLeconSaved(String lessonId) async {
    if (uid == null) return false;
    try {
      final doc =
          await _userDoc.collection('savedLecons').doc(lessonId).get();
      return doc.exists;
    } catch (_) {
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getSavedLecons() async {
    if (uid == null) return [];
    try {
      final snap = await _userDoc
          .collection('savedLecons')
          .orderBy('savedAt', descending: true)
          .get();
      return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
    } catch (_) {
      return [];
    }
  }
}