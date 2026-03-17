// Règles grammaticales Bescherelle pour enrichir les prompts Gemini.
// Usage : BescherelleRules.getRulesForFaute(mot) → liste de règles pertinentes
//         BescherelleRules.getRulesContext(fautes) → bloc texte prêt à injecter

class BescherelleRules {
  // ─── TOUTES LES RÈGLES ────────────────────────────────────

  static const Map<String, List<String>> _rules = {
    // ── CONJUGAISON ──────────────────────────────────────────
    'auxiliaires': [
      "ÊTRE (auxiliaire) : je suis, tu es, il est, nous sommes, vous êtes, ils sont.",
      "AVOIR (auxiliaire) : j'ai, tu as, il a, nous avons, vous avez, ils ont.",
      "Verbes d'état et de mouvement (aller, venir, partir, arriver, naître, mourir…) se conjuguent avec ÊTRE au passé composé.",
      "La plupart des autres verbes se conjuguent avec AVOIR au passé composé.",
    ],
    'present': [
      "Présent indicatif -ER : je chante, tu chantes, il chante, nous chantons, vous chantez, ils chantent.",
      "Présent indicatif -IR (finir) : je finis, tu finis, il finit, nous finissons, vous finissez, ils finissent.",
      "Présent indicatif -RE (prendre) : je prends, tu prends, il prend, nous prenons, vous prenez, ils prennent.",
      "Verbes irréguliers courants : être/avoir/aller/faire/pouvoir/vouloir/venir/dire/voir.",
    ],
    'passe_compose': [
      "Passé composé = auxiliaire (avoir/être) au présent + participe passé.",
      "Avec AVOIR : le participe passé ne s'accorde PAS avec le sujet (sauf COD avant le verbe).",
      "Avec ÊTRE : le participe passé s'accorde en genre et en nombre avec le sujet.",
      "Exemples : Il a mangé. / Elle est partie. / Ils sont arrivés. / Elles se sont levées.",
    ],
    'imparfait': [
      "Imparfait : radical du présent (nous) + -ais, -ais, -ait, -ions, -iez, -aient.",
      "Exemple : chanter → nous chantons → je chantais, tu chantais, il chantait…",
      "Exception : être → j'étais, tu étais, il était, nous étions, vous étiez, ils étaient.",
      "Usage : action durable ou répétée dans le passé, description, habitude passée.",
    ],
    'futur': [
      "Futur simple = infinitif + -ai, -as, -a, -ons, -ez, -ont.",
      "Verbes -RE perdent le e final : prendre → je prendrai.",
      "Futurs irréguliers courants : être→serai, avoir→aurai, aller→irai, faire→ferai, venir→viendrai, voir→verrai, pouvoir→pourrai, vouloir→voudrai, savoir→saurai.",
    ],
    'conditionnel': [
      "Conditionnel présent = infinitif + -ais, -ais, -ait, -ions, -iez, -aient.",
      "Mêmes radicaux irréguliers qu'au futur : je serais, j'aurais, j'irais, je ferais…",
      "Usage : politesse, hypothèse, fait non confirmé, conséquence d'une condition.",
    ],
    'subjonctif': [
      "Subjonctif présent = que + radical (ils, présent) + -e, -es, -e, -ions, -iez, -ent.",
      "Subjonctifs irréguliers : être→soit, avoir→ait, aller→aille, faire→fasse, pouvoir→puisse, vouloir→veuille.",
      "Emploi : après que + verbe de volonté, doute, sentiment, obligation, certains verbes impersonnels.",
    ],
    'imperatif': [
      "Impératif présent : 2e pers. sing., 1re pers. plur., 2e pers. plur. (sans pronom sujet).",
      "Verbes -ER : chante (sans s), chantons, chantez. Exception : vas-y (avec s devant y/en).",
      "Verbes -IR/-RE : finis, finissons, finissez / prends, prenons, prenez.",
      "Forme négative : ne + verbe + pas. Ex : Ne chante pas !",
    ],

    // ── ACCORDS ───────────────────────────────────────────────
    'accord_sujet_verbe': [
      "Le verbe s'accorde toujours avec son sujet en personne et en nombre.",
      "Sujets coordonnés par 'et' → verbe au pluriel. Ex : Pierre et Marie sont venus.",
      "Sujet collectif (foule, groupe…) → accord avec le sens (singulier ou pluriel possible).",
      "Attention aux sujets inversés dans les questions : Viennent-ils ? → sujet = ils.",
    ],
    'accord_adjectif': [
      "L'adjectif qualificatif s'accorde en genre et en nombre avec le nom qu'il qualifie.",
      "Féminin : généralement +e (petit→petite). Exceptions : beau→belle, nouveau→nouvelle, vieux→vieille.",
      "Pluriel : généralement +s. Adjectifs en -eau → +x (beau→beaux). Adjectifs déjà en -s/-x invariables.",
      "Adjectifs de couleur composés ou noms employés comme couleur : invariables (bleu marine, kaki).",
    ],
    'accord_participe': [
      "Participe passé avec AVOIR : pas d'accord avec le sujet. Ex : Elles ont chanté.",
      "Participe passé avec AVOIR + COD avant le verbe : accord avec le COD. Ex : La chanson qu'ils ont chantée.",
      "Participe passé avec ÊTRE : accord avec le sujet. Ex : Elles sont parties. Ils sont arrivés.",
      "Verbes pronominaux : accord avec le COD si le COD précède ; sinon pas d'accord.",
    ],
    'pluriel': [
      "Pluriel général : +s. Noms en -s/-x/-z déjà invariables.",
      "Noms en -eau/-au/-eu → +x (gâteau→gâteaux, feu→feux). Exceptions : pneu→pneus, bleu→bleus.",
      "Noms en -al → -aux (cheval→chevaux). Exceptions : bal→bals, carnaval→carnavals.",
      "Noms en -ou : +s en général ; 7 exceptions +x : bijou, caillou, chou, genou, hibou, joujou, pou.",
    ],

    // ── HOMOPHONES ────────────────────────────────────────────
    'a_a': [
      "a (sans accent) = verbe avoir (il a). Test : remplacer par 'avait' → si possible, pas d'accent.",
      "à (avec accent) = préposition (lieu, temps, manière). Test : si 'avait' ne convient pas → accent.",
      "Exemples : Il a (avait) faim. / Il va à (≠avait) Paris.",
    ],
    'est_et': [
      "est = verbe être (il est). Test : remplacer par 'était' → si possible, c'est 'est'.",
      "et = conjonction de coordination (= 'et puis'). Test : si 'était' ne convient pas → 'et'.",
      "Exemples : Il est (était) tard. / Paul et (puis) Marie sont amis.",
    ],
    'ou_ou': [
      "ou (sans accent) = conjonction de choix (= 'ou bien'). Ex : café ou thé.",
      "où (avec accent) = pronom relatif ou adverbe de lieu/temps. Ex : Où vas-tu ? La ville où je vis.",
    ],
    'son_sont': [
      "son = déterminant possessif (= 'son/sa/ses'). Ex : son livre.",
      "sont = verbe être (3e pers. plur.). Test : remplacer par 'étaient' → si possible, c'est 'sont'.",
      "Exemples : Ils sont (étaient) partis. / Il range son (sa) livre.",
    ],
    'se_ce': [
      "se = pronom réfléchi (verbes pronominaux). Ex : Il se lève.",
      "ce = déterminant démonstratif (ce livre) ou pronom (c'est, ce que…).",
      "Test : si 'se' peut être remplacé par 'me/te' en changeant la personne → 'se'. Sinon → 'ce'.",
    ],
    'on_ont': [
      "on = pronom sujet indéfini (= 'nous' familier). Ex : On mange.",
      "ont = verbe avoir (3e pers. plur.). Test : remplacer par 'avaient' → si possible, c'est 'ont'.",
      "Exemples : Ils ont (avaient) fini. / On (nous) part demain.",
    ],
    'leur_leurs': [
      "leur (pronom, invariable) = COI de 3e pers. plur. Ex : Je leur parle.",
      "leur (déterminant possessif sing.) = appartenant à eux/elles. Ex : leur maison.",
      "leurs (déterminant possessif plur.) = plusieurs objets. Ex : leurs maisons.",
      "Test : si on peut remplacer par 'lui', c'est 'leur' pronom. Si on peut ajouter 's' au nom qui suit, c'est 'leurs'.",
    ],
    'peu_peut_peux': [
      "peu = adverbe de quantité (= 'pas beaucoup'). Ex : Il mange peu.",
      "peut = verbe pouvoir (3e pers. sing.). Test : remplacer par 'pouvait' → si possible, c'est 'peut'.",
      "peux = verbe pouvoir (1re/2e pers. sing.). Ex : Je peux, tu peux.",
      "peut-être = adverbe de doute (= 'possiblement'). Ne pas confondre avec 'peut être' (verbe).",
    ],

    // ── ORTHOGRAPHE LEXICALE ──────────────────────────────────
    'accents': [
      "Accent aigu (é) : uniquement sur le e. Ex : été, café, éléphant.",
      "Accent grave (è, à, ù) : sur e (è), a (à préposition), u (où adverbe). Ex : père, là, où.",
      "Accent circonflexe (â, ê, î, ô, û) : souvent vestige d'un s disparu. Ex : forêt (forest), fête (feste).",
      "Tréma (ë, ï, ü) : indique que la voyelle se prononce séparément. Ex : Noël, naïf.",
    ],
    'consonnes_doubles': [
      "Doublement fréquent : ll (ville, famille), mm (pomme), nn (bonne), pp (apporter), rr (arrêt), ss (poisson), tt (nette).",
      "Préfixe 'ap-' : souvent 'app-' (apporter, appeler). Mais : apercevoir, apaiser.",
      "Préfixe 'ac-' : souvent 'acc-' (accorder, accuser). Mais : académie, acompte.",
      "Noms en -ette, -otte, -elle, -erre, -esse : consonne double avant la terminaison.",
    ],
    'apostrophe': [
      "L'apostrophe remplace une voyelle élidée devant voyelle ou h muet.",
      "Élision obligatoire : le/la→l', de→d', ne→n', que→qu', je→j', me→m', te→t', se→s', si→s' (devant il/ils).",
      "Pas d'élision devant h aspiré : le hibou, la honte, le huit (mais l'heure, l'homme).",
    ],
    'trait_union': [
      "Trait d'union dans les nombres composés inférieurs à 100 : vingt-deux, quatre-vingt-trois.",
      "Trait d'union dans les mots composés : arc-en-ciel, chef-d'œuvre, compte-rendu.",
      "Trait d'union après l'impératif avec pronom : donne-moi, vas-y, prends-en.",
      "Trait d'union dans les adverbes ci/là : ci-dessus, là-bas, là-haut.",
    ],

    // ── PONCTUATION ───────────────────────────────────────────
    'virgule': [
      "Virgule pour séparer les éléments d'une énumération (sauf avant 'et'/'ou' final).",
      "Virgule pour isoler une apposition ou un complément circonstanciel en tête de phrase.",
      "Virgule pour séparer deux propositions juxtaposées.",
      "Pas de virgule entre sujet et verbe, ni entre verbe et complément direct.",
    ],
    'point_virgule': [
      "Point-virgule entre deux propositions indépendantes liées par le sens.",
      "Point-virgule dans les énumérations longues à la place de la virgule.",
      "Moins fort que le point, plus fort que la virgule.",
    ],
    'deux_points': [
      "Deux-points annoncent une explication, une énumération, une citation, un discours direct.",
      "Ce qui suit les deux-points développe ou illustre ce qui précède.",
      "Pas de majuscule obligatoire après les deux-points (sauf citation ou discours direct).",
    ],
    'guillemets': [
      "Guillemets français (« ») pour les citations et le discours direct.",
      "Espace insécable après « et avant ».",
      "Guillemets anglais (\"\") dans les textes informatiques ou citations dans une citation.",
    ],

    // ── SYNTAXE ───────────────────────────────────────────────
    'negation': [
      "Négation standard : ne … pas (je ne mange pas).",
      "Autres négations : ne … jamais, ne … plus, ne … rien, ne … personne, ne … que (restriction).",
      "En langage oral familier, 'ne' est souvent omis : Je mange pas. (à éviter à l'écrit soigné)",
      "Négation de l'infinitif : ne pas + infinitif. Ex : Ne pas fumer. (les deux mots avant l'infinitif)",
    ],
    'pronoms': [
      "Pronoms personnels sujets : je, tu, il/elle/on, nous, vous, ils/elles.",
      "Pronoms COD : me, te, le/la/l', nous, vous, les.",
      "Pronoms COI : me, te, lui, nous, vous, leur.",
      "Pronoms toniques : moi, toi, lui/elle, nous, vous, eux/elles (après préposition, pour insistance).",
    ],
    'questions': [
      "Question totale (oui/non) : intonation montante, est-ce que…, ou inversion sujet-verbe.",
      "Question partielle : mot interrogatif (qui, que, quoi, où, quand, comment, pourquoi, combien) + est-ce que ou inversion.",
      "Inversion simple : Vient-il ? Parles-tu ? (trait d'union obligatoire).",
      "Inversion complexe : Paul vient-il ? (sujet nominal + pronom inversé).",
    ],
    'subordonnees': [
      "Proposition subordonnée relative : introduite par qui, que, quoi, dont, où (complète un nom).",
      "Proposition subordonnée conjonctive : introduite par que, quand, si, parce que, bien que… (complète le verbe principal).",
      "Subordonnée temporelle : quand, lorsque, dès que, avant que (+subjonctif), après que (+indicatif).",
      "Subordonnée causale : parce que, car, puisque, comme (en tête de phrase).",
    ],
  };

