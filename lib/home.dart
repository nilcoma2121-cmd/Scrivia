import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
              _header(),
              const SizedBox(height: 16),
              _scoreCard(),
              const SizedBox(height: 12),
              _statsRow(),
              const SizedBox(height: 12),
              _weekBars(),
              const SizedBox(height: 12),
              _actions(),
              Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text('✅ Leçons acquises', style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w800, color: C.dark)),
    Text('Voir toutes', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700, color: C.accent)),
  ],
),
const SizedBox(height: 10),
_lessonCard('✓', 'Pluriels en -eux', '0 faute depuis 14j 🎉', C.green, 'Maîtrisé'),
_lessonCard('✓', 'Majuscules', '0 faute depuis 21j', C.green, 'Maîtrisé'),const SizedBox(height: 20),
              _lessonTitle(),
              const SizedBox(height: 10),
              _lessonCard('é', 'Accents — é, è, à', '40% de tes fautes', C.red, 'Priorité 🔥'),
              _lessonCard('a/à', 'a vs à', 'En cours · 60%', C.accent, '60%'),
              _lessonCard('se/ce', 'se vs ce', 'En cours · 45%', C.accent, '45%'),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(text: 'Write', style: GoogleFonts.syne(fontSize: 22, fontWeight: FontWeight.w800, color: C.dark)),
              TextSpan(text: 'Wise', style: GoogleFonts.syne(fontSize: 22, fontWeight: FontWeight.w800, color: C.accent)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: C.orangeSoft,
            borderRadius: BorderRadius.circular(99),
            border: Border.all(color: C.orange.withOpacity(0.3)),
          ),
          child: Text('🔥 7 jours', style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w700, color: C.orange)),
        ),
      ],
    );
  }

  Widget _scoreCard() {
    return SCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('📊 Répartition de tes fautes', style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700, color: C.dark)),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 84, height: 84,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: [C.red, C.orange, C.accent, C.green, C.red],
                    stops: [0, 0.33, 0.6, 0.8, 1.0],
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 52, height: 52,
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                    child: Center(
                      child: Text('47\nfautes', textAlign: TextAlign.center,
                          style: GoogleFonts.syne(fontSize: 10, fontWeight: FontWeight.w800, color: C.dark)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    _legendItem(C.red, 'Accents', '33%'),
                    _legendItem(C.orange, 'Conjugaison', '27%'),
                    _legendItem(C.accent, 'Accords', '20%'),
                    _legendItem(C.green, 'Ponctuation', '20%'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label, String pct) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Container(width: 9, height: 9, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
          const SizedBox(width: 7),
          Expanded(child: Text(label, style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w600, color: C.text))),
          Text(pct, style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w700, color: C.muted)),
        ],
      ),
    );
  }

  Widget _statsRow() {
    return Row(
      children: [
        _statCard('2.4', 'TAUX DE FAUTES', C.orange),
        const SizedBox(width: 10),
        _statCard('78%', 'SCORE GLOBAL', C.green),
      ],
    );
  }

  Widget _statCard(String val, String label, Color color) {
    return Expanded(
      child: SCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: GoogleFonts.nunito(fontSize: 10, fontWeight: FontWeight.w700, color: C.muted, letterSpacing: 0.5)),
            const SizedBox(height: 4),
            Text(val, style: GoogleFonts.syne(fontSize: 26, fontWeight: FontWeight.w800, color: color)),
            Text('↓ -0.8 ce mois', style: GoogleFonts.nunito(fontSize: 10, color: C.green, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _weekBars() {
    return SCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('📅 Fautes par jour', style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700, color: C.dark)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _bar('L', 42, C.red),
              _bar('M', 32, C.orange),
              _bar('M', 36, C.orange),
              _bar('J', 24, C.accent),
              _bar('V', 16, C.green),
              _bar('S', 10, C.green),
              _bar('D', 6, C.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bar(String label, double height, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 28, height: height,
          decoration: BoxDecoration(
            color: color.withOpacity(0.7),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: GoogleFonts.nunito(fontSize: 9, fontWeight: FontWeight.w700, color: C.muted)),
      ],
    );
  }

  Widget _actions() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: C.accentSoft, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🔍', style: TextStyle(fontSize: 22)),
                const SizedBox(height: 6),
                Text('Mes fautes', style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w800, color: C.dark)),
                Text('Erreurs fréquentes', style: GoogleFonts.nunito(fontSize: 10, color: C.muted)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: C.greenSoft, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('💪', style: TextStyle(fontSize: 22)),
                const SizedBox(height: 6),
                Text('M\'entraîner', style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w800, color: C.dark)),
                Text('Quiz ciblés', style: GoogleFonts.nunito(fontSize: 10, color: C.muted)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _lessonTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('🎯 Leçons ciblées', style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w800, color: C.dark)),
        Text('Voir toutes', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700, color: C.accent)),
      ],
    );
  }

  Widget _lessonCard(String ico, String title, String sub, Color color, String badge) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: color, width: 4)),
        boxShadow: [BoxShadow(color: C.dark.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(11)),
            child: Center(child: Text(ico, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: color))),
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
    );
  }
}