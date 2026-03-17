import 'dart:convert';
import 'package:http/http.dart' as http;
import 'bescherelle_rules.dart';

class GeminiService {
  static const _apiKey = 'AIzaSyBA_L3OoAJ_MgVwOxCiXedhjuVu90rVw9I';
  static const _url =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$_apiKey';

  // ─── GÉNÈRE 5 QUESTIONS DE JEU ───────────────────────────
  Future<List<GameQuestion>> generateQuestions(List<String> fautes) async {
    final contexte = fautes.isEmpty
        ? 'orthographe française générale'
        : 'les fautes suivantes : ${fautes.join(', ')}';

    final bescherelleContext = BescherelleRules.getRulesContext(fautes);
    final rulesSection = bescherelleContext.isNotEmpty
        ? '\n$bescherelleContext\n'
        : '';

    final prompt = '''
Tu es un professeur de français. Génère 5 questions de jeu d'orthographe basées sur $contexte.
$rulesSection
Réponds UNIQUEMENT avec un JSON valide, sans texte avant ou après, sans balises markdown.
Format exact :
[
  {
    "phrase": "Il ___ allé au marché.",
    "trous": ["___"],
    "reponses": ["est", "et", "ai", "ont"],
    "bonnesReponses": ["est"],
    "explications": ["'est' = verbe être / 'et' = conjonction de coordination"]
  }
]

Règles :
- Chaque phrase a 1 ou 2 trous maximum notés ___
- 4 propositions de réponse par question
- Les mauvaises réponses doivent être plausibles
- explications : une explication courte par trou (pourquoi c'est la bonne réponse)
- Phrases en français, niveau collège
''';

    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'maxOutputTokens': 1500,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text =
            data['candidates'][0]['content']['parts'][0]['text'] as String;
        final clean =
            text.replaceAll('```json', '').replaceAll('```', '').trim();
        final List<dynamic> json = jsonDecode(clean);
        return json.map((e) => GameQuestion.fromJson(e)).toList();
      }
    } catch (e) {
      // fallback sur questions statiques si erreur
    }
    return _fallbackQuestions();
  }

  // ─── GÉNÈRE UNE LEÇON COMPLÈTE AVEC EXERCICES ────────────
  // fautes : mots mal écrits par l'utilisateur
  // topic  : sujet libre (catalogue), prioritaire si fourni
  Future<Lecon> generateLecon(List<String> fautes, {String? topic}) async {
    final contexte = topic != null
        ? 'le sujet suivant : "$topic"'
        : fautes.isEmpty
            ? 'orthographe française générale'
            : 'ces fautes récentes : ${fautes.join(', ')}';

    final bescherelleContext = BescherelleRules.getRulesContext(fautes);
    final rulesSection = bescherelleContext.isNotEmpty
        ? '\n$bescherelleContext\n'
        : '';

    final prompt = '''
Tu es un professeur de français bienveillant. Génère une leçon complète avec exercices basée sur $contexte.
$rulesSection

Réponds UNIQUEMENT avec un JSON valide, sans texte avant ou après, sans balises markdown.
Format exact :
{
  "titre": "Titre court de la leçon",
  "emoji": "📝",
  "duree": "10 min",
  "resume": "Une phrase de résumé.",
  "regles": [
    {
      "titre": "Règle 1",
      "explication": "Explication claire et simple.",
      "exemple": "✅ Exemple correct.\\n❌ Exemple incorrect."
    }
  ],
  "conseil": "Un conseil motivant pour l'utilisateur.",
  "exercices": [
    {
      "type": "choix_multiple",
      "consigne": "Quelle est la bonne orthographe ?",
      "enonce": "Texte ou question de l'exercice.",
      "choix": ["option1", "option2", "option3", "option4"],
      "bonneReponse": "option1",
      "explication": "Explication de la bonne réponse."
    }
  ]
}

Règles pour les exercices :
- Génère exactement 6 exercices
- Types obligatoires dans cet ordre : choix_multiple, completer, correction, homophone, accord, dictee
- 4 choix par exercice
- bonneReponse doit être exactement l'une des valeurs dans choix (copie exacte)
- Niveau collège, langage simple et encourageant

Règles pour la leçon :
- Maximum 3 règles
- Langage simple, bienveillant
- exemple : ✅ une phrase correcte, puis \\n, puis ❌ une phrase incorrecte
''';

    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.5,
            'maxOutputTokens': 2500,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text =
            data['candidates'][0]['content']['parts'][0]['text'] as String;
        final clean =
            text.replaceAll('```json', '').replaceAll('```', '').trim();
        final Map<String, dynamic> json = jsonDecode(clean);
        return Lecon.fromJson(json);
      }
    } catch (e) {
      // fallback
    }
    return _fallbackLecon();
  }

  // ─── FALLBACKS ───────────────────────────────────────────
  List<GameQuestion> _fallbackQuestions() => [
        GameQuestion(
          phrase: 'Il ___ allé au marché ce matin.',
          trous: ['___'],
          reponses: ['est', 'et', 'ai', 'ont'],
          bonnesReponses: ['est'],
          explications: ["'est' = verbe être / 'et' = conjonction"],
        ),
        GameQuestion(
          phrase: 'Elle a ___ son livre sur la table.',
          trous: ['___'],
          reponses: ['posé', 'poser', 'posée', 'posés'],
          bonnesReponses: ['posé'],
          explications: [
            'Participe passé avec avoir, pas d\'accord avec le sujet.'
          ],
        ),
        GameQuestion(
          phrase: 'Tu ___ vraiment bien travaillé.',
          trous: ['___'],
          reponses: ['as', 'a', 'es', 'ai'],
          bonnesReponses: ['as'],
          explications: [
            "'as travaillé' = passé composé, 2e personne du singulier."
          ],
        ),
        GameQuestion(
          phrase: 'Nous ___ mangé une bonne ___ .',
          trous: ['___', '___'],
          reponses: ['avons', 'pizza', 'sommes', 'pain'],
          bonnesReponses: ['avons', 'pizza'],
          explications: [
            "'avons mangé' = passé composé avec avoir.",
            "'pizza' complète le sens de la phrase."
          ],
        ),
        GameQuestion(
          phrase: 'Les enfants ___ jouer dans le ___ .',
          trous: ['___', '___'],
          reponses: ['veulent', 'jardin', 'voulons', 'maison'],
          bonnesReponses: ['veulent', 'jardin'],
          explications: [
            "'veulent' = ils/elles veulent.",
            "'jardin' est masculin singulier."
          ],
        ),
      ];

  Lecon _fallbackLecon() => Lecon(
        titre: 'L\'accord du participe passé',
        emoji: '📝',
        duree: '10 min',
        resume: 'Le participe passé s\'accorde selon l\'auxiliaire utilisé.',
        regles: [
          RegleLecon(
            titre: 'Avec avoir',
            explication:
                'Le participe passé ne s\'accorde pas avec le sujet.',
            exemple: 'Elle a mangé une pomme.',
          ),
          RegleLecon(
            titre: 'Avec être',
            explication: 'Le participe passé s\'accorde avec le sujet.',
            exemple: 'Elle est partie.',
          ),
        ],
        conseil: 'Continue comme ça, tu progresses vite ! 💪',
        exercices: _fallbackExercices(),
      );

  List<ExerciceLecon> _fallbackExercices() => [
        const ExerciceLecon(
          type: 'choix_multiple',
          consigne: 'Quelle est la bonne orthographe ?',
          enonce: 'Comment écrit-on ce mot courant ?',
          choix: ['aujourd\'hui', 'aujordhui', 'aujoud\'hui', 'ojour\'dhui'],
          bonneReponse: 'aujourd\'hui',
          explication:
              '"Aujourd\'hui" vient de "au jour de hui". Il faut l\'apostrophe entre "d" et "hui".',
        ),
        const ExerciceLecon(
          type: 'completer',
          consigne: 'Complète la phrase avec le bon mot.',
          enonce: 'Elle ___ allée au cinéma hier soir.',
          choix: ['est', 'et', 'ai', 'ont'],
          bonneReponse: 'est',
          explication:
              '"est" = verbe être conjugué. "et" est une conjonction de coordination.',
        ),
        const ExerciceLecon(
          type: 'correction',
          consigne: 'Quelle phrase est correctement orthographiée ?',
          enonce: 'Choisissez la phrase sans faute.',
          choix: [
            'Il a beaucoup mangé.',
            'Il a beaucoups mangé.',
            'Il as beaucoup mangé.',
            'Il a beaucoupt mangé.'
          ],
          bonneReponse: 'Il a beaucoup mangé.',
          explication: '"beaucoup" est invariable et s\'écrit sans s final.',
        ),
        const ExerciceLecon(
          type: 'homophone',
          consigne: 'Quel est le bon homophone ?',
          enonce: 'Il ___ parti sans prévenir.',
          choix: ['est', 'et', 'ai', 'es'],
          bonneReponse: 'est',
          explication:
              '"est" (verbe être) ≠ "et" (conjonction). Astuce : remplace par "était" pour vérifier.',
        ),
        const ExerciceLecon(
          type: 'accord',
          consigne: 'Choisissez la bonne forme accordée.',
          enonce: 'Les filles ___ contentes de leur résultat.',
          choix: ['sont', 'est', 'sommes', 'êtes'],
          bonneReponse: 'sont',
          explication:
              'Sujet pluriel "les filles" → verbe au pluriel "sont".',
        ),
        const ExerciceLecon(
          type: 'dictee',
          consigne: 'Quelle phrase est écrite correctement ?',
          enonce: 'Identifiez la transcription sans faute.',
          choix: [
            'C\'est là-bas.',
            'C\'est labas.',
            'C\'est là bas.',
            'Sé là-bas.'
          ],
          bonneReponse: 'C\'est là-bas.',
          explication:
              '"là-bas" prend un trait d\'union et un accent grave sur le "à".',
        ),
      ];
}

