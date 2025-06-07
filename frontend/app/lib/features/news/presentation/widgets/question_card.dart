import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/question_entity.dart';
import '../bloc/news_bloc.dart';

class QuestionCard extends StatelessWidget {
  final Question question;
  final bool isSubmitted;

  const QuestionCard({
    super.key,
    required this.question,
    this.isSubmitted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            Text(
              question.headline,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              question.paragraph,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            if (question.mainIdeaQuestion != null)
              _buildMainIdeaQuestion(context, question.mainIdeaQuestion!),
            if (question.fillInTheBlankQuestion != null)
              _buildFillInTheBlankQuestion(
                  context, question.fillInTheBlankQuestion!),
            if (isSubmitted)
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green[700]),
                    const SizedBox(width: 8),
                    Text(
                      '답안이 제출되었습니다. 다음 문제로 이동합니다...',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final formattedDate = dateFormat.format(question.createdAt);
    final source = question.source ?? 'Unknown';

    // 난이도 가져오기 (main_idea_question 또는 fill_in_the_blank_question에서)
    String? difficulty;
    if (question.mainIdeaQuestion?.difficulty != null) {
      difficulty = question.mainIdeaQuestion!.difficulty;
    } else if (question.fillInTheBlankQuestion?.difficulty != null) {
      difficulty = question.fillInTheBlankQuestion!.difficulty;
    }

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$formattedDate $source',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          ),
          if (difficulty != null)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: _getDifficultyColor(difficulty),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                difficulty.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildMainIdeaQuestion(
      BuildContext context, MainIdeaQuestion mainIdea) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          mainIdea.question,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ...mainIdea.choices.map(
          (choice) => ListTile(
            title: Text(choice),
            leading: Radio<String>(
              value: choice,
              groupValue: question.userResponse,
              onChanged: isSubmitted
                  ? null
                  : (value) {
                      if (value != null) {
                        print(
                            'Submitting answer for question ID: ${question.id}');
                        context.read<NewsBloc>().add(
                              SubmitAnswerEvent(
                                questionId: question.id,
                                answer: value,
                              ),
                            );
                      }
                    },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFillInTheBlankQuestion(
      BuildContext context, FillInTheBlankQuestion fillInBlank) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fillInBlank.questionPrompt,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          fillInBlank.questionTextWithBlank,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        ...fillInBlank.choices.map(
          (choice) => ListTile(
            title: Text(choice),
            leading: Radio<String>(
              value: choice,
              groupValue: question.userResponse,
              onChanged: isSubmitted
                  ? null
                  : (value) {
                      if (value != null) {
                        print(
                            'Submitting answer for question ID: ${question.id}');
                        context.read<NewsBloc>().add(
                              SubmitAnswerEvent(
                                questionId: question.id,
                                answer: value,
                              ),
                            );
                      }
                    },
            ),
          ),
        ),
      ],
    );
  }
}

// 새로운 QuestionItemCard 클래스
class QuestionItemCard extends StatelessWidget {
  final QuestionItem questionItem;
  final bool isSubmitted;

  const QuestionItemCard({
    super.key,
    required this.questionItem,
    this.isSubmitted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            Text(
              questionItem.headline,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            // 빈칸채우기 문제일 때는 본문을 숨김 (답이 드러나지 않도록)
            if (questionItem.type != QuestionType.fillInBlank) ...[
              const SizedBox(height: 8),
              Text(
                questionItem.paragraph,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            const SizedBox(height: 16),
            _buildQuestion(context),
            if (isSubmitted)
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green[700]),
                    const SizedBox(width: 8),
                    Text(
                      '답안이 제출되었습니다. 다음 문제로 이동합니다...',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final formattedDate = dateFormat.format(questionItem.createdAt);
    final source = questionItem.source ?? 'Unknown';
    final questionTypeText =
        questionItem.type == QuestionType.mainIdea ? '객관식' : '빈칸 채우기';

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$formattedDate $source',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
              ),
              Text(
                questionTypeText,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
              ),
            ],
          ),
          if (questionItem.difficulty != null)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: _getDifficultyColor(questionItem.difficulty!),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                questionItem.difficulty!.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildQuestion(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (questionItem.questionPrompt != null)
          Text(
            questionItem.questionPrompt!,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        if (questionItem.questionPrompt != null) const SizedBox(height: 8),
        // 빈칸 문제의 경우 [BLANK] 하이라이트
        if (questionItem.type == QuestionType.fillInBlank)
          _buildHighlightedText(context, questionItem.questionText)
        else
          Text(
            questionItem.questionText,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        const SizedBox(height: 8),
        ...questionItem.choices.asMap().entries.map(
          (entry) {
            final choice = entry.value;
            return ListTile(
              title: Text(choice),
              leading: Radio<String>(
                value: choice,
                groupValue: questionItem.userResponse,
                onChanged: isSubmitted
                    ? null
                    : (value) {
                        if (value != null) {
                          _showAnswerDialog(context, value);
                        }
                      },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHighlightedText(BuildContext context, String text) {
    final parts = text.split('[BLANK]');
    if (parts.length == 1) {
      return Text(
        text,
        style: Theme.of(context).textTheme.titleMedium,
      );
    }

    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.titleMedium,
        children: [
          TextSpan(text: parts[0]),
          TextSpan(
            text: '____',
            style: TextStyle(
              backgroundColor: Colors.yellow[200],
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          if (parts.length > 1) TextSpan(text: parts[1]),
        ],
      ),
    );
  }

  void _showAnswerDialog(BuildContext context, String selectedAnswer) {
    final isCorrect = questionItem.correctAnswer == selectedAnswer;
    print(
        'Showing answer dialog - Question ID: ${questionItem.id}, Selected: $selectedAnswer, Correct: ${questionItem.correctAnswer}, Is Correct: $isCorrect');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect ? Colors.green : Colors.red,
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(
                isCorrect ? '정답!' : '오답!',
                style: TextStyle(
                  color: isCorrect ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('선택한 답: $selectedAnswer'),
              const SizedBox(height: 8),
              if (!isCorrect) ...[
                Text('정답: ${questionItem.correctAnswer}'),
                const SizedBox(height: 8),
              ],
              Text(
                isCorrect ? '축하합니다!' : '다음에 더 잘할 수 있을 거예요!',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                print('Next question button pressed');
                // 다이얼로그 닫기
                Navigator.of(dialogContext).pop();

                // 메인 컨텍스트로 답안 제출
                try {
                  print('Submitting answer for question: ${questionItem.id}');
                  context.read<NewsBloc>().add(
                        SubmitAnswerEvent(
                          questionId: questionItem.id,
                          answer: selectedAnswer,
                        ),
                      );

                  // 약간의 딜레이 후 다음 문제로 이동
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (context.mounted) {
                      print('Moving to next question');
                      context.read<NewsBloc>().add(NextQuestionEvent());
                    } else {
                      print(
                          'Context not mounted, cannot move to next question');
                    }
                  });
                } catch (e) {
                  print('Error submitting answer: $e');
                }
              },
              child: const Text('다음 문제'),
            ),
          ],
        );
      },
    );
  }
}