  // ─── CORRESPONDANCES MOT → CATÉGORIES DE RÈGLES ──────────

  static const List<_RuleMapping> _mappings = [
    // Homophones
    _RuleMapping(keywords: ['a', 'à', 'avait'], categories: ['a_a']),
    _RuleMapping(keywords: ['est', 'et', 'était'], categories: ['est_et']),
    _RuleMapping(keywords: ['ou', 'où'], categories: ['ou_ou']),
    _RuleMapping(keywords: ['son', 'sont'], categories: ['son_sont', 'auxiliaires']),
    _RuleMapping(keywords: ['se', 'ce'], categories: ['se_ce']),
    _RuleMapping(keywords: ['on', 'ont'], categories: ['on_ont', 'auxiliaires']),
    _RuleMapping(keywords: ['leur', 'leurs'], categories: ['leur_leurs']),
    _RuleMapping(keywords: ['peu', 'peut', 'peux'], categories: ['peu_peut_peux']),

    // Conjugaison
    _RuleMapping(keywords: ['suis', 'es', 'sommes', 'êtes', 'ai', 'as', 'avons', 'avez'], categories: ['present', 'auxiliaires']),
    _RuleMapping(keywords: ['était', 'avait', 'faisait', 'allait'], categories: ['imparfait']),
    _RuleMapping(keywords: ['sera', 'serai', 'aura', 'aurai', 'fera', 'ferai', 'ira', 'irai'], categories: ['futur']),
    _RuleMapping(keywords: ['serait', 'aurait', 'ferait', 'irait', 'viendrait'], categories: ['conditionnel']),
    _RuleMapping(keywords: ['soit', 'ait', 'fasse', 'aille', 'puisse', 'veuille'], categories: ['subjonctif']),
    _RuleMapping(keywords: ['passé', 'composé', 'participe'], categories: ['passe_compose', 'accord_participe']),

    // Accords
    _RuleMapping(keywords: ['accord', 'accordé', 'accordée', 'accordés', 'accordées'], categories: ['accord_adjectif', 'accord_participe', 'accord_sujet_verbe']),
    _RuleMapping(keywords: ['pluriel', 'singulier', 'pluriels'], categories: ['pluriel', 'accord_adjectif']),
    _RuleMapping(keywords: ['sujet', 'verbe'], categories: ['accord_sujet_verbe']),
    _RuleMapping(keywords: ['adjectif', 'féminin', 'masculin'], categories: ['accord_adjectif']),

    // Orthographe
    _RuleMapping(keywords: ['accent', 'accents', 'accentué'], categories: ['accents']),
    _RuleMapping(keywords: ['double', 'doublement', 'consonne'], categories: ['consonnes_doubles']),
    _RuleMapping(keywords: ["apostrophe", "l'", "d'", "qu'"], categories: ['apostrophe']),
    _RuleMapping(keywords: ['trait', 'union', 'tiret'], categories: ['trait_union']),

    // Ponctuation
    _RuleMapping(keywords: ['virgule', ','], categories: ['virgule']),
    _RuleMapping(keywords: ['point-virgule', ';'], categories: ['point_virgule']),
    _RuleMapping(keywords: ['deux-points', ':'], categories: ['deux_points']),
    _RuleMapping(keywords: ['guillemets', '«', '»'], categories: ['guillemets']),

    // Syntaxe
    _RuleMapping(keywords: ['ne', 'pas', 'jamais', 'plus', 'rien', 'négation'], categories: ['negation']),
    _RuleMapping(keywords: ['pronom', 'pronoms', 'lui', 'moi', 'toi', 'eux'], categories: ['pronoms']),
    _RuleMapping(keywords: ['question', 'interrogatif', 'pourquoi', 'comment', 'quand', 'combien'], categories: ['questions']),
    _RuleMapping(keywords: ['que', 'qui', 'dont', 'subordonnée', 'parce que'], categories: ['subordonnees']),
  ];

