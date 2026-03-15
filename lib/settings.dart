import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool correction = true;
  bool suggestions = true;
  bool memoire = true;
  bool rapport = true;
  bool streak = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header profil
              Container(
                padding: const EdgeInsets.all(18),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [C.accentSoft, Colors.white]),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 54, height: 54,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [C.accent, C.accent2]),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(child: Text('😊', style: TextStyle(fontSize: 26))),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Alex', style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w800, color: C.dark)),
                        Text('Objectif : Partout · 3×/sem',
                            style: GoogleFonts.nunito(fontSize: 12, color: C.muted)),
                      ],
                    ),
                  ],
                ),
              ),

              // Premium banner
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [C.accent, C.accent2]),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('⭐ Passer à Premium',
                                style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white)),
                            Text('4,99€/mois · Leçons illimitées',
                                style: GoogleFonts.nunito(fontSize: 12, color: Colors.white70)),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _section('CLAVIER', [
                      _toggle('⌨️', 'Correcteur', 'Souligne les fautes pendant la frappe',
                          correction, (v) => setState(() => correction = v)),
                      _toggle('💡', 'Reformulation', 'Reformule tes phrases avec l\'IA',
                          suggestions, (v) => setState(() => suggestions = v)),
                      _navButton('📱', 'Clavier Scrivia', 'Voir mon clavier'),
                    ]),
                    _section('APPRENTISSAGE', [
                      _nav('🎯', 'Mon objectif', 'Partout'),
                      _nav('⏱️', 'Fréquence', '3× / sem · 15 min'),
                      _toggle('🧠', 'Mémorisation espacée', 'Révision intelligente',
                          memoire, (v) => setState(() => memoire = v)),
                    ]),
                    _section('NOTIFICATIONS', [
                      _toggle('📅', 'Rapport hebdomadaire', 'Chaque lundi matin',
                          rapport, (v) => setState(() => rapport = v)),
                      _toggle('🔥', 'Rappel de streak', 'Si pas d\'activité',
                          streak, (v) => setState(() => streak = v)),
                    ]),
                    _section('COMPTE', [
                      _nav('🔒', 'Confidentialité', 'Voir nos engagements'),
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(13),
                          boxShadow: [BoxShadow(color: C.dark.withOpacity(0.04), blurRadius: 7, offset: const Offset(0, 2))],
                        ),
                        child: Row(
                          children: [
                            const Text('🚪', style: TextStyle(fontSize: 18)),
                            const SizedBox(width: 12),
                            Text('Se déconnecter',
                                style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700, color: C.red)),
                          ],
                        ),
                      ),
                    ]),
                    Center(
                      child: Text('Scrivia v1.0.0 · iOS & Android',
                          style: GoogleFonts.nunito(fontSize: 11, color: C.muted)),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 3, top: 4),
          child: Text(title,
              style: GoogleFonts.nunito(fontSize: 10, fontWeight: FontWeight.w800, color: C.muted, letterSpacing: 1)),
        ),
        ...items,
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _toggle(String ico, String name, String sub, bool val, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [BoxShadow(color: C.dark.withOpacity(0.04), blurRadius: 7, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Text(ico, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700, color: C.dark)),
                Text(sub, style: GoogleFonts.nunito(fontSize: 11, color: C.muted)),
              ],
            ),
          ),
          Switch(
            value: val,
            onChanged: onChanged,
            activeColor: C.accent,
          ),
        ],
      ),
    );
  }

  Widget _nav(String ico, String name, String val) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [BoxShadow(color: C.dark.withOpacity(0.04), blurRadius: 7, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Text(ico, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700, color: C.dark)),
                Text(val, style: GoogleFonts.nunito(fontSize: 11, color: C.muted)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 15, color: C.muted),
        ],
      ),
    );
  }

  Widget _navButton(String ico, String name, String sub) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: C.accentSoft,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: C.accent.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Text(ico, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700, color: C.accent)),
                Text(sub, style: GoogleFonts.nunito(fontSize: 11, color: C.muted)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 15, color: C.accent),
        ],
      ),
    );
  }
}