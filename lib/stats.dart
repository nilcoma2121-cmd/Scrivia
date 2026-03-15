import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme.dart';
import 'services/firebase_service.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  bool _loading = true;

  // Stats globales
  int _score = 0;
  int _streak = 0;
  int _totalTextes = 0;
  int _totalFautes = 0;

  // Fautes fréquentes
  List<Map<String, dynamic>> _fautes = [];

  // Fautes par jour (graphique)
  List<Map<String, dynamic>> _fautesParJour = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final stats = await FirebaseService.getStats();
    final fautes = await FirebaseService.getFautes(limit: 10);
    final parJour = await FirebaseService.getFautesParJour();
    setState(() {
      _score = stats['score'] ?? 0;
      _streak = stats['streak'] ?? 0;
      _totalTextes = stats['totalTextes'] ?? 0;
      _totalFautes = stats['totalFautes'] ?? 0;
      _fautes = fautes;
      _fautesParJour = parJour;
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('📊 Mes statistiques',
                              style: GoogleFonts.syne(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: C.dark)),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                                color: C.orangeSoft,
                                borderRadius: BorderRadius.circular(99),
                                border: Border.all(
                                    color: C.orange.withOpacity(0.3))),
                            child: Text('🔥 ${_streak}j',
                                style: GoogleFonts.nunito(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: C.orange)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Score banner
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [C.accent, C.accent2]),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('$_score',
                                    style: GoogleFonts.syne(
                                        fontSize: 52,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        height: 1)),
                                Text('%',
                                    style: GoogleFonts.syne(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white54)),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Score de maîtrise',
                                      style: GoogleFonts.nunito(
                                          fontSize: 13,
                                          color: Colors.white70)),
                                  const SizedBox(height: 4),
                                  Text(
                                      _totalTextes == 0
                                          ? 'Écris ton premier texte !'
                                          : '$_totalTextes texte${_totalTextes > 1 ? 's' : ''} analysé${_totalTextes > 1 ? 's' : ''}',
                                      style: GoogleFonts.nunito(
                                          fontSize: 11,
                                          color: Colors.white54)),
                                  const SizedBox(height: 8),
                                  Text(
                                      _score >= 80
                                          ? 'Excellent niveau ! 🎉'
                                          : _score >= 50
                                              ? 'Tu progresses bien 💪'
                                              : 'Continue à t\'entraîner !',
                                      style: GoogleFonts.nunito(
                                          fontSize: 11,
                                          color: Colors.white70)),
                                  const SizedBox(height: 6),
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(99),
                                    child: LinearProgressIndicator(
                                      value: _score / 100,
                                      backgroundColor: Colors.white24,
                                      valueColor:
                                          const AlwaysStoppedAnimation(
                                              Colors.white),
                                      minHeight: 5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 3 stats
                      Row(
                        children: [
                          _s3(_moyenneFautes.toStringAsFixed(1),
                              'Fautes/texte', C.red),
                          const SizedBox(width: 8),
                          _s3('$_totalTextes', 'Textes', C.accent),
                          const SizedBox(width: 8),
                          _s3('${_streak}j', 'Streak', C.green),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Graphique fautes par jour
                      SCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('📅 Fautes par session',
                                style: GoogleFonts.syne(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: C.dark)),
                            const SizedBox(height: 12),
                            _fautesParJour.isEmpty
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Text(
                                          'Pas encore de données.\nÉcris ton premier texte !',
                                          style: GoogleFonts.nunito(
                                              fontSize: 12,
                                              color: C.muted),
                                          textAlign: TextAlign.center),
                                    ),
                                  )
                                : _buildGraphique(),
                            if (_fautesParJour.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Center(
                                child: Text(
                                    _isTendanceBaisse()
                                        ? '📈 Tendance à la baisse — continue !'
                                        : '💪 Continue à t\'entraîner !',
                                    style: GoogleFonts.nunito(
                                        fontSize: 10, color: C.muted)),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Top fautes
                      if (_fautes.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('🔁 Fautes les plus fréquentes',
                                style: GoogleFonts.syne(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: C.dark)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ..._fautes.take(5).map((f) {
                          final mot = f['mot'] ?? '';
                          final correction = f['correction'] ?? '';
                          final count = f['count'] ?? 0;
                          final maxCount =
                              (_fautes.first['count'] ?? 1) as int;
                          final pct = count / maxCount;
                          final color = pct > 0.7
                              ? C.red
                              : pct > 0.4
                                  ? C.orange
                                  : C.accent;
                          return _fauteRow(
                              mot.isNotEmpty ? mot[0].toUpperCase() : '?',
                              '"$mot" → $correction',
                              pct.toDouble(),
                              '${count}×',
                              color);
                        }),

                        // Lock premium si plus de 5 fautes
                        if (_fautes.length > 5)
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: C.accentSoft,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: C.accent.withOpacity(0.2)),
                            ),
                            child: Row(
                              children: [
                                const Text('🔒',
                                    style: TextStyle(fontSize: 20)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          '+${_fautes.length - 5} fautes cachées',
                                          style: GoogleFonts.nunito(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: C.accent)),
                                      Text(
                                          'Passe à Premium pour tout voir',
                                          style: GoogleFonts.nunito(
                                              fontSize: 10,
                                              color: C.muted)),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                      color: C.accent,
                                      borderRadius:
                                          BorderRadius.circular(99)),
                                  child: Text('⭐ PRO',
                                      style: GoogleFonts.nunito(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white)),
                                ),
                              ],
                            ),
                          ),
                      ],

                      // État vide
                      if (_fautes.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: C.border),
                          ),
                          child: Column(
                            children: [
                              const Text('✍️',
                                  style: TextStyle(fontSize: 36)),
                              const SizedBox(height: 10),
                              Text('Aucune faute pour l\'instant',
                                  style: GoogleFonts.syne(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: C.dark)),
                              const SizedBox(height: 4),
                              Text(
                                  'Écris un texte dans l\'espace libre pour commencer à tracker tes fautes.',
                                  style: GoogleFonts.nunito(
                                      fontSize: 12, color: C.muted),
                                  textAlign: TextAlign.center),
                            ],
                          ),
                        ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildGraphique() {
    final maxFautes = _fautesParJour
        .map((s) => (s['nbFautes'] as int? ?? 0))
        .fold(0, (a, b) => a > b ? a : b);

    final labels = ['1', '2', '3', '4', '5', '6', '7'];
    final sessions = _fautesParJour.take(7).toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(sessions.length, (i) {
        final nb = sessions[i]['nbFautes'] as int? ?? 0;
        final height = maxFautes > 0 ? (nb / maxFautes * 60).toDouble() : 4.0;
        final color = nb > 6 ? C.red : nb > 3 ? C.orange : C.green;
        return _bar(labels[i % labels.length], height.clamp(4, 60), color,
            '$nb');
      }),
    );
  }

  bool _isTendanceBaisse() {
    if (_fautesParJour.length < 2) return false;
    final first = _fautesParJour.first['nbFautes'] as int? ?? 0;
    final last = _fautesParJour.last['nbFautes'] as int? ?? 0;
    return last < first;
  }

  Widget _s3(String val, String label, Color color) {
    return Expanded(
      child: SCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(val,
                style: GoogleFonts.syne(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: color)),
            const SizedBox(height: 2),
            Text(label,
                style: GoogleFonts.nunito(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: C.muted),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _bar(String label, double height, Color color, String count) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(count,
            style: GoogleFonts.nunito(
                fontSize: 8, fontWeight: FontWeight.w700, color: color)),
        const SizedBox(height: 2),
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

  Widget _fauteRow(
      String ico, String title, double pct, String count, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
              color: C.dark.withOpacity(0.04),
              blurRadius: 9,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(ico, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(title,
                      style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: C.dark))),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(99)),
                child: Text(count,
                    style: GoogleFonts.nunito(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: color)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SProgressBar(value: pct, color: color),
        ],
      ),
    );
  }
}