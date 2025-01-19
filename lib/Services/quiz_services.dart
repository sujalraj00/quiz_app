import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:quiz_app/models/quiz_model.dart';

class QuizService {
  static String get apiUrl => dotenv.env['API_URL'] ?? '';

  Future<List<QuizQuestion>> fetchQuizQuestions(
      {bool bypassSSL = false}) async {
    try {
      // Use Dio for network requests
      Dio dio = Dio();

      if (bypassSSL) {
        (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
            (HttpClient client) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return client;
        };
      }

      final response = await dio.get(apiUrl);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.data}');

      // Ensure the response is JSON
      if (response.headers
              .value('content-type')
              ?.contains('application/json') ??
          false) {
        final Map<String, dynamic> jsonData = response.data;
        final List<dynamic> questions = jsonData['questions'] as List<dynamic>;
        return questions.map((json) => QuizQuestion.fromJson(json)).toList();
      } else {
        throw Exception(
            'Expected JSON response but received something else. Response: ${response.data}');
      }
    } on DioException catch (e) {
      print('DioException: $e');
      throw Exception('Error fetching quiz data: ${e.message}');
    } on SocketException {
      throw Exception('No internet connection');
    } on TimeoutException {
      throw Exception('Request timed out. Please try again.');
    } catch (e) {
      print('Unhandled error: $e');
      throw Exception('Error fetching quiz data: $e');
    }
  }

  Future<List<QuizQuestion>> fetchQuizQuestionsWithHttpClient(
      {bool bypassSSL = false}) async {
    try {
      final client = HttpClient();
      if (bypassSSL) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      }

      final request = await client.getUrl(Uri.parse(apiUrl));
      request.headers.add('Accept', 'application/json');

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      print('Response status: ${response.statusCode}');
      print('Response body: $responseBody');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(responseBody);
        final List<dynamic> questions = jsonData['questions'] as List<dynamic>;
        return questions.map((json) => QuizQuestion.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load quiz data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error fetching quiz data: $e');
    }
  }
}
