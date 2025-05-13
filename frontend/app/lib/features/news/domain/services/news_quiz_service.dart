import 'package:dio/dio.dart';
import 'package:language_learning_app/features/news/domain/models/question.dart';

class NewsQuizService {
  final Dio _dio;
  final String baseUrl;

  NewsQuizService({required this.baseUrl}) : _dio = Dio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);
    // 캐시 비활성화
    _dio.options.headers['Cache-Control'] = 'no-cache';
    _dio.options.headers['Pragma'] = 'no-cache';
  }

  Future<List<Question>> getQuestions({
    String? difficulty,
    String? category,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (difficulty != null) queryParameters['difficulty'] = difficulty;
      if (category != null) queryParameters['category'] = category;

      final response = await _dio.get(
        '/openai/questions',
        queryParameters: queryParameters,
        options: Options(
          headers: {
            'Cache-Control': 'no-cache',
            'Pragma': 'no-cache',
          },
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data as Map<String, dynamic>;
        final List<dynamic> questionsData = data['questions'] as List<dynamic>;
        return questionsData.map((json) {
          try {
            return Question.fromJson(json);
          } catch (e) {
            print('Error parsing question: $e');
            print('Question data: $json');
            rethrow;
          }
        }).toList();
      } else {
        throw Exception('Failed to load questions: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading questions: $e');
      rethrow;
    }
  }
}
