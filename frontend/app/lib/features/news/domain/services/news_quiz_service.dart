import 'dart:convert'; // json.decode를 위해 추가
import 'package:dio/dio.dart';
import 'package:language_learning_app/features/news/domain/models/question.dart';
import 'package:language_learning_app/features/news/domain/models/paginated_questions_response.dart'; // 추가

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

  Future<PaginatedQuestionsResponse> getQuestions({
    String? difficulty,
    String? category,
    int page = 1, // 페이지 파라미터 추가
    int limit = 10, // 항목 수 파라미터 추가 (기본값 10개)
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (difficulty != null) queryParameters['difficulty'] = difficulty;
      if (category != null) queryParameters['category'] = category;
      queryParameters['page'] = page;
      queryParameters['limit'] = limit;

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
        final Map<String, dynamic> data;
        if (response.data is String) {
          data = json.decode(response.data as String) as Map<String, dynamic>;
        } else if (response.data is Map) {
          data = response.data as Map<String, dynamic>;
        } else {
          throw Exception(
              'Unexpected response data type: ${response.data.runtimeType} Data: ${response.data}');
        }

        // PaginatedQuestionsResponse.fromJson을 사용하여 파싱
        return PaginatedQuestionsResponse.fromJson(data);
      } else {
        throw Exception('Failed to load questions: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading questions: $e');
      rethrow;
    }
  }
}