// ─── MODÈLES ─────────────────────────────────────────────
class GameQuestion {
  final String phrase;
  final List<String> trous;
  final List<String> reponses;
  final List<String> bonnesReponses;
  final List<String> explications;

  const GameQuestion({
    required this.phrase,
    required this.trous,
    required this.reponses,
    required this.bonnesReponses,
    required this.explications,
  });

  factory GameQuestion.fromJson(Map<String, dynamic> json) => GameQuestion(
        phrase: json['phrase'],
        trous: List<String>.from(json['trous']),
        reponses: List<String>.from(json['reponses']),
        bonnesReponses: List<String>.from(json['bonnesReponses']),
        explications: List<String>.from(json['explications']),
      );
}

class ExerciceLecon {
  final String type; // choix_multiple | completer | correction | homophone | accord | dictee
  final String consigne;
  final String enonce;
  final List<String> choix;
  final String bonneReponse;
  final String explication;

  const ExerciceLecon({
    required this.type,
    required this.consigne,
    required this.enonce,
    required this.choix,
    required this.bonneReponse,
    required this.explication,
  });

  factory ExerciceLecon.fromJson(Map<String, dynamic> json) => ExerciceLecon(
        type: json['type'] ?? 'choix_multiple',
        consigne: json['consigne'] ?? '',
        enonce: json['enonce'] ?? '',
        choix: List<String>.from(json['choix'] ?? []),
        bonneReponse: json['bonneReponse'] ?? '',
        explication: json['explication'] ?? '',
      );
}

