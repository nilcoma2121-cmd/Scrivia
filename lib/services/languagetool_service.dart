import 'dart:convert';
import 'package:http/http.dart' as http;

class LanguageToolService {
  static const _baseUrl = 'https://api.languagetool.org/v2/check';

  Future<List<Map<String, dynamic>>> checkText(String text) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      body: {
        'text': text,
        'language': 'fr',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['matches']);
    }
    return [];
  }
}