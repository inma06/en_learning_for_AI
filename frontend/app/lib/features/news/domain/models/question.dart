class Question {
  final String? id;
  final String headline;
  final String? paragraph;
  final String question;
  final List<String> choices;
  final String answer;
  final String difficulty;
  final String category;
  final DateTime createdAt;
  String? userResponse;
  bool? isCorrect;

  Question({
    this.id,
    required this.headline,
    this.paragraph,
    required this.question,
    required this.choices,
    required this.answer,
    required this.difficulty,
    required this.category,
    required this.createdAt,
    this.userResponse,
    this.isCorrect,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['_id'] as String?,
      headline: json['headline'] as String,
      paragraph: json['paragraph'] as String?,
      question: json['question'] as String,
      choices: List<String>.from(json['choices'] as List),
      answer: json['answer'] as String,
      difficulty: json['difficulty'] as String,
      category: json['category'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'headline': headline,
      'paragraph': paragraph,
      'question': question,
      'choices': choices,
      'answer': answer,
      'difficulty': difficulty,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Question copyWith({
    String? id,
    String? headline,
    String? paragraph,
    String? question,
    List<String>? choices,
    String? answer,
    String? difficulty,
    String? category,
    DateTime? createdAt,
    String? userResponse,
    bool? isCorrect,
  }) {
    return Question(
      id: id ?? this.id,
      headline: headline ?? this.headline,
      paragraph: paragraph ?? this.paragraph,
      question: question ?? this.question,
      choices: choices ?? this.choices,
      answer: answer ?? this.answer,
      difficulty: difficulty ?? this.difficulty,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      userResponse: userResponse ?? this.userResponse,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }
}
