class Question {
  final String headline;
  final String question;
  final List<String> choices;
  final String answer;
  final String difficulty;
  final String category;
  final DateTime date;
  final String? id;
  String? userResponse;
  bool? isCorrect;

  Question({
    required this.headline,
    required this.question,
    required this.choices,
    required this.answer,
    required this.difficulty,
    required this.category,
    required this.date,
    this.id,
    this.userResponse,
    this.isCorrect,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['_id'] as String?,
      headline: json['headline'] as String,
      question: json['question'] as String,
      choices: List<String>.from(json['choices'] as List),
      answer: json['answer'] as String,
      difficulty: json['difficulty'] as String,
      category: json['category'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'headline': headline,
      'question': question,
      'choices': choices,
      'answer': answer,
      'difficulty': difficulty,
      'category': category,
      'date': date.toIso8601String(),
    };
  }

  Question copyWith({
    String? headline,
    String? question,
    List<String>? choices,
    String? answer,
    String? difficulty,
    String? category,
    DateTime? date,
    String? id,
    String? userResponse,
    bool? isCorrect,
  }) {
    return Question(
      headline: headline ?? this.headline,
      question: question ?? this.question,
      choices: choices ?? this.choices,
      answer: answer ?? this.answer,
      difficulty: difficulty ?? this.difficulty,
      category: category ?? this.category,
      date: date ?? this.date,
      id: id ?? this.id,
      userResponse: userResponse ?? this.userResponse,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }
}
