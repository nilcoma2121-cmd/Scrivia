import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme.dart';
import 'services/firebase_service.dart';
import 'services/gemini_service.dart';

// ─── CATALOGUE STATIQUE ───────────────────────────────────
const _catalogue = [
  // ── HOMOPHONES ─────────────────────────────────────────
  {
    'titre': 'Les homophones et/est',
    'emoji': '🔤',
    'categorie': 'Homophones',
    'duree': '5 min',
    'resume': 'Maîtriser et (conjonction) vs est (verbe être).'
  },
  {
    'titre': 'Les homophones a/à',
    'emoji': '🔤',
    'categorie': 'Homophones',
    'duree': '5 min',
    'resume': 'Distinguer a (avoir) de à (préposition).'
  },
  {
    'titre': 'Les homophones son/sont',
    'emoji': '🔤',
    'categorie': 'Homophones',
    'duree': '5 min',
    'resume': 'Distinguer son (adjectif possessif) de sont (verbe être).'
  },
  {
    'titre': 'Les homophones on/ont',
    'emoji': '🔤',
    'categorie': 'Homophones',
    'duree': '5 min',
    'resume': 'Distinguer on (pronom indéfini) de ont (verbe avoir).'
  },
  {
    'titre': 'Les homophones ces/ses',
    'emoji': '🔤',
    'categorie': 'Homophones',
    'duree': '5 min',
    'resume': 'Distinguer ces (démonstratif pluriel) de ses (possessif pluriel).'
  },
  {
    'titre': 'Les homophones ou/où',
    'emoji': '🔤',
    'categorie': 'Homophones',
    'duree': '5 min',
    'resume': 'Distinguer ou (choix entre deux choses) de où (lieu ou temps).'
  },
  {
    'titre': 'Les homophones se/ce',
    'emoji': '🔤',
    'categorie': 'Homophones',
    'duree': '5 min',
    'resume': 'Distinguer se (pronom réfléchi) de ce (déterminant ou pronom démonstratif).'
  },
  {
    'titre': 'Les homophones leur/leurs',
    'emoji': '🔤',
    'categorie': 'Homophones',
    'duree': '5 min',
    'resume': 'Savoir quand écrire leur sans s et leurs avec s.'
  },
  {
    'titre': 'Les homophones peu/peut/peux',
    'emoji': '🔤',
    'categorie': 'Homophones',
    'duree': '6 min',
    'resume': 'Distinguer peu (quantité), peut et peux (verbe pouvoir).'
  },
  {
    'titre': 'Les homophones mais/mes/mets',
    'emoji': '🔤',
    'categorie': 'Homophones',
    'duree': '5 min',
    'resume': 'Distinguer mais (conjonction), mes (possessif) et mets (verbe mettre).'
  },
  {
    'titre': "Les homophones sans/s'en/sens",
    'emoji': '🔤',
    'categorie': 'Homophones',
    'duree': '6 min',
    'resume': "Savoir choisir entre sans (préposition), s'en (pronom) et sens (verbe/nom)."
  },
  {
    'titre': 'Les homophones ni/n\'y',
    'emoji': '🔤',
    'categorie': 'Homophones',
    'duree': '5 min',
    'resume': "Distinguer ni (conjonction de négation) de n'y (pronom négatif)."
  },
  // ── CONJUGAISON ────────────────────────────────────────
  {
    'titre': "L'accord du participe passé",
    'emoji': '✏️',
    'categorie': 'Conjugaison',
    'duree': '10 min',
    'resume': "Règles d'accord avec les auxiliaires avoir et être."
  },
  {
    'titre': 'Les terminaisons -er / -é / -ez',
    'emoji': '⚡',
    'categorie': 'Conjugaison',
    'duree': '8 min',
    'resume': 'Ne plus confondre infinitif, participe passé et 2e personne du pluriel.'
  },
  {
    'titre': "Le présent de l'indicatif",
    'emoji': '🔄',
    'categorie': 'Conjugaison',
    'duree': '8 min',
    'resume': 'Conjuguer les verbes des trois groupes au présent de l\'indicatif.'
  },
  {
    'titre': "L'imparfait de l'indicatif",
    'emoji': '⏮️',
    'categorie': 'Conjugaison',
    'duree': '8 min',
    'resume': 'Former et utiliser l\'imparfait pour les actions passées durables.'
  },
  {
    'titre': 'Le futur simple',
    'emoji': '⏭️',
    'categorie': 'Conjugaison',
    'duree': '8 min',
    'resume': 'Conjuguer au futur simple et mémoriser les futurs irréguliers.'
  },
  {
    'titre': 'Le conditionnel présent',
    'emoji': '🤔',
    'categorie': 'Conjugaison',
    'duree': '8 min',
    'resume': 'Utiliser le conditionnel pour la politesse, l\'hypothèse et le rêve.'
  },
  {
    'titre': 'Le subjonctif présent',
    'emoji': '💭',
    'categorie': 'Conjugaison',
    'duree': '10 min',
    'resume': 'Former le subjonctif et savoir quand l\'employer après certains verbes.'
  },
  {
    'titre': "L'impératif présent",
    'emoji': '❗',
    'categorie': 'Conjugaison',
    'duree': '7 min',
    'resume': 'Donner des ordres et des conseils avec les trois personnes de l\'impératif.'
  },
  {
    'titre': 'Le passé composé',
    'emoji': '📅',
    'categorie': 'Conjugaison',
    'duree': '10 min',
    'resume': 'Former le passé composé avec avoir ou être et accorder le participe.'
  },
  {
    'titre': 'Le plus-que-parfait',
    'emoji': '⏪',
    'categorie': 'Conjugaison',
    'duree': '8 min',
    'resume': 'Exprimer une action antérieure à une autre action passée.'
  },
  {
    'titre': 'Les terminaisons -ais / -ait / -aient',
    'emoji': '🔍',
    'categorie': 'Conjugaison',
    'duree': '6 min',
    'resume': 'Ne plus confondre les terminaisons de l\'imparfait et du conditionnel.'
  },
  // ── ORTHOGRAPHE ────────────────────────────────────────
  {
    'titre': 'Les accents é, è, ê',
    'emoji': '🌟',
    'categorie': 'Orthographe',
    'duree': '7 min',
    'resume': 'Bien placer les accents aigus, graves et circonflexes sur le e.'
  },
  {
    'titre': 'Les pluriels en -eux',
    'emoji': '📝',
    'categorie': 'Orthographe',
    'duree': '5 min',
    'resume': 'Les mots terminés en -eu, -eau, -au prennent -x au pluriel.'
  },
  {
    'titre': 'Les doubles consonnes',
    'emoji': '🔍',
    'categorie': 'Orthographe',
    'duree': '6 min',
    'resume': 'Savoir quand doubler une consonne : ll, mm, nn, pp, rr, ss, tt...'
  },
  {
    'titre': 'Les mots invariables',
    'emoji': '🔒',
    'categorie': 'Orthographe',
    'duree': '6 min',
    'resume': 'Mémoriser beaucoup, très, jamais, toujours, maintenant...'
  },
  {
    'titre': 'Les noms en -tion et -sion',
    'emoji': '📖',
    'categorie': 'Orthographe',
    'duree': '5 min',
    'resume': 'Choisir entre -tion, -sion et -ssion selon la prononciation.'
  },
  {
    'titre': 'Les adverbes en -ment',
    'emoji': '💬',
    'categorie': 'Orthographe',
    'duree': '6 min',
    'resume': 'Former correctement les adverbes de manière à partir des adjectifs.'
  },
  {
    'titre': 'Le féminin des noms et adjectifs',
    'emoji': '🔡',
    'categorie': 'Orthographe',
    'duree': '7 min',
    'resume': 'Former le féminin en ajoutant -e ou en changeant la terminaison.'
  },
  {
    'titre': 'Les pluriels des noms en -al et -au',
    'emoji': '📝',
    'categorie': 'Orthographe',
    'duree': '6 min',
    'resume': 'Cheval → chevaux, bateau → bateaux : règles et exceptions.'
  },
  {
    'titre': 'Les mots avec c et ç',
    'emoji': '🔡',
    'categorie': 'Orthographe',
    'duree': '5 min',
    'resume': 'Quand écrire c et quand mettre la cédille devant a, o, u.'
  },
  {
    'titre': "L'accent circonflexe",
    'emoji': '🌟',
    'categorie': 'Orthographe',
    'duree': '6 min',
    'resume': 'Employer â, ê, î, ô, û correctement et distinguer forêt/forêts.'
  },
  // ── GRAMMAIRE ──────────────────────────────────────────
  {
    'titre': "L'accord sujet-verbe",
    'emoji': '📐',
    'categorie': 'Grammaire',
    'duree': '8 min',
    'resume': 'Accorder le verbe avec son sujet en personne et en nombre.'
  },
  {
    'titre': "L'accord de l'adjectif qualificatif",
    'emoji': '📐',
    'categorie': 'Grammaire',
    'duree': '8 min',
    'resume': "Accorder l'adjectif en genre et en nombre avec le nom qu'il qualifie."
  },
  {
    'titre': 'Les pronoms personnels',
    'emoji': '👤',
    'categorie': 'Grammaire',
    'duree': '7 min',
    'resume': 'Maîtriser les pronoms sujets, COD et COI pour éviter les répétitions.'
  },
  {
    'titre': 'Les pronoms relatifs (qui, que, dont, où)',
    'emoji': '🔗',
    'categorie': 'Grammaire',
    'duree': '8 min',
    'resume': 'Relier des propositions en choisissant le bon pronom relatif.'
  },
  {
    'titre': 'La négation : ne...pas et autres formes',
    'emoji': '🚫',
    'categorie': 'Grammaire',
    'duree': '6 min',
    'resume': 'Construire les négations : ne...pas, ne...jamais, ne...plus, ne...rien.'
  },
  {
    'titre': 'Les déterminants (articles et possessifs)',
    'emoji': '🔑',
    'categorie': 'Grammaire',
    'duree': '6 min',
    'resume': 'Choisir le bon déterminant défini, indéfini ou possessif devant un nom.'
  },
  {
    'titre': 'Le pluriel des noms composés',
    'emoji': '🧩',
    'categorie': 'Grammaire',
    'duree': '7 min',
    'resume': 'Arc-en-ciel, porte-manteau, compte-rendu : règles d\'accord.'
  },
  {
    'titre': "Les compléments d'objet (COD et COI)",
    'emoji': '➡️',
    'categorie': 'Grammaire',
    'duree': '9 min',
    'resume': 'Identifier et distinguer le COD et le COI dans la phrase.'
  },
  // ── TYPOGRAPHIE ────────────────────────────────────────
  {
    'titre': "L'apostrophe",
    'emoji': '✒️',
    'categorie': 'Typographie',
    'duree': '5 min',
    'resume': "Quand et comment utiliser l'apostrophe pour l'élision."
  },
  {
    'titre': "Le trait d'union",
    'emoji': '➖',
    'categorie': 'Typographie',
    'duree': '5 min',
    'resume': "Quand utiliser le trait d'union dans les mots composés et à l'impératif."
  },
  {
    'titre': 'Les majuscules',
    'emoji': '🔠',
    'categorie': 'Typographie',
    'duree': '4 min',
    'resume': "Règles d'utilisation des majuscules : noms propres, débuts de phrase..."
  },
  // ── PONCTUATION ────────────────────────────────────────
  {
    'titre': 'La virgule',
    'emoji': '✍️',
    'categorie': 'Ponctuation',
    'duree': '5 min',
    'resume': 'Savoir placer la virgule dans les listes et les propositions subordonnées.'
  },
  {
    'titre': 'Les deux-points et le point-virgule',
    'emoji': '📜',
    'categorie': 'Ponctuation',
    'duree': '6 min',
    'resume': 'Utiliser : et ; pour annoncer une explication ou lier des propositions.'
  },
  {
    'titre': 'Les guillemets et le discours direct',
    'emoji': '🗨️',
    'categorie': 'Ponctuation',
    'duree': '7 min',
    'resume': "Citer les paroles de quelqu'un avec les guillemets français « »."
  },
  {
    'titre': "Le point d'interrogation et d'exclamation",
    'emoji': '❓',
    'categorie': 'Ponctuation',
    'duree': '5 min',
    'resume': 'Ponctuer correctement les questions et les exclamations.'
  },
  // ── SYNTAXE ────────────────────────────────────────────
  {
    'titre': 'La phrase simple et la phrase complexe',
    'emoji': '🗂️',
    'categorie': 'Syntaxe',
    'duree': '8 min',
    'resume': 'Reconnaître et construire des phrases simples et complexes bien formées.'
  },
  {
    'titre': 'Les subordonnées temporelles',
    'emoji': '⏰',
    'categorie': 'Syntaxe',
    'duree': '8 min',
    'resume': 'Exprimer le temps avec quand, lorsque, dès que, avant que...'
  },
  {
    'titre': 'Les subordonnées causales',
    'emoji': '🔗',
    'categorie': 'Syntaxe',
    'duree': '7 min',
    'resume': 'Exprimer la cause avec parce que, car, puisque, comme...'
  },
  {
    'titre': 'Le discours indirect',
    'emoji': '🗣️',
    'categorie': 'Syntaxe',
    'duree': '9 min',
    'resume': 'Transformer le discours direct en discours indirect avec les bons temps.'
  },
];

