import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme.dart';
import 'services/languagetool_service.dart';
import 'services/gemini_service.dart';
import 'services/firebase_service.dart';

class WriteScreen extends StatefulWidget {
  const WriteScreen({super.key});

  @override
  State<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  int _tab = 0;

  // ─── ESPACE LIBRE ───
  final _controller = TextEditingController();
  bool _showResult = false;
  bool _saving = false;
  final _ltService = LanguageToolService();
  List<Map<String, dynamic>> _erreurs = [];
  bool _loading = false;
  Timer? _debounce;

  // ─── JEU ───
  final _geminiService = GeminiService();
  List<GameQuestion> _questions = [];
  bool _loadingQuestions = true;
  int _questionIndex = 0;
  late List<String?> _selectedAnswers;
  int _trouActif = 0;
  bool _corrected = false;
  int _score = 0;
  bool _gameFinished = false;
  List<Map<String, dynamic>> _erreursJeu = [];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    _controller.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 800), () {
        _checkLive(_controller.text);
      });
    });
  }

  Future<void> _loadQuestions() async {
    setState(() => _loadingQuestions = true);
    // Récupère les vraies fautes Firebase pour personnaliser les questions
    final fautes = await FirebaseService.getFauteMots(limit: 10);
    final questions = await _geminiService.generateQuestions(fautes);
    setState(() {
      _questions = questions;
      _loadingQuestions = false;
      _initQuestion();
    });
  }

  void _initQuestion() {
    if (_questions.isEmpty) return;
    final q = _questions[_questionIndex];
    _selectedAnswers = List.filled(q.trous.length, null);
    _trouActif = 0;
    _corrected = false;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkLive(String text) async {
    if (text.trim().isEmpty) {
      setState(() => _erreurs = []);
      return;
    }
    setState(() => _loading = true);
    final result = await _ltService.checkText(text);
    setState(() {
      _erreurs = result;
      _loading = false;
    });
  }

  // Sauvegarde les fautes dans Firebase et affiche le bilan
  Future<void> _showBilan() async {
    setState(() {
      _showResult = true;
      _saving = true;
    });
    await FirebaseService.saveFautes(_erreurs);
    await FirebaseService.saveSession(_erreurs.length);
    await FirebaseService.updateStreak();
    setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('✍️ Écrire',
                      style: GoogleFonts.syne(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: C.dark)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                        color: C.orangeSoft,
                        borderRadius: BorderRadius.circular(99),
                        border: Border.all(color: C.orange.withOpacity(0.3))),
                    child: Text('🔥 7j',
                        style: GoogleFonts.nunito(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: C.orange)),
                  ),
                ],
              ),
            ),

            // Tabs
            Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: C.border)),
              ),
              child: Row(
                children: [
                  _tabBtn('📄 Espace libre', 0),
                  _tabBtn('🎧 Dictée', 1),
                  _tabBtn('🎮 Jeu', 2),
                ],
              ),
            ),

            Expanded(
              child: _tab == 0
                  ? _libreMode()
                  : _tab == 1
                      ? _dicteeMode()
                      : _jeuMode(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabBtn(String label, int index) {
    final active = _tab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
              color: active ? C.accent : Colors.transparent,
              width: 2,
            )),
          ),
          child: Text(label,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: active ? C.accent : C.muted)),
        ),
      ),
    );
  }

  // ─── MODE ESPACE LIBRE ───────────────────────────────────
  Widget _libreMode() {
    final nbFautes = _erreurs.length;

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: SCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          maxLines: null,
                          expands: true,
                          style: GoogleFonts.nunito(
                              fontSize: 15, color: C.dark, height: 2.0),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(16),
                            border: InputBorder.none,
                            hintText:
                                'Écris librement ici...\nTes fautes seront soulignées 🔴',
                            hintStyle: GoogleFonts.nunito(
                                color: C.muted,
                                fontStyle: FontStyle.italic,
                                height: 2.0),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: const BoxDecoration(
                            border: Border(top: BorderSide(color: C.border))),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                  color: nbFautes > 0 ? C.redSoft : C.greenSoft,
                                  borderRadius: BorderRadius.circular(99)),
                              child: _loading
                                  ? const SizedBox(
                                      width: 10,
                                      height: 10,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 1.5, color: C.muted))
                                  : Text(
                                      nbFautes > 0
                                          ? '● $nbFautes faute${nbFautes > 1 ? 's' : ''}'
                                          : '✓ Aucune faute',
                                      style: GoogleFonts.nunito(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: nbFautes > 0
                                              ? C.red
                                              : C.green)),
                            ),
                            const SizedBox(width: 10),
                            Row(
                              children: [
                                Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: C.green)),
                                const SizedBox(width: 4),
                                Text('Live',
                                    style: GoogleFonts.nunito(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: C.green)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_erreurs.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _erreurs.take(3).map((e) {
                      final mot = e['context']?['text'] ?? '';
                      final suggestion =
                          (e['replacements'] as List?)?.isNotEmpty == true
                              ? e['replacements'][0]['value']
                              : '?';
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _suggestion('$mot → $suggestion'),
                      );
                    }).toList(),
                  ),
                ),
              ),
            if (_erreurs.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    _suggestion('bien →'),
                    const SizedBox(width: 8),
                    _suggestion('vraiment →'),
                    const SizedBox(width: 8),
                    _suggestion('parfait →'),
                  ],
                ),
              ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _controller.text.trim().isEmpty ? null : _showBilan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: C.accent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: Text('✨ Voir le bilan complet',
                      style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(height: 14),
          ],
        ),

        // Popup bilan
        if (_showResult)
          GestureDetector(
            onTap: () => setState(() => _showResult = false),
            child: Container(
              color: Colors.black54,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                          nbFautes == 0
                              ? '🟢'
                              : nbFautes <= 2
                                  ? '🟠'
                                  : '🔴',
                          style: const TextStyle(fontSize: 50)),
                      const SizedBox(height: 10),
                      Text(
                          nbFautes == 0
                              ? 'Parfait !'
                              : '$nbFautes faute${nbFautes > 1 ? 's' : ''} !',
                          style: GoogleFonts.syne(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: nbFautes == 0 ? C.green : C.orange)),
                      const SizedBox(height: 6),
                      Text(
                          _saving
                              ? 'Sauvegarde en cours...'
                              : 'Sauvegardé dans ton profil ✓',
                          style: GoogleFonts.nunito(
                              fontSize: 11,
                              color: _saving ? C.muted : C.green)),
                      const SizedBox(height: 14),
                      ..._erreurs.take(5).map((e) {
                        final mot = e['context']?['text'] ?? '';
                        final suggestion =
                            (e['replacements'] as List?)?.isNotEmpty == true
                                ? e['replacements'][0]['value']
                                : '?';
                        return _resultItem('"$mot" → $suggestion');
                      }),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saving
                              ? null
                              : () => setState(() => _showResult = false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: C.accent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: Text('Voir la leçon 📖',
                              style: GoogleFonts.nunito(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _suggestion(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: C.accentSoft,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: C.accent.withOpacity(0.3)),
      ),
      child: Text(text,
          style: GoogleFonts.nunito(
              fontSize: 12, fontWeight: FontWeight.w700, color: C.accent)),
    );
  }

  Widget _resultItem(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: C.redSoft, borderRadius: BorderRadius.circular(9)),
      child: Row(
        children: [
          Container(
              width: 5,
              height: 5,
              decoration:
                  const BoxDecoration(shape: BoxShape.circle, color: C.red)),
          const SizedBox(width: 8),
          Expanded(
              child: Text(text,
                  style: GoogleFonts.nunito(fontSize: 11, color: C.text))),
        ],
      ),
    );
  }

  // ─── MODE JEU ────────────────────────────────────────────
  Widget _jeuMode() {
    if (_loadingQuestions) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: C.accent),
            const SizedBox(height: 16),
            Text('Gemini prépare tes questions...',
                style: GoogleFonts.nunito(fontSize: 13, color: C.muted)),
          ],
        ),
      );
    }

    if (_gameFinished) return _gameResultScreen();
    if (_questions.isEmpty)
      return const Center(child: Text('Erreur de chargement'));

    final q = _questions[_questionIndex];
    final progress = (_questionIndex + 1) / _questions.length;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Question ${_questionIndex + 1} / ${_questions.length}',
                      style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: C.muted)),
                  Text('⭐ $_score pts',
                      style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: C.accent)),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: C.border,
                  valueColor: AlwaysStoppedAnimation(C.accent),
                  minHeight: 5,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: [
                SCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Complète la phrase',
                          style: GoogleFonts.nunito(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: C.accent,
                              letterSpacing: 0.8)),
                      const SizedBox(height: 14),
                      _buildPhrase(q),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                if (_corrected) ..._buildExplications(q),

                if (q.trous.length > 1 && !_corrected)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(q.trous.length, (i) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i == _trouActif
                                ? C.accent
                                : _selectedAnswers[i] != null
                                    ? C.green
                                    : C.border,
                          ),
                        );
                      }),
                    ),
                  ),
              ],
            ),
          ),
        ),

        if (!_corrected)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: q.reponses.map((rep) {
                final dejaUtilisee = _selectedAnswers.contains(rep);
                return GestureDetector(
                  onTap: dejaUtilisee ? null : () => _selectAnswer(rep),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: dejaUtilisee ? C.border : C.accentSoft,
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(
                          color: dejaUtilisee
                              ? Colors.transparent
                              : C.accent.withOpacity(0.4)),
                    ),
                    child: Text(rep,
                        style: GoogleFonts.nunito(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: dejaUtilisee ? C.muted : C.accent)),
                  ),
                );
              }).toList(),
            ),
          ),

        const SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _corrected
                  ? _nextQuestion
                  : _selectedAnswers.every((a) => a != null)
                      ? _corriger
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _corrected ? C.green : C.accent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: Text(
                _corrected
                    ? (_questionIndex < _questions.length - 1
                        ? 'Question suivante →'
                        : 'Voir mon score 🏆')
                    : 'Corriger ✓',
                style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  List<Widget> _buildExplications(GameQuestion q) {
    List<Widget> widgets = [];
    for (int i = 0; i < q.trous.length; i++) {
      final correct = _selectedAnswers[i] == q.bonnesReponses[i];
      if (!correct && i < q.explications.length) {
        widgets.add(
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: C.redSoft,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: C.red.withOpacity(0.2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('💡 ', style: TextStyle(fontSize: 14)),
                Expanded(
                  child: Text(q.explications[i],
                      style: GoogleFonts.nunito(
                          fontSize: 12, color: C.text, height: 1.5)),
                ),
              ],
            ),
          ),
        );
      }
    }
    return widgets;
  }

  Widget _buildPhrase(GameQuestion q) {
    final parts = q.phrase.split('___');
    List<Widget> widgets = [];

    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isNotEmpty) {
        widgets.add(Text(parts[i],
            style: GoogleFonts.nunito(
                fontSize: 18,
                color: C.dark,
                fontWeight: FontWeight.w600)));
      }

      if (i < q.trous.length) {
        final filled = _selectedAnswers[i];
        final isActive = i == _trouActif && !_corrected;
        Color? couleur;
        if (_corrected) {
          couleur = filled == q.bonnesReponses[i] ? C.green : C.red;
        } else if (isActive) {
          couleur = C.accent;
        }

        widgets.add(
          GestureDetector(
            onTap: filled != null && !_corrected
                ? () => _unselectAnswer(i)
                : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: couleur?.withOpacity(0.15) ??
                    (isActive
                        ? C.accent.withOpacity(0.08)
                        : C.border.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: couleur ?? (isActive ? C.accent : C.border),
                    width: 1.5),
              ),
              child: Text(
                filled ?? '   ',
                style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: couleur ?? C.muted),
              ),
            ),
          ),
        );
      }
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: widgets,
    );
  }

  void _selectAnswer(String rep) {
    if (_trouActif >= _selectedAnswers.length) return;
    setState(() {
      _selectedAnswers[_trouActif] = rep;
      for (int i = 0; i < _selectedAnswers.length; i++) {
        if (_selectedAnswers[i] == null) {
          _trouActif = i;
          return;
        }
      }
      _trouActif = _selectedAnswers.length;
    });
  }

  void _unselectAnswer(int index) {
    setState(() {
      _selectedAnswers[index] = null;
      _trouActif = index;
    });
  }

  void _corriger() {
    final q = _questions[_questionIndex];
    int points = 0;
    for (int i = 0; i < q.bonnesReponses.length; i++) {
      final correct = _selectedAnswers[i] == q.bonnesReponses[i];
      if (correct) {
        points++;
      } else {
        _erreursJeu.add({
          'phrase': q.phrase,
          'trou': i,
          'reponseChoisie': _selectedAnswers[i],
          'bonneReponse': q.bonnesReponses[i],
          'explication':
              i < q.explications.length ? q.explications[i] : '',
        });
      }
    }
    setState(() {
      _score += points;
      _corrected = true;
    });
  }

  void _nextQuestion() {
    if (_questionIndex < _questions.length - 1) {
      setState(() {
        _questionIndex++;
        _initQuestion();
      });
    } else {
      // Sauvegarde les fautes du jeu dans Firebase
      FirebaseService.saveGameFautes(_erreursJeu);
      setState(() => _gameFinished = true);
    }
  }

  Widget _gameResultScreen() {
    final total = _questions.fold<int>(
        0, (sum, q) => sum + q.bonnesReponses.length);
    final pct = total > 0 ? (_score / total * 100).round() : 0;
    final emoji = pct >= 80 ? '🏆' : pct >= 50 ? '🟠' : '😅';
    final message = pct >= 80
        ? 'Excellent !'
        : pct >= 50
            ? 'Pas mal !'
            : 'Continue à t\'entraîner !';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(emoji, style: const TextStyle(fontSize: 64)),
          const SizedBox(height: 12),
          Text(message,
              style: GoogleFonts.syne(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: C.dark)),
          const SizedBox(height: 6),
          Text('$_score / $total bonnes réponses ($pct%)',
              style: GoogleFonts.nunito(fontSize: 14, color: C.muted)),
          const SizedBox(height: 4),
          Text('Fautes sauvegardées dans ton profil ✓',
              style: GoogleFonts.nunito(fontSize: 11, color: C.green)),

          if (_erreursJeu.isNotEmpty) ...[
            const SizedBox(height: 28),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('📋 Tes erreurs',
                  style: GoogleFonts.syne(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: C.dark)),
            ),
            const SizedBox(height: 12),
            ..._erreursJeu.map((e) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: C.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e['phrase'],
                        style: GoogleFonts.nunito(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: C.dark),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                                color: C.redSoft,
                                borderRadius: BorderRadius.circular(99)),
                            child: Text('✗ ${e['reponseChoisie']}',
                                style: GoogleFonts.nunito(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: C.red)),
                          ),
                          const SizedBox(width: 8),
                          const Text('→',
                              style: TextStyle(color: Colors.grey)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                                color: C.greenSoft,
                                borderRadius: BorderRadius.circular(99)),
                            child: Text('✓ ${e['bonneReponse']}',
                                style: GoogleFonts.nunito(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: C.green)),
                          ),
                        ],
                      ),
                      if ((e['explication'] as String).isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('💡 ',
                                style: TextStyle(fontSize: 12)),
                            Expanded(
                              child: Text(e['explication'],
                                  style: GoogleFonts.nunito(
                                      fontSize: 12,
                                      color: C.muted,
                                      height: 1.4)),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                )),
          ],

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _questionIndex = 0;
                  _score = 0;
                  _gameFinished = false;
                  _erreursJeu = [];
                });
                _loadQuestions();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: C.accent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: Text('Rejouer 🔄',
                  style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ─── MODE DICTÉE ─────────────────────────────────────────
  Widget _dicteeMode() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [C.accent, C.accent2]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text('🎧 Dictée personnalisée',
                    style: GoogleFonts.syne(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white)),
                const SizedBox(height: 4),
                Text('Basée sur tes fautes récentes.',
                    style: GoogleFonts.nunito(
                        fontSize: 11, color: Colors.white70)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _dicteeBtn('▶ Écouter', true),
                    const SizedBox(width: 8),
                    _dicteeBtn('↺ Rejouer', false),
                    const SizedBox(width: 8),
                    _dicteeBtn('⏩ +lent', false),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: 0.65,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                    minHeight: 4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Phrase 2 / 5',
                    style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: C.accent)),
                const SizedBox(height: 6),
                Text('"— — — — — — —"',
                    style: GoogleFonts.nunito(
                        fontSize: 13,
                        color: C.muted,
                        fontStyle: FontStyle.italic)),
                const SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Écris ce que tu as entendu...',
                    hintStyle: GoogleFonts.nunito(color: C.muted),
                    filled: true,
                    fillColor: C.bg,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: const BorderSide(color: C.accent)),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: C.accent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11)),
                      elevation: 0,
                    ),
                    child: Text('Valider ✓',
                        style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SCard(
            color: C.bg,
            child: Column(
              children: [
                const Text('🎧', style: TextStyle(fontSize: 28)),
                const SizedBox(height: 6),
                Text('1 dictée / jour — limite atteinte',
                    style: GoogleFonts.syne(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: C.dark)),
                const SizedBox(height: 4),
                Text('Reviens demain ou passe à Premium.',
                    style:
                        GoogleFonts.nunito(fontSize: 11, color: C.muted),
                    textAlign: TextAlign.center),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [C.accent, C.accent2]),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text('⭐ Dictées illimitées',
                      style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dicteeBtn(String label, bool primary) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: primary ? Colors.white : Colors.white24,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label,
          style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: primary ? C.accent : Colors.white)),
    );
  }
}