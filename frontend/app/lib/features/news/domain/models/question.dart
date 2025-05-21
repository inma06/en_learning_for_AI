class MainIdeaQuestionModel {
  final String question;
  final List<String> choices;
  final String answer;
  final String? difficulty;

  MainIdeaQuestionModel({
    required this.question,
    required this.choices,
    required this.answer,
    this.difficulty,
  });

  factory MainIdeaQuestionModel.fromJson(Map<String, dynamic> json) {
    return MainIdeaQuestionModel(
      question: json['question'] as String,
      choices: List<String>.from(json['choices'] as List<dynamic>),
      answer: json['answer'] as String,
      difficulty: json['difficulty'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'choices': choices,
      'answer': answer,
      'difficulty': difficulty,
    };
  }

  MainIdeaQuestionModel copyWith({
    String? question,
    List<String>? choices,
    String? answer,
    String? difficulty,
  }) {
    return MainIdeaQuestionModel(
      question: question ?? this.question,
      choices: choices ?? this.choices,
      answer: answer ?? this.answer,
      difficulty: difficulty ?? this.difficulty,
    );
  }
}

class FillInTheBlankQuestionModel {
  final String questionTextWithBlank;
  final String questionPrompt;
  final List<String> choices;
  final String answer;
  final String? difficulty;

  FillInTheBlankQuestionModel({
    required this.questionTextWithBlank,
    required this.questionPrompt,
    required this.choices,
    required this.answer,
    this.difficulty,
  });

  factory FillInTheBlankQuestionModel.fromJson(Map<String, dynamic> json) {
    return FillInTheBlankQuestionModel(
      questionTextWithBlank: json['question_text_with_blank'] as String,
      questionPrompt: json['question_prompt'] as String,
      choices: List<String>.from(json['choices'] as List<dynamic>),
      answer: json['answer'] as String,
      difficulty: json['difficulty'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question_text_with_blank': questionTextWithBlank,
      'question_prompt': questionPrompt,
      'choices': choices,
      'answer': answer,
      'difficulty': difficulty,
    };
  }

  FillInTheBlankQuestionModel copyWith({
    String? questionTextWithBlank,
    String? questionPrompt,
    List<String>? choices,
    String? answer,
    String? difficulty,
  }) {
    return FillInTheBlankQuestionModel(
      questionTextWithBlank:
          questionTextWithBlank ?? this.questionTextWithBlank,
      questionPrompt: questionPrompt ?? this.questionPrompt,
      choices: choices ?? this.choices,
      answer: answer ?? this.answer,
      difficulty: difficulty ?? this.difficulty,
    );
  }
}

class Question {
  final String id;
  final String headline;
  final String paragraph;
  final String? source;
  final MainIdeaQuestionModel? mainIdeaQuestion;
  final FillInTheBlankQuestionModel? fillInTheBlankQuestion;
  final DateTime createdAt;
  String? userResponse;
  bool? isCorrect;

  Question({
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

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['_id'] ?? '',
      headline: json['headline'],
      paragraph: json['paragraph'],
      source: json['source'],
      mainIdeaQuestion: json['main_idea_question'] != null
          ? MainIdeaQuestionModel.fromJson(
              json['main_idea_question'] as Map<String, dynamic>)
          : null,
      fillInTheBlankQuestion: json['fill_in_the_blank_question'] != null
          ? FillInTheBlankQuestionModel.fromJson(
              json['fill_in_the_blank_question'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'headline': headline,
      'paragraph': paragraph,
      'source': source,
      'main_idea_question': mainIdeaQuestion?.toJson(),
      'fill_in_the_blank_question': fillInTheBlankQuestion?.toJson(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Question copyWith({
    String? id,
    String? headline,
    String? paragraph,
    String? source,
    MainIdeaQuestionModel? mainIdeaQuestion,
    FillInTheBlankQuestionModel? fillInTheBlankQuestion,
    DateTime? createdAt,
    String? userResponse,
    bool? isCorrect,
    bool allowNullMainIdea = false,
    bool allowNullFillInBlank = false,
  }) {
    return Question(
      id: id ?? this.id,
      headline: headline ?? this.headline,
      paragraph: paragraph ?? this.paragraph,
      source: source ?? this.source,
      mainIdeaQuestion: allowNullMainIdea && mainIdeaQuestion == null
          ? null
          : (mainIdeaQuestion ?? this.mainIdeaQuestion),
      fillInTheBlankQuestion:
          allowNullFillInBlank && fillInTheBlankQuestion == null
              ? null
              : (fillInTheBlankQuestion ?? this.fillInTheBlankQuestion),
      createdAt: createdAt ?? this.createdAt,
      userResponse: userResponse ?? this.userResponse,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }
}
