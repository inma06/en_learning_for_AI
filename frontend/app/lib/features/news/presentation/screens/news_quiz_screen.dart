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
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (currentQuestion.paragraph != null &&
                            currentQuestion.paragraph!.isNotEmpty) ...[
                          Text(
                            currentQuestion.paragraph!,
                            style: TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 20),
                          Divider(),
                          const SizedBox(height: 20),
                        ],
                        Text(
                          currentQuestion.question,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
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
        error: (error, stack) {
          // 에러 로깅 (개발 중 확인용)
          print("Error loading questions: $error");
          print(stack);
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '데이터를 불러오는데 실패했습니다.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '네트워크 연결을 확인하거나 잠시 후 다시 시도해주세요.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('다시 시도'),
                    onPressed: () {
                      ref.invalidate(
                          questionsProvider); // provider를 invalidate하여 재시도
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
