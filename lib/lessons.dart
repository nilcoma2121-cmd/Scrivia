import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme.dart';
import 'services/firebase_service.dart';
import 'services/gemini_service.dart';

class LessonsScreen extends StatefulWidget {
  const LessonsScreen({super.key});

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  int _tab = 0;
  bool _loading = true;
  Lecon? _leconDuJour;
  List<Map<String, dynamic>> _fautes = [];
  int _streak = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final fautes = await FirebaseService.getFautes(limit: 10);
    final stats = await FirebaseService.getStats();
    final mots = fautes
        .map((f) => f['mot']?.toString() ?? '')
        .where((m) => m.isNotEmpty)
        .toList();

    // Génère la leçon du jour avec Gemini
    final gemini = GeminiService();
    final lecon = await gemini.generateLecon(mots);

    setState(() {
      _fautes = fautes;
      _streak = stats['streak'] ?? 0;
      _leconDuJour = lecon;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(
        child: _loading
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: C.accent),
                    const SizedBox(height: 16),
                    Text('Gemini prépare ta leçon...',
                        style:
                            GoogleFonts.nunito(fontSize: 13, color: C.muted)),
                  ],
                ),
              )
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
                          Text('📚 Mes leçons',
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

                      // Leçon du jour générée par Gemini
                      if (_leconDuJour != null)
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  LessonDetailScreen(lecon: _leconDuJour!),
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFF6B6B),
                                    Color(0xFFFF8C42)
                                  ]),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    '✦ Leçon du jour — Personnalisée par Gemini',
                                    style: GoogleFonts.nunito(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white70,
                                        letterSpacing: 1)),
                                const SizedBox(height: 6),
                                Text(
                                    '${_leconDuJour!.emoji} ${_leconDuJour!.titre}',
                                    style: GoogleFonts.syne(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white)),
                                const SizedBox(height: 4),
                                Text(_leconDuJour!.resume,
                                    style: GoogleFonts.nunito(
                                        fontSize: 12,
                                        color: Colors.white70)),
                                const SizedBox(height: 6),
                                Text('⏱ ${_leconDuJour!.duree}',
                                    style: GoogleFonts.nunito(
                                        fontSize: 11,
                                        color: Colors.white54)),
                                const SizedBox(height: 14),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 9),
                                  decoration: BoxDecoration(
                                      color: Colors.white24,
                                      borderRadius:
                                          BorderRadius.circular(10)),
                                  child: Text('Commencer →',
                                      style: GoogleFonts.nunito(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white)),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // État vide — pas encore de fautes
                      if (_leconDuJour == null || _fautes.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: C.accentSoft,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: C.accent.withOpacity(0.2)),
                          ),
                          child: Column(
                            children: [
                              const Text('✍️',
                                  style: TextStyle(fontSize: 36)),
                              const SizedBox(height: 10),
                              Text('Écris d\'abord un texte !',
                                  style: GoogleFonts.syne(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: C.dark)),
                              const SizedBox(height: 4),
                              Text(
                                  'Tes leçons seront générées à partir de tes vraies fautes.',
                                  style: GoogleFonts.nunito(
                                      fontSize: 12, color: C.muted),
                                  textAlign: TextAlign.center),
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
                        // Leçons basées sur les fautes Firebase
                        if (_fautes.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                  'Aucune leçon pour l\'instant.\nÉcris un texte pour commencer !',
                                  style: GoogleFonts.nunito(
                                      fontSize: 13, color: C.muted),
                                  textAlign: TextAlign.center),
                            ),
                          ),
                        ..._fautes.take(3).map((f) {
                          final mot = f['mot'] ?? '';
                          final count = f['count'] ?? 0;
                          final maxCount =
                              (_fautes.first['count'] ?? 1) as int;
                          final pct = (count / maxCount).toDouble();
                          final color = pct > 0.7
                              ? C.red
                              : pct > 0.4
                                  ? C.accent
                                  : C.accent;
                          return _lessonItem(
                            context,
                            mot.isNotEmpty ? mot[0].toUpperCase() : '?',
                            'Faute : "$mot"',
                            '${count}× cette semaine',
                            color,
                            count > 5 ? 'Priorité 🔥' : '${(pct * 100).round()}%',
                            pct.clamp(0.05, 1.0),
                          );
                        }),

                        if (_fautes.length > 3)
                          _lessonItemLocked(
                            '⭐',
                            '+${_fautes.length - 3} leçons disponibles',
                            'Passe à Premium pour tout voir',
                          ),

                        const SizedBox(height: 12),

                        // Premium banner
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [C.accent, C.accent2]),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('⭐ Leçons illimitées',
                                  style: GoogleFonts.syne(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white)),
                              const SizedBox(height: 4),
                              Text(
                                  'Fais autant de leçons que tu veux, quand tu veux.',
                                  style: GoogleFonts.nunito(
                                      fontSize: 11,
                                      color: Colors.white70)),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(99)),
                                child: Text('Passer Premium →',
                                    style: GoogleFonts.nunito(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: C.accent)),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        _acquiseItem(
                            'Pluriels en -eux', '0 faute depuis 14 jours'),
                        _acquiseItem('Majuscules', '0 faute depuis 21 jours'),
                        _acquiseItem(
                            'Accord sujet-verbe', '0 faute depuis 9 jours'),
                      ],
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _tabBtn(String label, int index) {
    final active = _tab == index;
    return GestureDetector(
      onTap: () => setState(() => _tab = index),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? C.accent : Colors.white,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: active ? C.accent : C.border),
        ),
        child: Text(label,
            style: GoogleFonts.nunito(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: active ? Colors.white : C.muted)),
      ),
    );
  }

  Widget _lessonItem(BuildContext context, String ico, String title,
      String sub, Color color, String badge, double progress) {
    return GestureDetector(
      onTap: _leconDuJour == null
          ? null
          : () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      LessonDetailScreen(lecon: _leconDuJour!),
                ),
              ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: C.dark.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                      child: Text(ico,
                          style: TextStyle(
                              fontSize: 14,
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
        boxShadow: [
          BoxShadow(
              color: C.dark.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
                color: C.accentSoft,
                borderRadius: BorderRadius.circular(12)),
            child: Center(
                child: Text(ico,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: C.accent))),
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
                    style:
                        GoogleFonts.nunito(fontSize: 10, color: C.muted)),
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
        boxShadow: [
          BoxShadow(
              color: C.dark.withOpacity(0.04),
              blurRadius: 9,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                color: C.greenSoft,
                borderRadius: BorderRadius.circular(10)),
            child: const Center(
                child: Text('✅', style: TextStyle(fontSize: 16))),
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
                    style:
                        GoogleFonts.nunito(fontSize: 10, color: C.muted)),
              ],
            ),
          ),
          const Text('🏆', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}

