import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme.dart';

class LessonsScreen extends StatefulWidget {
  const LessonsScreen({super.key});

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('📚 Mes leçons', style: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.w800, color: C.dark)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(color: C.orangeSoft, borderRadius: BorderRadius.circular(99),
                        border: Border.all(color: C.orange.withOpacity(0.3))),
                    child: Text('🔥 7j', style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w700, color: C.orange)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Leçon du jour
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LessonDetailScreen())),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFFF6B6B), Color(0xFFFF8C42)]),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('✦ Leçon du jour — Prioritaire',
                          style: GoogleFonts.nunito(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white70, letterSpacing: 1)),
                      const SizedBox(height: 6),
                      Text('Les accents — é, è, à',
                          style: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text('12 fautes cette semaine. Cette leçon est faite pour toi.',
                          style: GoogleFonts.nunito(fontSize: 12, color: Colors.white70)),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                        decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10)),
                        child: Text('Commencer →',
                            style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Compteur leçons
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(color: C.bg, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Leçons aujourd\'hui', style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w700, color: C.dark)),
                          Text('Limite gratuite : 3 leçons par jour', style: GoogleFonts.nunito(fontSize: 10, color: C.muted)),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        _dot(true), const SizedBox(width: 4),
                        _dot(true), const SizedBox(width: 4),
                        _dot(false),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Text('2/3', style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w800, color: C.accent)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Tabs
              Row(
                children: [
                  _tabBtn('À faire', 0),
                  const SizedBox(width: 8),
                  _tabBtn('Acquises ✅', 1),
                ],
              ),
              const SizedBox(height: 12),

              // Contenu tabs
              if (_tab == 0) ...[
                _lessonItem(context, 'é', 'Accents — é, è, à', '33% de tes fautes · 12 fois', C.red, 'Priorité 🔥', 0.2),
                _lessonItem(context, 'a/à', 'a vs à — préposition', '27% · En cours', C.accent, '60%', 0.6),
                _lessonItem(context, 'se/ce', 'se vs ce — homophones', '20% · En cours', C.accent, '45%', 0.45),
                _lessonItemLocked('ou/où', 'ou vs où', 'Nouveau · 4 occurrences'),
                const SizedBox(height: 12),
                // Premium banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [C.accent, C.accent2]),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('⭐ Leçons illimitées', style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text('Fais autant de leçons que tu veux, quand tu veux.',
                          style: GoogleFonts.nunito(fontSize: 11, color: Colors.white70)),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(99)),
                        child: Text('Passer Premium →',
                            style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w800, color: C.accent)),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                _acquiseItem('Pluriels en -eux', '0 faute depuis 14 jours'),
                _acquiseItem('Majuscules', '0 faute depuis 21 jours'),
                _acquiseItem('Accord sujet-verbe', '0 faute depuis 9 jours'),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dot(bool active) {
    return Container(
      width: 20, height: 20,
      decoration: BoxDecoration(
        color: active ? C.accent : C.border,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  Widget _tabBtn(String label, int index) {
    final active = _tab == index;
    return GestureDetector(
      onTap: () => setState(() => _tab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? C.accent : Colors.white,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: active ? C.accent : C.border),
        ),
        child: Text(label, style: GoogleFonts.nunito(
            fontSize: 11, fontWeight: FontWeight.w700,
            color: active ? Colors.white : C.muted)),
      ),
    );
  }

  Widget _lessonItem(BuildContext context, String ico, String title, String sub, Color color, String badge, double progress) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LessonDetailScreen())),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: C.dark.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: Center(child: Text(ico, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: color))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700, color: C.dark)),
                      Text(sub, style: GoogleFonts.nunito(fontSize: 10, color: C.muted)),
                    ],
                  ),
                ),
                SBadge(text: badge, color: color),
              ],
            ),
            const SizedBox(height: 10),
            SProgressBar(value: progress, color: color),
          ],
        ),
      ),
    );
  }

  Widget _lessonItemLocked(String ico, String title, String sub) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: C.dark.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(color: C.accentSoft, borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text(ico, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: C.accent))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700, color: C.dark)),
                Text(sub, style: GoogleFonts.nunito(fontSize: 10, color: C.muted)),
              ],
            ),
          ),
          SBadge(text: '⭐ PRO', color: C.accent),
        ],
      ),
    );
  }

  Widget _acquiseItem(String title, String sub) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: const Border(left: BorderSide(color: C.green, width: 3)),
        boxShadow: [BoxShadow(color: C.dark.withOpacity(0.04), blurRadius: 9, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: C.greenSoft, borderRadius: BorderRadius.circular(10)),
            child: const Center(child: Text('✅', style: TextStyle(fontSize: 16))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700, color: C.dark)),
                Text(sub, style: GoogleFonts.nunito(fontSize: 10, color: C.muted)),
              ],
            ),
          ),
          const Text('🏆', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}

