import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:language_learning_app/features/news/domain/models/question.dart';
import 'package:language_learning_app/features/news/domain/services/news_quiz_service.dart';

final newsQuizServiceProvider = Provider<NewsQuizService>((ref) {
  return NewsQuizService(baseUrl: 'http://localhost:3001/api');
});

final questionsProvider = FutureProvider<List<Question>>((ref) async {
  final service = ref.watch(newsQuizServiceProvider);
  return service.getQuestions();
});

final currentQuestionIndexProvider = StateProvider<int>((ref) => 0);

final currentQuestionProvider = Provider<Question?>((ref) {
  final questions = ref.watch(questionsProvider).value;
  final currentIndex = ref.watch(currentQuestionIndexProvider);

  if (questions == null || questions.isEmpty) return null;
  if (currentIndex >= questions.length) return null;

  return questions[currentIndex];
});

final userResponsesProvider = StateProvider<Map<int, String>>((ref) => {});

final isQuizCompletedProvider = Provider<bool>((ref) {
  final questions = ref.watch(questionsProvider).value;
  final currentIndex = ref.watch(currentQuestionIndexProvider);

  if (questions == null) return false;
  return currentIndex >= questions.length;
});
