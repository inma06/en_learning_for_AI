import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:language_learning_app/features/news/presentation/providers/news_quiz_provider.dart';

class NewsQuizScreen extends ConsumerWidget {
  const NewsQuizScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionsAsync = ref.watch(questionsProvider);
    final currentQuestion = ref.watch(currentQuestionProvider);
    final userResponses = ref.watch(userResponsesProvider);
    final isQuizCompleted = ref.watch(isQuizCompletedProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('뉴스 퀴즈'),
      ),
      body: questionsAsync.when(
        data: (questions) {
          if (isQuizCompleted) {
            return const Center(
              child: Text(
                '오늘의 문제 풀이 완료!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            );
          }

          if (currentQuestion == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final userResponse = userResponses[currentQuestion.hashCode];
          final isAnswered = userResponse != null;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentQuestion.headline,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          currentQuestion.question,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ...currentQuestion.choices.map((choice) {
                  final isSelected = userResponse == choice;
                  final isCorrect =
                      isAnswered && choice == currentQuestion.answer;
                  final isWrong = isAnswered &&
                      isSelected &&
                      choice != currentQuestion.answer;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ElevatedButton(
                      onPressed: isAnswered
                          ? null
                          : () {
                              ref.read(userResponsesProvider.notifier).state = {
                                ...userResponses,
                                currentQuestion.hashCode: choice,
                              };
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isAnswered
                            ? isCorrect
                                ? Colors.green.shade100
                                : isWrong
                                    ? Colors.red.shade100
                                    : null
                            : null,
                        padding: const EdgeInsets.all(16),
                      ),
                      child: Text(choice),
                    ),
                  );
                }).toList(),
                if (isAnswered) ...[
                  const SizedBox(height: 16),
                  Text(
                    userResponse == currentQuestion.answer
                        ? '정답입니다!'
                        : '틀렸습니다.',
                    style: TextStyle(
                      color: userResponse == currentQuestion.answer
                          ? Colors.green
                          : Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(currentQuestionIndexProvider.notifier).state++;
                    },
                    child: const Text('다음 문제'),
                  ),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('에러가 발생했습니다: $error'),
        ),
      ),
    );
  }
}