// ─── DÉTAIL LEÇON ────────────────────────────────────────────
class LessonDetailScreen extends StatefulWidget {
  const LessonDetailScreen({super.key});

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  final Map<int, bool> _answers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 14),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text('← Retour aux leçons',
                    style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700, color: C.accent)),
              ),
              const SizedBox(height: 16),

              // Hero
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [C.accent, C.accent2]),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('✦ Leçon du jour',
                        style: GoogleFonts.nunito(fontSize: 10, color: Colors.white60, fontWeight: FontWeight.w700, letterSpacing: 1)),
                    const SizedBox(height: 6),
                    Text('Les accents — é, è, à',
                        style: GoogleFonts.syne(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
                    const SizedBox(height: 4),
                    Text('Basée sur tes 12 fautes cette semaine.',
                        style: GoogleFonts.nunito(fontSize: 12, color: Colors.white70)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Règle
              SCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('📌 La règle', style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w800, color: C.dark)),
                    const SizedBox(height: 10),
                    Text('é (aigu) = son fermé : allé, été, mangé\nè (grave) = son ouvert : très, après, problème\nà = préposition ≠ a (verbe avoir)',
                        style: GoogleFonts.nunito(fontSize: 13, color: C.text, height: 1.7)),
                    const SizedBox(height: 12),
                    _example(false, 'Je suis alle au cinema'),
                    _example(true, 'Je suis allé au cinéma'),
                    _example(false, 'Il va a Paris demain'),
                    _example(true, 'Il va à Paris demain'),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Quiz
              SCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('🧠 Quiz — Q1/3', style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w800, color: C.dark)),
                    const SizedBox(height: 10),
                    Text('Complète : "Je suis ___ à la boulangerie."',
                        style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700, color: C.text, height: 1.5)),
                    const SizedBox(height: 12),
                    _quizOption(0, 'alle', false),
                    _quizOption(1, 'allé', true),
                    _quizOption(2, 'aller', false),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: C.accent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: Text('Leçon terminée ✓ — +15 pts 🎉',
                      style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _example(bool correct, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: correct ? C.greenSoft : C.redSoft,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        (correct ? '✅ ' : '❌ ') + text,
        style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w600,
            color: correct ? const Color(0xFF008060) : C.red),
      ),
    );
  }

  Widget _quizOption(int index, String text, bool correct) {
    final answered = _answers.containsKey(index);
    return GestureDetector(
      onTap: () => setState(() => _answers[index] = correct),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: answered ? (correct ? C.greenSoft : C.redSoft) : C.bg,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: answered ? (correct ? C.green : C.red) : C.border,
            width: 2,
          ),
        ),
        child: Text(text, style: GoogleFonts.nunito(
            fontSize: 13, fontWeight: FontWeight.w600,
            color: answered ? (correct ? const Color(0xFF008060) : C.red) : C.dark)),
      ),
    );
  }
}