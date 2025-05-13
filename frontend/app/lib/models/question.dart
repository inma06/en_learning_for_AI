class Question {
  final String headline;
  final String question;
  final List<String> choices;
  final String answer;
  final String difficulty;
  final String category;
  final DateTime date;
  final String? userResponse;
  final bool? isCorrect;

  Question({
    required this.headline,
    required this.question,
    required this.choices,
    required this.answer,
    required this.difficulty,
    required this.category,
    required this.date,
    this.userResponse,
    this.isCorrect,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      headline: json['headline'],
      question: json['question'],
      choices: List<String>.from(json['choices']),
      answer: json['answer'],
      difficulty: json['difficulty'],
      category: json['category'],
      date: DateTime.parse(json['date']),
      userResponse: json['userResponse'],
      isCorrect: json['isCorrect'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'headline': headline,
      'question': question,
      'choices': choices,
      'answer': answer,
      'difficulty': difficulty,
      'category': category,
      'date': date.toIso8601String(),
      'userResponse': userResponse,
      'isCorrect': isCorrect,
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
      userResponse: userResponse ?? this.userResponse,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }
}