// ─── ÉCRAN PRINCIPAL LEÇONS ───────────────────────────────
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
  List<Map<String, dynamic>> _acquisLecons = [];
  int _streak = 0;
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';
  bool _searchFocused = false;

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchCtrl.addListener(() {
      setState(() => _searchQuery = _searchCtrl.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final results = await Future.wait([
      FirebaseService.getFautes(limit: 15),
      FirebaseService.getStats(),
      FirebaseService.getAcquisLecons(),
    ]);
    final fautes = results[0] as List<Map<String, dynamic>>;
    final stats = results[1] as Map<String, dynamic>;
    final acquis = results[2] as List<Map<String, dynamic>>;
    final mots = fautes
        .map((f) => f['mot']?.toString() ?? '')
        .where((m) => m.isNotEmpty)
        .toList();

    final lecon = await GeminiService().generateLecon(mots);

    if (!mounted) return;
    setState(() {
      _fautes = fautes;
      _streak = stats['streak'] ?? 0;
      _leconDuJour = lecon;
      _acquisLecons = acquis;
      _loading = false;
    });
  }

  // Retrouve la catégorie d'un titre dans le catalogue statique.
  // Retourne 'Personnalisée' si le titre n'y figure pas.
  String _getCategorieForTitre(String titre) {
    for (final entry in _catalogue) {
      if (entry['titre'] == titre) return entry['categorie'] as String;
    }
    return 'Personnalisée';
  }

  void _showSavedLecons() {
    final pageContext = context;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: C.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.92,
        minChildSize: 0.35,
        expand: false,
        builder: (_, scrollCtrl) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poignée
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: C.border,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            // Titre du sheet
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('🔖 Leçons sauvegardées',
                      style: GoogleFonts.syne(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: C.dark)),
                  GestureDetector(
                    onTap: () => Navigator.pop(sheetCtx),
                    child:
                        const Icon(Icons.close, color: C.muted, size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Contenu
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: FirebaseService.getSavedLecons(),
                builder: (_, snap) {
                  if (snap.connectionState != ConnectionState.done) {
                    return const Center(
                        child: CircularProgressIndicator(color: C.accent));
                  }
                  final lecons = snap.data ?? [];
                  if (lecons.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🔖',
                                style: TextStyle(fontSize: 40)),
                            const SizedBox(height: 12),
                            Text('Aucune leçon sauvegardée',
                                style: GoogleFonts.syne(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: C.dark)),
                            const SizedBox(height: 4),
                            Text(
                                'Appuie sur "+ Sauvegarder" dans une leçon.',
                                style: GoogleFonts.nunito(
                                    fontSize: 12, color: C.muted),
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    controller: scrollCtrl,
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
                    itemCount: lecons.length,
                    itemBuilder: (_, i) {
                      final l = lecons[i];
                      final titre = l['titre']?.toString() ?? '';
                      final emoji = l['emoji']?.toString() ?? '📝';
                      final categorie = _getCategorieForTitre(titre);
                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(sheetCtx);
                          Navigator.push(
                            pageContext,
                            MaterialPageRoute(
                              builder: (_) =>
                                  LessonDetailScreen(topic: titre),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: const Border(
                                left: BorderSide(
                                    color: C.accent, width: 3)),
                            boxShadow: [
                              BoxShadow(
                                  color:
                                      C.dark.withValues(alpha: 0.04),
                                  blurRadius: 8,
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
                                    borderRadius:
                                        BorderRadius.circular(12)),
                                child: Center(
                                    child: Text(emoji,
                                        style: const TextStyle(
                                            fontSize: 18))),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(titre,
                                        style: GoogleFonts.nunito(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: C.dark)),
                                    const SizedBox(height: 4),
                                    SBadge(
                                        text: categorie,
                                        color: C.accent),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right,
                                  color: C.muted, size: 18),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> get _catalogueFiltre {
    if (_searchQuery.isEmpty) return _catalogue;
    return _catalogue
        .where((l) =>
            l['titre']!.toLowerCase().contains(_searchQuery) ||
            l['categorie']!.toLowerCase().contains(_searchQuery))
        .toList();
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

                      // Header
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
                                    color: C.orange.withValues(alpha: 0.3))),
                            child: Text('🔥 ${_streak}j',
                                style: GoogleFonts.nunito(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: C.orange)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Barre de recherche + bouton sauvegardées
                      Row(
                        children: [
                          Expanded(
                            child: Focus(
                              onFocusChange: (v) =>
                                  setState(() => _searchFocused = v),
                              child: TextField(
                                controller: _searchCtrl,
                                style: GoogleFonts.nunito(
                                    fontSize: 13, color: C.dark),
                                decoration: InputDecoration(
                                  hintText: 'Rechercher une leçon...',
                                  hintStyle: GoogleFonts.nunito(
                                      fontSize: 13, color: C.muted),
                                  prefixIcon: const Icon(Icons.search,
                                      color: C.muted, size: 18),
                                  suffixIcon: _searchQuery.isNotEmpty
                                      ? GestureDetector(
                                          onTap: () => _searchCtrl.clear(),
                                          child: const Icon(Icons.close,
                                              color: C.muted, size: 16),
                                        )
                                      : null,
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide:
                                        BorderSide(color: C.border),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide:
                                        BorderSide(color: C.border),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                        color: C.accent, width: 1.5),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: _showSavedLecons,
                            child: Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: C.border),
                              ),
                              child: const Center(
                                child: Text('🔖',
                                    style: TextStyle(fontSize: 20)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Résultats de recherche (catalogue)
                      if (_searchFocused || _searchQuery.isNotEmpty) ...[
                        if (_searchQuery.isNotEmpty) ...[
                          Text(
                              '${_catalogueFiltre.length} leçon${_catalogueFiltre.length > 1 ? 's' : ''} trouvée${_catalogueFiltre.length > 1 ? 's' : ''}',
                              style: GoogleFonts.nunito(
                                  fontSize: 11, color: C.muted)),
                          const SizedBox(height: 8),
                          ..._catalogueFiltre
                              .map((l) => _catalogueItem(l)),
                        ] else ...[
                          Text('Toutes les leçons disponibles',
                              style: GoogleFonts.syne(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: C.dark)),
                          const SizedBox(height: 8),
                          ..._catalogue.map((l) => _catalogueItem(l)),
                        ],
                        const SizedBox(height: 20),
                      ] else ...[
                        // ─── MODE NORMAL (pas de recherche) ────────────

                        // Leçon du jour
                        if (_leconDuJour != null)
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LessonDetailScreen(
                                    lecon: _leconDuJour!),
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [
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
                                  Row(
                                    children: [
                                      Text('⏱ ${_leconDuJour!.duree}',
                                          style: GoogleFonts.nunito(
                                              fontSize: 11,
                                              color: Colors.white54)),
                                      const SizedBox(width: 12),
                                      Text(
                                          '📝 ${_leconDuJour!.exercices.length} exercices',
                                          style: GoogleFonts.nunito(
                                              fontSize: 11,
                                              color: Colors.white54)),
                                    ],
                                  ),
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

                        // État vide
                        if (_leconDuJour == null && _fautes.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: C.accentSoft,
                              borderRadius: BorderRadius.circular(14),
                              border:
                                  Border.all(color: C.accent.withValues(alpha: 0.2)),
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
                            final color = pct > 0.7 ? C.red : C.accent;
                            return _lessonItem(
                              context,
                              mot.isNotEmpty ? mot[0].toUpperCase() : '?',
                              'Faute : "$mot"',
                              '$count× cette semaine',
                              color,
                              count > 5 ? 'Priorité 🔥' : '${(pct * 100).round()}%',
                              pct.clamp(0.05, 1.0),
                              _leconDuJour,
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
                          _premiumBanner(),
                        ] else ...[
                          if (_acquisLecons.isEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    const Text('🏆',
                                        style: TextStyle(fontSize: 36)),
                                    const SizedBox(height: 8),
                                    Text('Pas encore de leçons acquises',
                                        style: GoogleFonts.syne(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w800,
                                            color: C.dark)),
                                    const SizedBox(height: 4),
                                    Text(
                                        'Réussis une leçon 3 fois de suite pour l\'acquérir !',
                                        style: GoogleFonts.nunito(
                                            fontSize: 12, color: C.muted),
                                        textAlign: TextAlign.center),
                                  ],
                                ),
                              ),
                            ),
                          ..._acquisLecons.map((l) => _acquiseItem(
                                '${l['lessonEmoji'] ?? '📝'} ${l['lessonTitre'] ?? ''}',
                                '${l['consecutiveSuccesses'] ?? 3} réussites consécutives',
                              )),
                        ],
                        const SizedBox(height: 20),
                      ],
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _catalogueItem(Map<String, dynamic> l) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => LessonDetailScreen(topic: l['titre'] as String),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: C.border),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                  color: C.accentSoft,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                  child: Text(l['emoji'] as String,
                      style: const TextStyle(fontSize: 16))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l['titre'] as String,
                      style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: C.dark)),
                  Text(l['resume'] as String,
                      style:
                          GoogleFonts.nunito(fontSize: 10, color: C.muted),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SBadge(text: l['categorie'] as String, color: C.accent),
                const SizedBox(height: 2),
                Text(l['duree'] as String,
                    style: GoogleFonts.nunito(
                        fontSize: 9, color: C.muted)),
              ],
            ),
          ],
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
      String sub, Color color, String badge, double progress, Lecon? lecon) {
    return GestureDetector(
      onTap: lecon == null
          ? null
          : () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LessonDetailScreen(lecon: lecon),
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
                color: C.dark.withValues(alpha: 0.05),
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
                      color: color.withValues(alpha: 0.1),
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
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: C.dark.withValues(alpha: 0.03),
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
              color: C.dark.withValues(alpha: 0.04),
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
            child:
                const Center(child: Text('✅', style: TextStyle(fontSize: 16))),
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
                    style: GoogleFonts.nunito(fontSize: 10, color: C.muted)),
              ],
            ),
          ),
          const Text('🏆', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  Widget _premiumBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [C.accent, C.accent2]),
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
          Text('Fais autant de leçons que tu veux, quand tu veux.',
              style:
                  GoogleFonts.nunito(fontSize: 11, color: Colors.white70)),
          const SizedBox(height: 12),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(99)),
            child: Text('Passer Premium →',
                style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: C.accent)),
          ),
        ],
      ),
    );
  }
}

