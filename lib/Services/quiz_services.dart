import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/models/quiz_model.dart';

class QuizServices {
  static final String apiUri = dotenv.env['API_URL'] ?? '';

  Future<List<QuizQuestion>> fetchQuizQuestions() async {
    try {
      final response = await http.get(Uri.parse(apiUri));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((e) => QuizQuestion.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error fetching quiz data: $e');
    }
  }
}
