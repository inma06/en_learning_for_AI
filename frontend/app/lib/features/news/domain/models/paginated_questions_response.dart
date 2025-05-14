import 'package:language_learning_app/features/news/domain/models/question.dart';

class PaginatedQuestionsResponse {
  final List<Question> questions;
  final int totalQuestions;
  final int currentPage;
  final int totalPages;

  PaginatedQuestionsResponse({
    required this.questions,
    required this.totalQuestions,
    required this.currentPage,
    required this.totalPages,
  });

  factory PaginatedQuestionsResponse.fromJson(Map<String, dynamic> json) {
    var questionsList = json['questions'] as List;
    List<Question> questions = questionsList
        .map((i) => Question.fromJson(i as Map<String, dynamic>))
        .toList();

    return PaginatedQuestionsResponse(
      questions: questions,
      totalQuestions: json['totalQuestions'] as int,
      currentPage: json['currentPage'] as int,
      totalPages: json['totalPages'] as int,
    );
  }
}
