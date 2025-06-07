import 'package:equatable/equatable.dart';

class Question extends Equatable {
  final String id;
  final String headline;
  final String paragraph;
  final String? source;
  final MainIdeaQuestion? mainIdeaQuestion;
  final FillInTheBlankQuestion? fillInTheBlankQuestion;
  final DateTime createdAt;
  final String? userResponse;
  final bool? isCorrect;

  const Question({
    required this.id,
    required this.headline,
    required this.paragraph,
    this.source,
    this.mainIdeaQuestion,
    this.fillInTheBlankQuestion,
    required this.createdAt,
    this.userResponse,
    this.isCorrect,
  });

  Question copyWith({
    String? id,
    String? headline,
    String? paragraph,
    String? source,
    MainIdeaQuestion? mainIdeaQuestion,
    FillInTheBlankQuestion? fillInTheBlankQuestion,
    DateTime? createdAt,
    String? userResponse,
    bool? isCorrect,
  }) {
    return Question(
      id: id ?? this.id,
      headline: headline ?? this.headline,
      paragraph: paragraph ?? this.paragraph,
      source: source ?? this.source,
      mainIdeaQuestion: mainIdeaQuestion ?? this.mainIdeaQuestion,
      fillInTheBlankQuestion:
          fillInTheBlankQuestion ?? this.fillInTheBlankQuestion,
      createdAt: createdAt ?? this.createdAt,
      userResponse: userResponse ?? this.userResponse,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }

  @override
  List<Object?> get props => [
        id,
        headline,
        paragraph,
        source,
        mainIdeaQuestion,
        fillInTheBlankQuestion,
        createdAt,
        userResponse,
        isCorrect,
      ];
}

class MainIdeaQuestion extends Equatable {
  final String question;
  final List<String> choices;
  final String answer;
  final String? difficulty;

  const MainIdeaQuestion({
    required this.question,
    required this.choices,
    required this.answer,
    this.difficulty,
  });

  @override
  List<Object?> get props => [question, choices, answer, difficulty];
}

class FillInTheBlankQuestion extends Equatable {
  final String questionTextWithBlank;
  final String questionPrompt;
  final List<String> choices;
  final String answer;
  final String? difficulty;

  const FillInTheBlankQuestion({
    required this.questionTextWithBlank,
    required this.questionPrompt,
    required this.choices,
    required this.answer,
    this.difficulty,
  });

  @override
  List<Object?> get props => [
        questionTextWithBlank,
        questionPrompt,
        choices,
        answer,
        difficulty,
      ];
}

enum QuestionType {
  mainIdea,
  fillInBlank,
}

class QuestionItem {
  final String id;
  final String headline;
  final String paragraph;
  final String? source;
  final DateTime createdAt;
  final QuestionType type;
  final String questionText;
  final List<String> choices;
  final String correctAnswer;
  final String? difficulty;
  final String? questionPrompt; // fill-in-blank용
  final String? userResponse;
  final bool? isCorrect;

  QuestionItem({
    required this.id,
    required this.headline,
    required this.paragraph,
    this.source,
    required this.createdAt,
    required this.type,
    required this.questionText,
    required this.choices,
    required this.correctAnswer,
    this.difficulty,
    this.questionPrompt,
    this.userResponse,
    this.isCorrect,
  });

  QuestionItem copyWith({
    String? userResponse,
    bool? isCorrect,
  }) {
    return QuestionItem(
      id: id,
      headline: headline,
      paragraph: paragraph,
      source: source,
      createdAt: createdAt,
      type: type,
      questionText: questionText,
      choices: choices,
      correctAnswer: correctAnswer,
      difficulty: difficulty,
      questionPrompt: questionPrompt,
      userResponse: userResponse ?? this.userResponse,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }
}

// Helper function to convert Question to List<QuestionItem>
List<QuestionItem> questionToItems(Question question) {
  List<QuestionItem> items = [];

  if (question.mainIdeaQuestion != null) {
    items.add(QuestionItem(
      id: '${question.id}_main',
      headline: question.headline,
      paragraph: question.paragraph,
      source: question.source,
      createdAt: question.createdAt,
      type: QuestionType.mainIdea,
      questionText: question.mainIdeaQuestion!.question,
      choices: question.mainIdeaQuestion!.choices,
      correctAnswer: question.mainIdeaQuestion!.answer,
      difficulty: question.mainIdeaQuestion!.difficulty,
    ));
  }

  if (question.fillInTheBlankQuestion != null) {
    items.add(QuestionItem(
      id: '${question.id}_fill',
      headline: question.headline,
      paragraph: question.paragraph,
      source: question.source,
      createdAt: question.createdAt,
      type: QuestionType.fillInBlank,
      questionText: question.fillInTheBlankQuestion!.questionTextWithBlank,
      choices: question.fillInTheBlankQuestion!.choices,
      correctAnswer: question.fillInTheBlankQuestion!.answer,
      difficulty: question.fillInTheBlankQuestion!.difficulty,
      questionPrompt: question.fillInTheBlankQuestion!.questionPrompt,
    ));
  }

  return items;
}