// ─── PRÉVISUALISATION / DÉTAIL LEÇON ─────────────────────
class LessonDetailScreen extends StatefulWidget {
  final Lecon? lecon; // leçon déjà générée
  final String? topic; // sujet du catalogue → généré à la volée

  const LessonDetailScreen({super.key, this.lecon, this.topic});

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  Lecon? _lecon;
  bool _loading = false;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    if (widget.lecon != null) {
      _lecon = widget.lecon;
      _checkSaved();
    } else if (widget.topic != null) {
      _generateFromTopic();
    }
  }

  Future<void> _generateFromTopic() async {
    setState(() => _loading = true);
    final lecon =
        await GeminiService().generateLecon([], topic: widget.topic);
    if (!mounted) return;
    setState(() {
      _lecon = lecon;
      _loading = false;
    });
    _checkSaved();
  }

  Future<void> _checkSaved() async {
    if (_lecon == null) return;
    final saved = await FirebaseService.isLeconSaved(_lecon!.id);
    if (!mounted) return;
    setState(() => _isSaved = saved);
  }

  Future<void> _toggleSave() async {
    if (_lecon == null) return;
    if (_isSaved) {
      await FirebaseService.unsaveLecon(_lecon!.id);
    } else {
      await FirebaseService.saveLecon(_lecon!.id, _lecon!.toMap());
    }
    setState(() => _isSaved = !_isSaved);
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
                    Text('Génération de la leçon...',
                        style:
                            GoogleFonts.nunito(fontSize: 13, color: C.muted)),
                  ],
                ),
              )
            : _lecon == null
                ? Center(
                    child: Text('Impossible de charger la leçon.',
                        style: GoogleFonts.nunito(color: C.muted)))
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Text('← Retour aux leçons',
                                  style: GoogleFonts.nunito(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: C.accent)),
                            ),
                            GestureDetector(
                              onTap: _toggleSave,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: _isSaved
                                      ? C.accentSoft
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(99),
                                  border: Border.all(
                                      color: _isSaved
                                          ? C.accent
                                          : C.border),
                                ),
                                child: Text(
                                    _isSaved
                                        ? '🔖 Sauvegardée'
                                        : '+ Sauvegarder',
                                    style: GoogleFonts.nunito(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: _isSaved
                                            ? C.accent
                                            : C.muted)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Hero card
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
                              Text(
                                  widget.topic != null
                                      ? '✦ Leçon du catalogue'
                                      : '✦ Leçon personnalisée',
                                  style: GoogleFonts.nunito(
                                      fontSize: 10,
                                      color: Colors.white60,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1)),
                              const SizedBox(height: 6),
                              Text('${_lecon!.emoji} ${_lecon!.titre}',
                                  style: GoogleFonts.syne(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white)),
                              const SizedBox(height: 4),
                              Text(_lecon!.resume,
                                  style: GoogleFonts.nunito(
                                      fontSize: 12,
                                      color: Colors.white70)),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text('⏱ ${_lecon!.duree}',
                                      style: GoogleFonts.nunito(
                                          fontSize: 11,
                                          color: Colors.white54)),
                                  const SizedBox(width: 14),
                                  Text(
                                      '📝 ${_lecon!.exercices.length} exercices',
                                      style: GoogleFonts.nunito(
                                          fontSize: 11,
                                          color: Colors.white54)),
                                  const SizedBox(width: 14),
                                  Text(
                                      '📌 ${_lecon!.regles.length} règles',
                                      style: GoogleFonts.nunito(
                                          fontSize: 11,
                                          color: Colors.white54)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Types d'exercices
                        if (_lecon!.exercices.isNotEmpty) ...[
                          Text('Exercices inclus',
                              style: GoogleFonts.syne(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: C.dark)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: _lecon!.exercices
                                .map((e) => _exerciceBadge(e.type))
                                .toList(),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Règles
                        ..._lecon!.regles.map((regle) => Container(
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
                                    _buildExempleWidget(regle.exemple),
                                  ],
                                ),
                              ),
                            )),

                        // Conseil
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: C.greenSoft,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: C.green.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            children: [
                              const Text('💪 ',
                                  style: TextStyle(fontSize: 20)),
                              Expanded(
                                child: Text(_lecon!.conseil,
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

                        // Bouton démarrer
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _lecon!.exercices.isEmpty
                                ? null
                                : () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ExerciceScreen(lecon: _lecon!),
                                      ),
                                    ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: C.accent,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                              elevation: 0,
                            ),
                            child: Text(
                                '🚀 Démarrer les exercices',
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

  /// Affiche l'exemple d'une règle.
  /// Si l'exemple contient des marqueurs ✅/❌ séparés par \n,
  /// chaque ligne est affichée avec la couleur correspondante.
  Widget _buildExempleWidget(String exemple) {
    final lines =
        exemple.split('\n').where((l) => l.trim().isNotEmpty).toList();
    final hasMarkers =
        lines.any((l) => l.startsWith('✅') || l.startsWith('❌'));

    if (!hasMarkers) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: C.accentSoft,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: C.accent.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            const Text('💡 ', style: TextStyle(fontSize: 14)),
            Expanded(
              child: Text(exemple,
                  style: GoogleFonts.nunito(
                      fontSize: 12,
                      color: C.accent,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: lines.map<Widget>((line) {
        final isCorrect = line.startsWith('✅');
        final isIncorrect = line.startsWith('❌');
        if (!isCorrect && !isIncorrect) return const SizedBox.shrink();
        final color = isCorrect ? C.green : C.red;
        final bg = isCorrect ? C.greenSoft : C.redSoft;
        return Container(
          margin: const EdgeInsets.only(bottom: 6),
          padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.25)),
          ),
          child: Text(line,
              style: GoogleFonts.nunito(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w600,
                  height: 1.4)),
        );
      }).toList(),
    );
  }

  Widget _exerciceBadge(String type) {
    const labels = {
      'choix_multiple': ('🔤', 'Orthographe'),
      'completer': ('✏️', 'Compléter'),
      'correction': ('🔍', 'Correction'),
      'homophone': ('👂', 'Homophone'),
      'accord': ('📐', 'Accord'),
      'dictee': ('📝', 'Dictée'),
    };
    final label = labels[type] ?? ('📚', type);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: C.accentSoft,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: C.accent.withValues(alpha: 0.2)),
      ),
      child: Text('${label.$1} ${label.$2}',
          style: GoogleFonts.nunito(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: C.accent)),
    );
  }
}

