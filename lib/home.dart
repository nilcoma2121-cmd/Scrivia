import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme.dart';
import 'services/firebase_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loading = true;

  int _score = 0;
  int _streak = 0;
  int _totalTextes = 0;
  int _totalFautes = 0;
  List<Map<String, dynamic>> _fautes = [];
  List<Map<String, dynamic>> _sessions = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final stats = await FirebaseService.getStats();
    final fautes = await FirebaseService.getFautes(limit: 6);
    final sessions = await FirebaseService.getFautesParJour();
    setState(() {
      _score = stats['score'] ?? 0;
      _streak = stats['streak'] ?? 0;
      _totalTextes = stats['totalTextes'] ?? 0;
      _totalFautes = stats['totalFautes'] ?? 0;
      _fautes = fautes;
      _sessions = sessions;
      _loading = false;
    });
  }

  double get _moyenneFautes {
    if (_totalTextes == 0) return 0;
    return _totalFautes / _totalTextes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(
        child: _loading
            ? Center(child: CircularProgressIndicator(color: C.accent))
            : RefreshIndicator(
                onRefresh: _loadData,
                color: C.accent,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 14),
                      _header(),
                      const SizedBox(height: 16),

                      // État vide — premier lancement
                      if (_totalTextes == 0) ...[
                        _emptyState(),
                        const SizedBox(height: 12),
                      ] else ...[
                        _scoreCard(),
                        const SizedBox(height: 12),
                        _statsRow(),
                        const SizedBox(height: 12),
                        _weekBars(),
                        const SizedBox(height: 12),
                      ],

                      _actions(),
                      const SizedBox(height: 12),

                      // Leçons acquises (statique pour l'instant)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('✅ Leçons acquises',
                              style: GoogleFonts.syne(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: C.dark)),
                          Text('Voir toutes',
                              style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: C.accent)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _lessonCard('✓', 'Pluriels en -eux',
                          '0 faute depuis 14j 🎉', C.green, 'Maîtrisé'),
                      _lessonCard('✓', 'Majuscules',
                          '0 faute depuis 21j', C.green, 'Maîtrisé'),
                      const SizedBox(height: 12),

                      // Leçons ciblées basées sur fautes Firebase
                      if (_fautes.isNotEmpty) ...[
                        _lessonTitle(),
                        const SizedBox(height: 10),
                        ..._fautes.take(3).map((f) {
                          final mot = f['mot'] ?? '';
                          final count = f['count'] ?? 0;
                          final maxCount =
                              (_fautes.first['count'] ?? 1) as int;
                          final pct = count / maxCount;
                          final color = pct > 0.7
                              ? C.red
                              : pct > 0.4
                                  ? C.orange
                                  : C.accent;
                          final badge =
                              count > 5 ? 'Priorité 🔥' : '${count}×';
                          return _lessonCard(
                            mot.isNotEmpty ? mot[0].toUpperCase() : '?',
                            'Faute : "$mot"',
                            '${count}× cette semaine',
                            color,
                            badge,
                          );
                        }),
                      ],

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  // ─── ÉTAT VIDE ───────────────────────────────────────────
  Widget _emptyState() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [C.accent, C.accent2]),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('👋 Bienvenue sur Scrivia !',
              style: GoogleFonts.syne(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white)),
          const SizedBox(height: 8),
          Text(
              'Écris ton premier texte dans l\'espace libre pour commencer à tracker tes fautes et recevoir des leçons personnalisées.',
              style: GoogleFonts.nunito(
                  fontSize: 13, color: Colors.white70, height: 1.5)),
          const SizedBox(height: 14),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(10)),
            child: Text('✍️ Commencer à écrire →',
                style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
          ),
        ],
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
              TextSpan(
                  text: 'Write',
                  style: GoogleFonts.syne(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: C.dark)),
              TextSpan(
                  text: 'Wise',
                  style: GoogleFonts.syne(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: C.accent)),
            ],
          ),
        ),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: _streak > 0 ? C.orangeSoft : C.border,
            borderRadius: BorderRadius.circular(99),
            border: Border.all(
                color: _streak > 0
                    ? C.orange.withOpacity(0.3)
                    : Colors.transparent),
          ),
          child: Text(
              _streak > 0 ? '🔥 ${_streak}j' : '🔥 0j',
              style: GoogleFonts.nunito(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _streak > 0 ? C.orange : C.muted)),
        ),
      ],
    );
  }

  Widget _scoreCard() {
    // Calcul répartition des fautes par catégorie (simplifié)
    return SCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('📊 Ton niveau',
              style: GoogleFonts.syne(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: C.dark)),
          const SizedBox(height: 12),
          Row(
            children: [
              // Cercle score
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: [C.accent, C.accent2, C.green, C.accent],
                    stops: [0, _score / 100, _score / 100, 1.0],
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white),
                    child: Center(
                      child: Text('$_score%',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.syne(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: C.dark)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Score de maîtrise',
                        style: GoogleFonts.nunito(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: C.dark)),
                    const SizedBox(height: 4),
                    Text(
                        _score >= 80
                            ? 'Excellent niveau 🎉'
                            : _score >= 50
                                ? 'Tu progresses bien 💪'
                                : 'Continue à t\'entraîner !',
                        style: GoogleFonts.nunito(
                            fontSize: 11, color: C.muted)),
                    const SizedBox(height: 8),
                    _legendItem(C.accent, 'Total fautes',
                        '$_totalFautes'),
                    _legendItem(
                        C.green, 'Textes écrits', '$_totalTextes'),
                    _legendItem(C.orange, 'Moy. fautes/texte',
                        _moyenneFautes.toStringAsFixed(1)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3))),
          const SizedBox(width: 7),
          Expanded(
              child: Text(label,
                  style: GoogleFonts.nunito(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: C.text))),
          Text(val,
              style: GoogleFonts.nunito(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: C.muted)),
        ],
      ),
    );
  }

  Widget _statsRow() {
    return Row(
      children: [
        _statCard(_moyenneFautes.toStringAsFixed(1), 'TAUX DE FAUTES',
            C.orange),
        const SizedBox(width: 10),
        _statCard('$_score%', 'SCORE GLOBAL', C.green),
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
            Text(label,
                style: GoogleFonts.nunito(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: C.muted,
                    letterSpacing: 0.5)),
            const SizedBox(height: 4),
            Text(val,
                style: GoogleFonts.syne(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: color)),
            Text(
                _totalTextes == 0
                    ? 'Pas encore de données'
                    : '$_totalTextes texte${_totalTextes > 1 ? 's' : ''} analysé${_totalTextes > 1 ? 's' : ''}',
                style: GoogleFonts.nunito(
                    fontSize: 10,
                    color: C.muted,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _weekBars() {
    if (_sessions.isEmpty) return const SizedBox.shrink();

    final maxFautes = _sessions
        .map((s) => (s['nbFautes'] as int? ?? 0))
        .fold(0, (a, b) => a > b ? a : b);

    return SCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('📅 Fautes par session',
              style: GoogleFonts.syne(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: C.dark)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: _sessions.take(7).toList().asMap().entries.map((e) {
              final nb = e.value['nbFautes'] as int? ?? 0;
              final height =
                  maxFautes > 0 ? (nb / maxFautes * 50).toDouble() : 4.0;
              final color =
                  nb > 6 ? C.red : nb > 3 ? C.orange : C.green;
              return _bar('${e.key + 1}', height.clamp(4, 50), color);
            }).toList(),
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
          width: 28,
          height: height,
          decoration: BoxDecoration(
            color: color.withOpacity(0.7),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(5)),
          ),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: GoogleFonts.nunito(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: C.muted)),
      ],
    );
  }

  Widget _actions() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: C.accentSoft,
                borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🔍', style: TextStyle(fontSize: 22)),
                const SizedBox(height: 6),
                Text('Mes fautes',
                    style: GoogleFonts.syne(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: C.dark)),
                Text(
                    _totalFautes > 0
                        ? '$_totalFautes fautes trackées'
                        : 'Aucune faute encore',
                    style:
                        GoogleFonts.nunito(fontSize: 10, color: C.muted)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: C.greenSoft,
                borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('💪', style: TextStyle(fontSize: 22)),
                const SizedBox(height: 6),
                Text('M\'entraîner',
                    style: GoogleFonts.syne(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: C.dark)),
                Text(
                    _streak > 0
                        ? 'Streak : $_streak jour${_streak > 1 ? 's' : ''} 🔥'
                        : 'Quiz ciblés',
                    style:
                        GoogleFonts.nunito(fontSize: 10, color: C.muted)),
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
        Text('🎯 Leçons ciblées',
            style: GoogleFonts.syne(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: C.dark)),
        Text('Voir toutes',
            style: GoogleFonts.nunito(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: C.accent)),
      ],
    );
  }

  Widget _lessonCard(
      String ico, String title, String sub, Color color, String badge) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: color, width: 4)),
        boxShadow: [
          BoxShadow(
              color: C.dark.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(11)),
            child: Center(
                child: Text(ico,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: color))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: C.dark)),
                Text(sub,
                    style: GoogleFonts.nunito(
                        fontSize: 10, color: C.muted)),
              ],
            ),
          ),
          SBadge(text: badge, color: color),
        ],
      ),
    );
  }
}