  // ─── API PUBLIQUE ─────────────────────────────────────────

  /// Retourne les règles pertinentes pour un mot/faute donné.
  static List<String> getRulesForFaute(String faute) {
    final lower = faute.toLowerCase().trim();
    final Set<String> categories = {};

    for (final mapping in _mappings) {
      for (final kw in mapping.keywords) {
        if (lower == kw || lower.contains(kw) || kw.contains(lower)) {
          categories.addAll(mapping.categories);
          break;
        }
      }
    }

    // Fallback : si aucune catégorie trouvée, retourner règles générales d'accord
    if (categories.isEmpty) {
      categories.addAll(['accord_sujet_verbe', 'present', 'accents']);
    }

    final List<String> result = [];
    for (final cat in categories) {
      final rules = _rules[cat];
      if (rules != null) result.addAll(rules);
    }
    return result;
  }

  /// Retourne un bloc texte formaté des règles pertinentes pour une liste de fautes.
  /// Prêt à être injecté dans un prompt Gemini.
  static String getRulesContext(List<String> fautes) {
    if (fautes.isEmpty) return '';

    final Set<String> allRules = {};
    for (final faute in fautes) {
      allRules.addAll(getRulesForFaute(faute));
    }

    if (allRules.isEmpty) return '';

    // Limite à 20 règles pour ne pas surcharger le prompt
    final limited = allRules.take(20).toList();
    final buffer = StringBuffer();
    buffer.writeln('Règles grammaticales Bescherelle à respecter :');
    for (final rule in limited) {
      buffer.writeln('• $rule');
    }
    return buffer.toString().trim();
  }
}

// ─── HELPER INTERNE ───────────────────────────────────────

class _RuleMapping {
  final List<String> keywords;
  final List<String> categories;

  const _RuleMapping({required this.keywords, required this.categories});
}
