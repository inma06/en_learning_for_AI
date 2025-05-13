import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/question.dart';

class ApiService {
  final String baseUrl;
  final http.Client _client;

  ApiService({
    String? baseUrl,
    http.Client? client,
  })  : baseUrl = baseUrl ?? 'http://localhost:3001/api',
        _client = client ?? http.Client();

  Future<QuestionResult> getQuestions({
    int page = 1,
    int limit = 10,
    String? difficulty,
    String? category,
  }) async {
    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
      if (difficulty != null) 'difficulty': difficulty,
      if (category != null) 'category': category,
    };

    final uri = Uri.parse('$baseUrl/openai/questions')
        .replace(queryParameters: queryParams);
    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return QuestionResult.fromJson(data);
    } else {
      throw Exception('Failed to load questions: ${response.body}');
    }
  }

  Future<void> submitAnswer({
    required String questionId,
    required String answer,
    required bool isCorrect,
  }) async {
    final uri = Uri.parse('$baseUrl/openai/questions/$questionId/answer');
    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'answer': answer,
        'isCorrect': isCorrect,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to submit answer: ${response.body}');
    }
  }

  void dispose() {
    _client.close();
  }
}

class QuestionResult {
  final List<Question> questions;
  final int totalPages;
  final int currentPage;

  QuestionResult({
    required this.questions,
    required this.totalPages,
    required this.currentPage,
  });

  factory QuestionResult.fromJson(Map<String, dynamic> json) {
    return QuestionResult(
      questions:
          (json['questions'] as List).map((q) => Question.fromJson(q)).toList(),
      totalPages: json['totalPages'],
      currentPage: json['currentPage'],
    );
  }
}