class Lecon {
  final String titre;
  final String emoji;
  final String duree;
  final String resume;
  final List<RegleLecon> regles;
  final String conseil;
  final List<ExerciceLecon> exercices;
  final String id;

  Lecon({
    required this.titre,
    required this.emoji,
    required this.duree,
    required this.resume,
    required this.regles,
    required this.conseil,
    this.exercices = const [],
    String? id,
  }) : id = id ?? '${titre.hashCode.abs()}';

  factory Lecon.fromJson(Map<String, dynamic> json) => Lecon(
        titre: json['titre'] ?? '',
        emoji: json['emoji'] ?? '📝',
        duree: json['duree'] ?? '10 min',
        resume: json['resume'] ?? '',
        regles: (json['regles'] as List? ?? [])
            .map((r) => RegleLecon.fromJson(r))
            .toList(),
        conseil: json['conseil'] ?? '',
        exercices: (json['exercices'] as List? ?? [])
            .map((e) => ExerciceLecon.fromJson(e))
            .toList(),
        id: json['id']?.toString(),
      );

  Map<String, dynamic> toMap() => {
        'titre': titre,
        'emoji': emoji,
        'duree': duree,
        'resume': resume,
        'conseil': conseil,
        'id': id,
      };
}

class RegleLecon {
  final String titre;
  final String explication;
  final String exemple;

  RegleLecon({
    required this.titre,
    required this.explication,
    required this.exemple,
  });

  factory RegleLecon.fromJson(Map<String, dynamic> json) => RegleLecon(
        titre: json['titre'],
        explication: json['explication'],
        exemple: json['exemple'],
      );
}
