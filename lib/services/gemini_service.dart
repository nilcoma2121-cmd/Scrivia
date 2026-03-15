import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const _apiKey = 'AIzaSyBA_L3OoAJ_MgVwOxCiXedhjuVu90rVw9I';
  static const _url =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$_apiKey';

  // ─── GÉNÈRE 5 QUESTIONS DE JEU ───────────────────────────
  // fautes : liste de mots que l'utilisateur a mal écrits
  Future<List<GameQuestion>> generateQuestions(List<String> fautes) async {
    final contexte = fautes.isEmpty
        ? 'orthographe française générale'
        : 'les fautes suivantes : ${fautes.join(', ')}';

    final prompt = '''
Tu es un professeur de français. Génère 5 questions de jeu d'orthographe basées sur $contexte.

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
        final clean = text.replaceAll('```json', '').replaceAll('```', '').trim();
        final List<dynamic> json = jsonDecode(clean);
        return json.map((e) => GameQuestion.fromJson(e)).toList();
      }
    } catch (e) {
      // fallback sur questions statiques si erreur
    }
    return _fallbackQuestions();
  }

  // ─── GÉNÈRE UNE LEÇON PERSONNALISÉE ──────────────────────
  Future<Lecon> generateLecon(List<String> fautes) async {
    final contexte = fautes.isEmpty
        ? 'orthographe française générale'
        : 'ces fautes récentes : ${fautes.join(', ')}';

    final prompt = '''
Tu es un professeur de français bienveillant. Génère une leçon courte basée sur $contexte.

Réponds UNIQUEMENT avec un JSON valide, sans texte avant ou après, sans balises markdown.
Format exact :
{
  "titre": "Titre de la leçon",
  "emoji": "📝",
  "duree": "5 min",
  "resume": "Une phrase de résumé de la leçon.",
  "regles": [
    {
      "titre": "Règle 1",
      "explication": "Explication courte et claire.",
      "exemple": "Exemple concret."
    }
  ],
  "conseil": "Un conseil motivant pour l'utilisateur."
}

Maximum 3 règles. Langage simple, encourageant.
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
            'maxOutputTokens': 1000,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text =
            data['candidates'][0]['content']['parts'][0]['text'] as String;
        final clean = text.replaceAll('```json', '').replaceAll('```', '').trim();
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
          explications: ['Participe passé avec avoir, pas d\'accord avec le sujet.'],
        ),
        GameQuestion(
          phrase: 'Tu ___ vraiment bien travaillé.',
          trous: ['___'],
          reponses: ['as', 'a', 'es', 'ai'],
          bonnesReponses: ['as'],
          explications: ["'as travaillé' = passé composé, 2e personne du singulier."],
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
        duree: '5 min',
        resume:
            'Le participe passé s\'accorde selon l\'auxiliaire utilisé.',
        regles: [
          RegleLecon(
            titre: 'Avec avoir',
            explication:
                'Le participe passé ne s\'accorde pas avec le sujet.',
            exemple: 'Elle a mangé une pomme.',
          ),
          RegleLecon(
            titre: 'Avec être',
            explication:
                'Le participe passé s\'accorde avec le sujet.',
            exemple: 'Elle est partie.',
          ),
        ],
        conseil: 'Continue comme ça, tu progresses vite ! 💪',
      );
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

class Lecon {
  final String titre;
  final String emoji;
  final String duree;
  final String resume;
  final List<RegleLecon> regles;
  final String conseil;

  Lecon({
    required this.titre,
    required this.emoji,
    required this.duree,
    required this.resume,
    required this.regles,
    required this.conseil,
  });

  factory Lecon.fromJson(Map<String, dynamic> json) => Lecon(
        titre: json['titre'],
        emoji: json['emoji'],
        duree: json['duree'],
        resume: json['resume'],
        regles: (json['regles'] as List)
            .map((r) => RegleLecon.fromJson(r))
            .toList(),
        conseil: json['conseil'],
      );
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