// ─── ÉCRAN EXERCICES ──────────────────────────────────────
class ExerciceScreen extends StatefulWidget {
  final Lecon lecon;

  const ExerciceScreen({super.key, required this.lecon});

  @override
  State<ExerciceScreen> createState() => _ExerciceScreenState();
}

class _ExerciceScreenState extends State<ExerciceScreen> {
  int _current = 0;
  String? _selectedAnswer;
  bool _showFeedback = false;
  bool _isCorrect = false;
  int _score = 0;
  final _startTime = DateTime.now();
  final List<Map<String, dynamic>> _errors = [];

  void _selectAnswer(String answer) {
    if (_showFeedback) return;
    final exercice = widget.lecon.exercices[_current];
    final correct = answer == exercice.bonneReponse;
    setState(() {
      _selectedAnswer = answer;
      _showFeedback = true;
      _isCorrect = correct;
      if (correct) {
        _score++;
      } else {
        _errors.add({
          'enonce': exercice.enonce,
          'choisi': answer,
          'correct': exercice.bonneReponse,
          'explication': exercice.explication,
        });
      }
    });
  }

  void _nextExercice() {
    final total = widget.lecon.exercices.length;
    if (_current + 1 >= total) {
      final duration = DateTime.now().difference(_startTime).inSeconds;
      final success = _score >= (total * 0.7).ceil();
      FirebaseService.saveLessonResult(
        lessonId: widget.lecon.id,
        success: success,
        durationSeconds: duration,
        lessonTitre: widget.lecon.titre,
        lessonEmoji: widget.lecon.emoji,
      );
      // Sauvegarde des fautes commises dans le quiz
      if (_errors.isNotEmpty) {
        FirebaseService.saveGameFautes(
          _errors
              .map((e) => {
                    'reponseChoisie': e['choisi']?.toString() ?? '',
                    'bonneReponse': e['correct']?.toString() ?? '',
                  })
              .toList(),
        );
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LessonSummaryScreen(
            lecon: widget.lecon,
            score: _score,
            total: total,
            duration: duration,
            errors: _errors,
          ),
        ),
      );
    } else {
      setState(() {
        _current++;
        _selectedAnswer = null;
        _showFeedback = false;
        _isCorrect = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final exercices = widget.lecon.exercices;
    if (exercices.isEmpty) {
      return Scaffold(
        backgroundColor: C.bg,
        appBar: AppBar(backgroundColor: C.bg, elevation: 0),
        body: Center(
            child: Text('Aucun exercice disponible.',
                style: GoogleFonts.nunito(color: C.muted))),
      );
    }

    final exercice = exercices[_current];
    final progress = (_current + 1) / exercices.length;

    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header progress
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _showExitDialog,
                    child: const Icon(Icons.close, color: C.muted, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SProgressBar(value: progress, color: C.accent, height: 6),
                  ),
                  const SizedBox(width: 12),
                  Text('${_current + 1}/${exercices.length}',
                      style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: C.muted,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Score en direct
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('$_score ✓',
                      style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: C.green)),
                  const SizedBox(width: 8),
                  Text(
                      '${_current - _score} ✗',
                      style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: C.red)),
                ],
              ),
            ),

            // Contenu exercice
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
                child: Column(
                  children: [
                    // Type badge
                    _typeBadge(exercice.type),
                    const SizedBox(height: 16),

                    // Consigne
                    Text(exercice.consigne,
                        style: GoogleFonts.syne(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: C.dark),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 12),

                    // Énoncé
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: C.border),
                        boxShadow: [
                          BoxShadow(
                              color: C.dark.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2))
                        ],
                      ),
                      child: Text(exercice.enonce,
                          style: GoogleFonts.nunito(
                              fontSize: 15,
                              color: C.text,
                              height: 1.5),
                          textAlign: TextAlign.center),
                    ),
                    const SizedBox(height: 20),

                    // Choix
                    ...exercice.choix
                        .map((c) => _choixButton(c, exercice)),

                    // Feedback
                    if (_showFeedback) ...[
                      const SizedBox(height: 16),
                      _feedbackCard(exercice),
                    ],
                  ],
                ),
              ),
            ),

            // Bouton suivant
            if (_showFeedback)
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _nextExercice,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isCorrect ? C.green : C.accent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: Text(
                      _current + 1 >= exercices.length
                          ? 'Voir le résumé →'
                          : 'Exercice suivant →',
                      style: GoogleFonts.nunito(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _typeBadge(String type) {
    const labels = {
      'choix_multiple': ('🔤', 'Orthographe'),
      'completer': ('✏️', 'Compléter'),
      'correction': ('🔍', 'Correction'),
      'homophone': ('👂', 'Homophone'),
      'accord': ('📐', 'Accord'),
      'dictee': ('📝', 'Dictée'),
    };
    final label = labels[type] ?? ('📚', type);
    return SBadge(
        text: '${label.$1} ${label.$2}', color: C.accent);
  }

  Widget _choixButton(String choix, ExerciceLecon exercice) {
    Color borderColor = C.border;
    Color bgColor = Colors.white;
    Color textColor = C.text;

    if (_showFeedback) {
      if (choix == exercice.bonneReponse) {
        borderColor = C.green;
        bgColor = C.greenSoft;
        textColor = C.green;
      } else if (choix == _selectedAnswer && !_isCorrect) {
        borderColor = C.red;
        bgColor = C.redSoft;
        textColor = C.red;
      }
    } else if (choix == _selectedAnswer) {
      borderColor = C.accent;
      bgColor = C.accentSoft;
      textColor = C.accent;
    }

    return GestureDetector(
      onTap: () => _selectAnswer(choix),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(
                color: C.dark.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 1))
          ],
        ),
        child: Text(choix,
            style: GoogleFonts.nunito(
                fontSize: 14,
                color: textColor,
                fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _feedbackCard(ExerciceLecon exercice) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _isCorrect ? C.greenSoft : C.redSoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: _isCorrect
                ? C.green.withValues(alpha: 0.3)
                : C.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_isCorrect ? '✅' : '❌',
              style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    _isCorrect ? 'Correct !' : 'Pas tout à fait...',
                    style: GoogleFonts.syne(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: _isCorrect ? C.green : C.red)),
                const SizedBox(height: 4),
                Text(exercice.explication,
                    style: GoogleFonts.nunito(
                        fontSize: 12,
                        color: _isCorrect ? C.green : C.red,
                        height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18)),
        title: Text('Quitter la leçon ?',
            style: GoogleFonts.syne(fontWeight: FontWeight.w800)),
        content: Text('Ta progression ne sera pas sauvegardée.',
            style: GoogleFonts.nunito(fontSize: 13, color: C.muted)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Continuer',
                style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w700, color: C.accent)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Quitter',
                style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w700, color: C.red)),
          ),
        ],
      ),
    );
  }
}

