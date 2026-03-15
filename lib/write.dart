import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme.dart';

class WriteScreen extends StatefulWidget {
  const WriteScreen({super.key});

  @override
  State<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  int _tab = 0;
  final _controller = TextEditingController();
  bool _showResult = false;

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
                  Text('✍️ Écrire', style: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.w800, color: C.dark)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(color: C.orangeSoft, borderRadius: BorderRadius.circular(99),
                        border: Border.all(color: C.orange.withOpacity(0.3))),
                    child: Text('🔥 7j', style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w700, color: C.orange)),
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
                  _tabBtn('🔍 Corriger', 2),
                ],
              ),
            ),

            // Contenu
            Expanded(
              child: _tab == 0 ? _libreMode() :
                     _tab == 1 ? _dicteeMode() :
                     _corrigerMode(),
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
            border: Border(bottom: BorderSide(
              color: active ? C.accent : Colors.transparent,
              width: 2,
            )),
          ),
          child: Text(label, textAlign: TextAlign.center,
              style: GoogleFonts.nunito(fontSize: 10, fontWeight: FontWeight.w700,
                  color: active ? C.accent : C.muted)),
        ),
      ),
    );
  }

  // ─── MODE ESPACE LIBRE ───────────────────────────────────
  Widget _libreMode() {
    return Stack(
      children: [
        Column(
          children: [
            // Zone texte
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
                          style: GoogleFonts.nunito(fontSize: 15, color: C.dark, height: 2.0),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(16),
                            border: InputBorder.none,
                            hintText: 'Écris librement ici...\nTes fautes seront soulignées 🔴',
                            hintStyle: GoogleFonts.nunito(color: C.muted, fontStyle: FontStyle.italic, height: 2.0),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: const BoxDecoration(
                            border: Border(top: BorderSide(color: C.border))),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: C.redSoft, borderRadius: BorderRadius.circular(99)),
                              child: Text('● 2 fautes', style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w700, color: C.red)),
                            ),
                            const SizedBox(width: 10),
                            Row(
                              children: [
                                Container(width: 6, height: 6,
                                    decoration: const BoxDecoration(shape: BoxShape.circle, color: C.green)),
                                const SizedBox(width: 4),
                                Text('Live', style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w700, color: C.green)),
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

            // Suggestions
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

            // Bouton bilan
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => setState(() => _showResult = true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: C.accent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: Text('✨ Voir le bilan complet',
                      style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(height: 14),
          ],
        ),

        // Popup résultat
        if (_showResult)
          GestureDetector(
            onTap: () => setState(() => _showResult = false),
            child: Container(
              color: Colors.black54,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🟠', style: TextStyle(fontSize: 50)),
                      const SizedBox(height: 10),
                      Text('2 fautes !', style: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.w800, color: C.orange)),
                      const SizedBox(height: 6),
                      Text('Tu progresses — continue !',
                          style: GoogleFonts.nunito(fontSize: 12, color: C.muted)),
                      const SizedBox(height: 14),
                      _resultItem('"apartir" → à partir'),
                      _resultItem('"vacance" → vacances'),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => setState(() => _showResult = false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: C.accent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: Text('Voir la leçon 📖',
                              style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
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
      child: Text(text, style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700, color: C.accent)),
    );
  }

  Widget _resultItem(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: C.redSoft, borderRadius: BorderRadius.circular(9)),
      child: Row(
        children: [
          Container(width: 5, height: 5, decoration: const BoxDecoration(shape: BoxShape.circle, color: C.red)),
          const SizedBox(width: 8),
          Text(text, style: GoogleFonts.nunito(fontSize: 11, color: C.text)),
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
          // Hero dictée
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [C.accent, C.accent2]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text('🎧 Dictée personnalisée',
                    style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
                const SizedBox(height: 4),
                Text('Basée sur tes fautes récentes.',
                    style: GoogleFonts.nunito(fontSize: 11, color: Colors.white70)),
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

          // Input
          SCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Phrase 2 / 5', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700, color: C.accent)),
                const SizedBox(height: 6),
                Text('"— — — — — — —"', style: GoogleFonts.nunito(fontSize: 13, color: C.muted, fontStyle: FontStyle.italic)),
                const SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Écris ce que tu as entendu...',
                    hintStyle: GoogleFonts.nunito(color: C.muted),
                    filled: true,
                    fillColor: C.bg,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(11), borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(11), borderSide: const BorderSide(color: C.accent)),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: C.accent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                      elevation: 0,
                    ),
                    child: Text('Valider ✓', style: GoogleFonts.nunito(fontWeight: FontWeight.w700, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Limite gratuite
          SCard(
            color: C.bg,
            child: Column(
              children: [
                const Text('🎧', style: TextStyle(fontSize: 28)),
                const SizedBox(height: 6),
                Text('1 dictée / jour — limite atteinte',
                    style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w800, color: C.dark)),
                const SizedBox(height: 4),
                Text('Reviens demain ou passe à Premium.',
                    style: GoogleFonts.nunito(fontSize: 11, color: C.muted), textAlign: TextAlign.center),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [C.accent, C.accent2]),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text('⭐ Dictées illimitées',
                      style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white)),
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
      child: Text(label, style: GoogleFonts.nunito(
          fontSize: 12, fontWeight: FontWeight.w700,
          color: primary ? C.accent : Colors.white)),
    );
  }

  // ─── MODE CORRIGER ───────────────────────────────────────
  Widget _corrigerMode() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          // Info
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: C.accentSoft,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: C.accent.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('💡 Comment ça marche',
                    style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w700, color: C.accent, letterSpacing: 0.8)),
                const SizedBox(height: 6),
                Text('Colle un texte ci-dessous et clique sur Corriger pour voir toutes les fautes.',
                    style: GoogleFonts.nunito(fontSize: 12, color: C.text)),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Zone texte
          SCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: C.border))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Ton texte', style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w700, color: C.muted)),
                      Text('Effacer ✕', style: GoogleFonts.nunito(fontSize: 10, color: C.accent)),
                    ],
                  ),
                ),
                TextField(
                  maxLines: 6,
                  style: GoogleFonts.nunito(fontSize: 13, color: C.dark, height: 1.8),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(14),
                    border: InputBorder.none,
                    hintText: 'Colle ou tape ton texte ici...',
                    hintStyle: GoogleFonts.nunito(color: C.muted),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Score
          Row(
            children: [
              _scoreBox('2', 'Fautes', C.red),
              const SizedBox(width: 8),
              _scoreBox('1', 'Attention', C.orange),
              const SizedBox(width: 8),
              _scoreBox('62%', 'Score', C.green),
            ],
          ),
          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: C.accent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: Text('✨ Corriger ce texte',
                  style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _scoreBox(String val, String label, Color color) {
    return Expanded(
      child: SCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(val, style: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
            Text(label, style: GoogleFonts.nunito(fontSize: 9, color: C.muted)),
          ],
        ),
      ),
    );
  }
}