import 'package:language_learning_app/features/news/domain/models/question.dart';

class PaginatedQuestionsResponse {
  final List<Question> questions;
  final int currentPage;
  final int totalPages;
  final int totalQuestions;

  PaginatedQuestionsResponse({
    required this.questions,
    required this.currentPage,
    required this.totalPages,
    required this.totalQuestions,
  });

  factory PaginatedQuestionsResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedQuestionsResponse(
      questions:
          (json['questions'] as List).map((q) => Question.fromJson(q)).toList(),
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
      totalQuestions: json['totalQuestions'],
    );
  }
}