// ─── DÉTAIL LEÇON ────────────────────────────────────────
class LessonDetailScreen extends StatelessWidget {
  final Lecon lecon;

  const LessonDetailScreen({super.key, required this.lecon});

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
                    style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: C.accent)),
              ),
              const SizedBox(height: 16),

              // Hero
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [C.accent, C.accent2]),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('✦ Leçon personnalisée',
                        style: GoogleFonts.nunito(
                            fontSize: 10,
                            color: Colors.white60,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1)),
                    const SizedBox(height: 6),
                    Text('${lecon.emoji} ${lecon.titre}',
                        style: GoogleFonts.syne(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white)),
                    const SizedBox(height: 4),
                    Text(lecon.resume,
                        style: GoogleFonts.nunito(
                            fontSize: 12, color: Colors.white70)),
                    const SizedBox(height: 4),
                    Text('⏱ ${lecon.duree}',
                        style: GoogleFonts.nunito(
                            fontSize: 11, color: Colors.white54)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Règles générées par Gemini
              ...lecon.regles.map((regle) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: SCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('📌 ${regle.titre}',
                              style: GoogleFonts.syne(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: C.dark)),
                          const SizedBox(height: 8),
                          Text(regle.explication,
                              style: GoogleFonts.nunito(
                                  fontSize: 13,
                                  color: C.text,
                                  height: 1.6)),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: C.accentSoft,
                              borderRadius: BorderRadius.circular(9),
                              border: Border.all(
                                  color: C.accent.withOpacity(0.2)),
                            ),
                            child: Row(
                              children: [
                                Text('💡 ',
                                    style:
                                        const TextStyle(fontSize: 14)),
                                Expanded(
                                  child: Text(regle.exemple,
                                      style: GoogleFonts.nunito(
                                          fontSize: 12,
                                          color: C.accent,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),

              // Conseil final
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: C.greenSoft,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: C.green.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Text('💪 ', style: TextStyle(fontSize: 20)),
                    Expanded(
                      child: Text(lecon.conseil,
                          style: GoogleFonts.nunito(
                              fontSize: 13,
                              color: C.green,
                              fontWeight: FontWeight.w600,
                              height: 1.4)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: C.accent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: Text('Leçon terminée ✓ — +15 pts 🎉',
                      style: GoogleFonts.nunito(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}