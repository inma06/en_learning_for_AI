import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:language_learning_app/models/question.dart';
import 'package:language_learning_app/widgets/quiz_card.dart';

void main() {
  late Question testQuestion;
  late Function(Question, String) mockOnSubmitAnswer;

  setUp(() {
    testQuestion = Question(
      headline: 'Test Headline',
      question: 'Test Question',
      choices: ['A', 'B', 'C', 'D'],
      answer: 'A',
      difficulty: 'easy',
      category: 'vocabulary',
      date: DateTime.now(),
    );
    mockOnSubmitAnswer = (question, answer) {};
  });

  testWidgets('QuizCard displays question and choices',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: QuizCard(
            question: testQuestion,
            onSubmitAnswer: mockOnSubmitAnswer,
          ),
        ),
      ),
    );

    expect(find.text('Test Headline'), findsOneWidget);
    expect(find.text('Test Question'), findsOneWidget);
    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
    expect(find.text('C'), findsOneWidget);
    expect(find.text('D'), findsOneWidget);
  });

  testWidgets('QuizCard shows result after answer selection',
      (WidgetTester tester) async {
    bool answerSubmitted = false;
    mockOnSubmitAnswer = (question, answer) {
      answerSubmitted = true;
    };

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: QuizCard(
            question: testQuestion,
            onSubmitAnswer: mockOnSubmitAnswer,
          ),
        ),
      ),
    );

    await tester.tap(find.text('B'));
    await tester.pump();

    expect(answerSubmitted, true);
    expect(find.text('틀렸습니다. 정답은: A'), findsOneWidget);
  });

  testWidgets('QuizCard shows correct result for correct answer',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: QuizCard(
            question: testQuestion,
            onSubmitAnswer: mockOnSubmitAnswer,
          ),
        ),
      ),
    );

    await tester.tap(find.text('A'));
    await tester.pump();

    expect(find.text('정답입니다!'), findsOneWidget);
  });

  testWidgets('QuizCard disables choices after answer selection',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: QuizCard(
            question: testQuestion,
            onSubmitAnswer: mockOnSubmitAnswer,
          ),
        ),
      ),
    );

    await tester.tap(find.text('A'));
    await tester.pump();

    final buttonFinder = find.byType(ElevatedButton);
    final buttons = tester.widgetList<ElevatedButton>(buttonFinder);
    for (final button in buttons) {
      expect(button.onPressed, null);
    }
  });
}
