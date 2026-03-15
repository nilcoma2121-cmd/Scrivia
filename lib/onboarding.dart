import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0;
  String _objectif = 'Partout';
  String _frequence = '3×/semaine';
  List<String> _problemes = [];
  bool _loading = false;

  Future<void> _finish() async {
    setState(() => _loading = true);
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'nom': user.displayName ?? '',
        'email': user.email ?? '',
        'objectif': _objectif,
        'frequence': _frequence,
        'problemes': _problemes,
        'onboardingDone': true,
        'createdAt': FieldValue.serverTimestamp(),
        'score': 0,
        'streak': 0,
      });
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Barre de progression
            LinearProgressIndicator(
              value: (_step + 1) / 5,
              backgroundColor: C.border,
              valueColor: const AlwaysStoppedAnimation(C.accent),
              minHeight: 4,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: [
                  _step0(),
                  _step1(),
                  _step2(),
                  _step3(),
                  _step4(),
                ][_step],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── ÉTAPE 0 — LE CONSTAT ────────────────────────────────
  Widget _step0() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1535),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Un fait qui dérange', style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white38, letterSpacing: 1.5)),
              const SizedBox(height: 14),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: "L'IA corrige tes fautes.\n", style: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
                    TextSpan(text: "Tu les répètes quand même.", style: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.w800, color: C.red)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text("Parce que les correcteurs auto corrigent sans expliquer.",
                  style: GoogleFonts.nunito(fontSize: 13, color: Colors.white54, height: 1.6)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _statCard('−25%', "du niveau orthographe en 20 ans", C.red),
        _statCard('72%', "des utilisateurs d'IA font moins attention", C.accent),
        _statCard('68%', "des DRH signalent plus de fautes depuis 2020", C.green),        const SizedBox(height: 30),
        _nextBtn("Je veux m'en sortir →"),
      ],
    );
  }

  Widget _statCard(String n, String l, Color c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.withOpacity(0.08),
        border: Border(left: BorderSide(color: c, width: 3)),
        borderRadius: const BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
      ),
      child: Row(
        children: [
          Text(n, style: GoogleFonts.syne(fontSize: 24, fontWeight: FontWeight.w800, color: c)),
          const SizedBox(width: 12),
          Expanded(child: Text(l, style: GoogleFonts.nunito(fontSize: 12, color: C.text, height: 1.5))),
        ],
      ),
    );
  }

  // ─── ÉTAPE 1 — DIAGNOSTIC ────────────────────────────────
  Widget _step1() {
    final items = [
      ('🔁', 'Je fais les mêmes fautes', 'Toujours les mêmes erreurs répétées'),
      ('😶', 'Je clique "Accepter" sans lire', 'La correction auto, je valide sans comprendre'),
      ('🤖', 'Je colle dans ChatGPT avant d\'envoyer', 'Pour les emails importants surtout'),
      ('😬', 'J\'ai honte de mes fautes', 'Au boulot, à l\'école, sur les réseaux'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text('Est-ce que tu te reconnais ? 👀', style: GoogleFonts.syne(fontSize: 22, fontWeight: FontWeight.w800, color: C.dark)),
        const SizedBox(height: 8),
        Text('Sélectionne ce qui te correspond.', style: GoogleFonts.nunito(fontSize: 14, color: C.muted)),
        const SizedBox(height: 20),
        ...items.map((item) {
          final selected = _problemes.contains(item.$1);
          return GestureDetector(
            onTap: () => setState(() {
              selected ? _problemes.remove(item.$1) : _problemes.add(item.$1);
            }),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: selected ? C.accentSoft : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: selected ? C.accent : C.border, width: 1.5),
                boxShadow: [BoxShadow(color: C.dark.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Row(
                children: [
                  Text(item.$1, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.$2, style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700, color: C.dark)),
                        Text(item.$3, style: GoogleFonts.nunito(fontSize: 11, color: C.muted)),
                      ],
                    ),
                  ),
                  if (selected) Icon(Icons.check_circle, color: C.accent, size: 20),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 20),
        _nextBtn('Oui, c\'est moi →'),
      ],
    );
  }

  // ─── ÉTAPE 2 — OBJECTIF ──────────────────────────────────
  Widget _step2() {
    final options = [
      ('🌍', 'Partout', 'Je veux progresser sur tous les fronts'),
      ('💬', 'SMS / Messagerie', 'WhatsApp, iMessage, Messenger'),
      ('📧', 'Emails pro', 'Je veux une image irréprochable'),
      ('📝', 'Rédaction / Études', 'Devoirs, dissertations, rapports'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text('Où veux-tu progresser ?', style: GoogleFonts.syne(fontSize: 22, fontWeight: FontWeight.w800, color: C.dark)),
        const SizedBox(height: 8),
        Text('Scrivia adapte les leçons selon ton contexte.', style: GoogleFonts.nunito(fontSize: 14, color: C.muted)),
        const SizedBox(height: 20),
        ...options.map((opt) {
          final selected = _objectif == opt.$2;
          return GestureDetector(
            onTap: () => setState(() => _objectif = opt.$2),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: selected ? C.accentSoft : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: selected ? C.accent : C.border, width: 1.5),
                boxShadow: [BoxShadow(color: C.dark.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Row(
                children: [
                  Text(opt.$1, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(opt.$2, style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700, color: C.dark)),
                        Text(opt.$3, style: GoogleFonts.nunito(fontSize: 11, color: C.muted)),
                      ],
                    ),
                  ),
                  if (selected) Icon(Icons.check_circle, color: C.accent, size: 20),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 20),
        _nextBtn('Continuer →'),
      ],
    );
  }

  // ─── ÉTAPE 3 — FRÉQUENCE ─────────────────────────────────
  Widget _step3() {
    final options = ['1×/semaine', '2×/semaine', '3×/semaine', '5×/semaine', 'Tous les jours'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text('En combien de temps ?', style: GoogleFonts.syne(fontSize: 22, fontWeight: FontWeight.w800, color: C.dark)),
        const SizedBox(height: 8),
        Text('Les leçons durent 5 à 15 min. La régularité prime.', style: GoogleFonts.nunito(fontSize: 14, color: C.muted)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: C.greenSoft, borderRadius: BorderRadius.circular(14)),
          child: Row(
            children: [
              const Text('🏆', style: TextStyle(fontSize: 22)),
              const SizedBox(width: 12),
              Expanded(
                child: Text('En moyenne, les utilisateurs Scrivia éliminent leurs 3 fautes principales en 3 semaines.',
                    style: GoogleFonts.nunito(fontSize: 12, color: const Color(0xFF008060), height: 1.5)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text('Fréquence :', style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700, color: C.dark)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((opt) {
            final selected = _frequence == opt;
            return GestureDetector(
              onTap: () => setState(() => _frequence = opt),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? C.accent : Colors.white,
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(color: selected ? C.accent : C.border),
                ),
                child: Text(opt, style: GoogleFonts.nunito(
                    fontSize: 13, fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : C.muted)),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 30),
        _nextBtn('Continuer →'),
      ],
    );
  }

  // ─── ÉTAPE 4 — CLAVIER ───────────────────────────────────
  Widget _step4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text('Dernière étape 📲', style: GoogleFonts.syne(fontSize: 22, fontWeight: FontWeight.w800, color: C.dark)),
        const SizedBox(height: 8),
        Text('Installe le clavier Scrivia pour détecter tes fautes dans toutes tes apps.',
            style: GoogleFonts.nunito(fontSize: 14, color: C.muted, height: 1.6)),
        const SizedBox(height: 20),
        _stepItem(true, '1', 'Ouvrir les Réglages', 'Réglages → Général → Clavier → Claviers'),
        _stepItem(true, '2', 'Ajouter Scrivia', 'Appuyer sur "Ajouter un clavier" → Scrivia'),
        _stepItem(false, '3', 'Autoriser l\'accès complet', 'Nécessaire pour envoyer les fautes vers l\'app'),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: C.accentSoft,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: C.accent.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              const Text('🔒', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 10),
              Expanded(
                child: Text('Scrivia ne collecte que tes fautes — jamais le contenu de tes messages.',
                    style: GoogleFonts.nunito(fontSize: 12, color: C.text, height: 1.5)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _loading ? null : () async {
              await _finish();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: C.accent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            child: _loading
                ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                : Text('C\'est parti — commencer à progresser →',
                    style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _stepItem(bool done, String num, String title, String sub) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: done ? C.greenSoft : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: done ? C.green : C.border),
      ),
      child: Row(
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: done ? C.green : C.accentSoft,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Center(
              child: Text(done ? '✓' : num,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800,
                      color: done ? Colors.white : C.accent)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700, color: C.dark)),
                Text(sub, style: GoogleFonts.nunito(fontSize: 11, color: C.muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _nextBtn(String label) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => setState(() => _step++),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A1535),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: Text(label, style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
      ),
    );
  }
}