// ─── RÉSUMÉ DE FIN DE LEÇON ──────────────────────────────
class LessonSummaryScreen extends StatelessWidget {
  final Lecon lecon;
  final int score;
  final int total;
  final int duration; // secondes
  final List<Map<String, dynamic>> errors;

  const LessonSummaryScreen({
    super.key,
    required this.lecon,
    required this.score,
    required this.total,
    required this.duration,
    required this.errors,
  });

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? score / total : 0.0;
    final success = pct >= 0.7;
    final minutes = duration ~/ 60;
    final secs = (duration % 60).toString().padLeft(2, '0');

    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // Résultat hero
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: success
                        ? [C.green, const Color(0xFF00E5A3)]
                        : [C.accent, C.accent2],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(success ? '🎉' : '💪',
                        style: const TextStyle(fontSize: 52)),
                    const SizedBox(height: 12),
                    Text(success ? 'Excellent !' : 'Continue tes efforts !',
                        style: GoogleFonts.syne(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white)),
                    const SizedBox(height: 6),
                    Text('${lecon.emoji} ${lecon.titre}',
                        style: GoogleFonts.nunito(
                            fontSize: 13, color: Colors.white70),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _statPill('$score/$total', 'bonnes réponses'),
                        const SizedBox(width: 12),
                        _statPill('${minutes}m$secs', 'durée'),
                        const SizedBox(width: 12),
                        _statPill(
                            '${(pct * 100).round()}%', 'réussite'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Progression (acquise ?)
              if (success) ...[
                SCard(
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: C.greenSoft,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Center(
                            child: Text('⭐',
                                style: TextStyle(fontSize: 18))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Progression sauvegardée',
                                style: GoogleFonts.syne(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: C.dark)),
                            const SizedBox(height: 2),
                            Text(lecon.conseil,
                                style: GoogleFonts.nunito(
                                    fontSize: 11,
                                    color: C.muted,
                                    height: 1.4)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // Points à revoir
              if (errors.isNotEmpty) ...[
                Text('📌 Points à revoir',
                    style: GoogleFonts.syne(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: C.dark)),
                const SizedBox(height: 10),
                ...errors.map((e) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: C.red.withValues(alpha: 0.15)),
                        boxShadow: [
                          BoxShadow(
                              color: C.dark.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2))
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e['enonce'] ?? '',
                              style: GoogleFonts.nunito(
                                  fontSize: 11,
                                  color: C.muted,
                                  fontStyle: FontStyle.italic),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(
                                child: Text('❌ ${e['choisi']}',
                                    style: GoogleFonts.nunito(
                                        fontSize: 12,
                                        color: C.red,
                                        fontWeight: FontWeight.w700)),
                              ),
                              const Text(' → ',
                                  style: TextStyle(color: C.muted)),
                              Expanded(
                                child: Text('✅ ${e['correct']}',
                                    style: GoogleFonts.nunito(
                                        fontSize: 12,
                                        color: C.green,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(e['explication'] ?? '',
                              style: GoogleFonts.nunito(
                                  fontSize: 11,
                                  color: C.muted,
                                  height: 1.3)),
                        ],
                      ),
                    )),
                const SizedBox(height: 12),
              ],

              // Boutons d'action
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((r) => r.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: C.accent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: Text('Retour aux leçons',
                      style: GoogleFonts.nunito(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ),
              ),

              if (!success) ...[
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context); // ferme summary
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExerciceScreen(lecon: lecon),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: C.accent),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text('🔄 Recommencer',
                        style: GoogleFonts.nunito(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: C.accent)),
                  ),
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statPill(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Column(
        children: [
          Text(value,
              style: GoogleFonts.syne(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white)),
          Text(label,
              style:
                  GoogleFonts.nunito(fontSize: 9, color: Colors.white70)),
        ],
      ),
    );
  }
}
