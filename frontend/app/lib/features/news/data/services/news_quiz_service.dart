import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:language_learning_app/features/news/domain/models/paginated_questions_response.dart';

class NewsQuizService {
  final String baseUrl;

  NewsQuizService({required this.baseUrl});

  Future<PaginatedQuestionsResponse> getQuestions({
    required int page,
    required int limit,
    List<String>? excludeIds,
  }) async {
    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (excludeIds != null && excludeIds.isNotEmpty) {
      queryParams['excludeIds'] = excludeIds.join(',');
    }

    final uri = Uri.parse('$baseUrl/api/openai/questions').replace(
      queryParameters: queryParams,
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return PaginatedQuestionsResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load questions');
    }
  }
}
