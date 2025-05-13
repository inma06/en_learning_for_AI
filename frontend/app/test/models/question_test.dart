import 'package:flutter_test/flutter_test.dart';
import 'package:language_learning_app/models/question.dart';

void main() {
  group('Question Model Tests', () {
    test('fromJson creates Question instance correctly', () {
      final json = {
        'headline': 'Test Headline',
        'question': 'Test Question',
        'choices': ['A', 'B', 'C', 'D'],
        'answer': 'A',
        'difficulty': 'easy',
        'category': 'vocabulary',
        'date': '2024-03-20',
      };

      final question = Question.fromJson(json);

      expect(question.headline, 'Test Headline');
      expect(question.question, 'Test Question');
      expect(question.choices, ['A', 'B', 'C', 'D']);
      expect(question.answer, 'A');
      expect(question.difficulty, 'easy');
      expect(question.category, 'vocabulary');
      expect(question.date, '2024-03-20');
      expect(question.userResponse, null);
      expect(question.isCorrect, null);
    });

    test('toJson converts Question instance correctly', () {
      final question = Question(
        headline: 'Test Headline',
        question: 'Test Question',
        choices: ['A', 'B', 'C', 'D'],
        answer: 'A',
        difficulty: 'easy',
        category: 'vocabulary',
        date: DateTime.parse('2024-03-20'),
      );

      final json = question.toJson();

      expect(json['headline'], 'Test Headline');
      expect(json['question'], 'Test Question');
      expect(json['choices'], ['A', 'B', 'C', 'D']);
      expect(json['answer'], 'A');
      expect(json['difficulty'], 'easy');
      expect(json['category'], 'vocabulary');
      expect(json['date'], '2024-03-20');
    });

    test('copyWith creates new instance with updated fields', () {
      final question = Question(
        headline: 'Test Headline',
        question: 'Test Question',
        choices: ['A', 'B', 'C', 'D'],
        answer: 'A',
        difficulty: 'easy',
        category: 'vocabulary',
        date: DateTime.parse('2025-05-13'),
      );

      final updatedQuestion = question.copyWith(
        userResponse: 'B',
        isCorrect: false,
      );

      expect(updatedQuestion.headline, question.headline);
      expect(updatedQuestion.question, question.question);
      expect(updatedQuestion.choices, question.choices);
      expect(updatedQuestion.answer, question.answer);
      expect(updatedQuestion.difficulty, question.difficulty);
      expect(updatedQuestion.category, question.category);
      expect(updatedQuestion.date, question.date);
      expect(updatedQuestion.userResponse, 'B');
      expect(updatedQuestion.isCorrect, false);
    });
  });
}
