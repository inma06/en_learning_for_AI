import 'package:flutter/material.dart';
import '../models/question.dart';

class QuizCard extends StatefulWidget {
  final Question question;
  final Function(Question, String) onSubmitAnswer;

  const QuizCard({
    Key? key,
    required this.question,
    required this.onSubmitAnswer,
  }) : super(key: key);

  @override
  _QuizCardState createState() => _QuizCardState();
}

class _QuizCardState extends State<QuizCard> {
  String? _selectedAnswer;
  bool _showResult = false;

  void _handleAnswerSelection(String answer) {
    setState(() {
      _selectedAnswer = answer;
      _showResult = true;
    });
    widget.onSubmitAnswer(widget.question, answer);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.question.headline,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.question.question,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16.0),
            ...widget.question.choices.map((choice) {
              final isSelected = _selectedAnswer == choice;
              final isCorrect = _showResult && choice == widget.question.answer;
              final isWrong = _showResult && isSelected && !isCorrect;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ElevatedButton(
                  onPressed:
                      _showResult ? null : () => _handleAnswerSelection(choice),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _showResult
                        ? isCorrect
                            ? Colors.green
                            : isWrong
                                ? Colors.red
                                : null
                        : null,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: Text(choice),
                ),
              );
            }),
            if (_showResult) ...[
              const SizedBox(height: 16.0),
              Text(
                _selectedAnswer == widget.question.answer
                    ? '정답입니다!'
                    : '틀렸습니다. 정답은: ${widget.question.answer}',
                style: TextStyle(
                  color: _selectedAnswer == widget.question.answer
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
