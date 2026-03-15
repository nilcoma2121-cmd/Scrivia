import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

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
                  Text('📊 Mes statistiques', style: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.w800, color: C.dark)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(color: C.orangeSoft, borderRadius: BorderRadius.circular(99),
                        border: Border.all(color: C.orange.withOpacity(0.3))),
                    child: Text('🔥 7j', style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w700, color: C.orange)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Score banner
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [C.accent, C.accent2]),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('78', style: GoogleFonts.syne(fontSize: 52, fontWeight: FontWeight.w800, color: Colors.white, height: 1)),
                        Text('%', style: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white54)),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Score de maîtrise', style: GoogleFonts.nunito(fontSize: 13, color: Colors.white70)),
                          Text('↑ +5% vs semaine dernière 🎉', style: GoogleFonts.nunito(fontSize: 11, color: Colors.white54)),
                          const SizedBox(height: 8),
                          Text('Top 30% des utilisateurs !', style: GoogleFonts.nunito(fontSize: 11, color: Colors.white70)),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(99),
                            child: LinearProgressIndicator(
                              value: 0.78,
                              backgroundColor: Colors.white24,
                              valueColor: const AlwaysStoppedAnimation(Colors.white),
                              minHeight: 5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Tabs semaine / mois / historique
              Row(
                children: [
                  _tab('Cette semaine', true),
                  const SizedBox(width: 6),
                  _tab('Ce mois ⭐', false),
                  const SizedBox(width: 6),
                  _tab('Historique ⭐', false),
                ],
              ),
              const SizedBox(height: 16),

              // 3 stats
              Row(
                children: [
                  _s3('2.4', 'Fautes/texte', C.red),
                  const SizedBox(width: 8),
                  _s3('47', 'Textes', C.accent),
                  const SizedBox(width: 8),
                  _s3('8', 'Leçons', C.green),
                ],
              ),
              const SizedBox(height: 16),

              // Barres semaine
              SCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('📅 Fautes par jour', style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700, color: C.dark)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _bar('L', 52, C.red, '9'),
                        _bar('M', 40, C.orange, '7'),
                        _bar('M', 46, C.orange, '8'),
                        _bar('J', 28, C.accent, '5'),
                        _bar('V', 18, C.green, '3'),
                        _bar('S', 12, C.green, '2'),
                        _bar('D', 6, C.green, '1'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text('📈 Tendance à la baisse — continue !',
                          style: GoogleFonts.nunito(fontSize: 10, color: C.muted)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Top fautes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('🔁 Fautes les plus fréquentes', style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w800, color: C.dark)),
                  Text('Tout voir ⭐', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700, color: C.accent)),
                ],
              ),
              const SizedBox(height: 10),
              _fauteRow('é', '"allé" → écrit "alle"', 0.85, '12×', C.red),
              _fauteRow('à', '"à" → écrit "a"', 0.65, '9×', C.orange),
              _fauteRow('ce', '"ce" → écrit "se"', 0.50, '7×', C.orange),
              _fauteRow('é', '"été" → écrit "ete"', 0.43, '6×', C.accent),
              _fauteRow('où', '"où" → écrit "ou"', 0.28, '4×', C.accent),

              // Lock premium
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: C.accentSoft,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: C.accent.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Text('🔒', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('+7 fautes cachées', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700, color: C.accent)),
                          Text('Passe à Premium pour tout voir', style: GoogleFonts.nunito(fontSize: 10, color: C.muted)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: C.accent, borderRadius: BorderRadius.circular(99)),
                      child: Text('⭐ PRO', style: GoogleFonts.nunito(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tab(String label, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: active ? C.accent : Colors.white,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: active ? C.accent : C.border),
      ),
      child: Text(label, style: GoogleFonts.nunito(
          fontSize: 11, fontWeight: FontWeight.w700,
          color: active ? Colors.white : C.muted)),
    );
  }

  Widget _s3(String val, String label, Color color) {
    return Expanded(
      child: SCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(val, style: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
            const SizedBox(height: 2),
            Text(label, style: GoogleFonts.nunito(fontSize: 9, fontWeight: FontWeight.w600, color: C.muted), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _bar(String label, double height, Color color, String count) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(count, style: GoogleFonts.nunito(fontSize: 8, fontWeight: FontWeight.w700, color: color)),
        const SizedBox(height: 2),
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

  Widget _fauteRow(String ico, String title, double pct, String count, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [BoxShadow(color: C.dark.withOpacity(0.04), blurRadius: 9, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(ico, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w800, color: C.dark))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(99)),
                child: Text(count, style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
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