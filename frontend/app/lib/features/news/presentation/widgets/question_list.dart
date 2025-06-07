import 'package:flutter/material.dart';
import '../../domain/entities/question_entity.dart';
import 'question_card.dart';

class QuestionList extends StatelessWidget {
  final List<QuestionItem> questionItems;
  final int currentQuestionIndex;
  final bool isSubmitted;

  const QuestionList({
    super.key,
    required this.questionItems,
    this.currentQuestionIndex = 0,
    this.isSubmitted = false,
  });

  @override
  Widget build(BuildContext context) {
    if (questionItems.isEmpty || currentQuestionIndex >= questionItems.length) {
      return const Center(
        child: Text('문제가 없습니다.'),
      );
    }

    final currentQuestionItem = questionItems[currentQuestionIndex];

    return Column(
      children: [
        // 진행률 표시
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '문제 ${currentQuestionIndex + 1} / ${questionItems.length}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '${((currentQuestionIndex + 1) / questionItems.length * 100).toInt()}%',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: (currentQuestionIndex + 1) / questionItems.length,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ),
        // 현재 문제 표시
        Expanded(
          child: SingleChildScrollView(
            child: QuestionItemCard(
              questionItem: currentQuestionItem,
              isSubmitted: isSubmitted,
            ),
          ),
        ),
      ],
    );
  }
}
