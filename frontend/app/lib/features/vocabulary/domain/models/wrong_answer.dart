class WrongAnswer {
  final String wordId;
  final String english;
  final String korean;
  final DateTime wrongDate;
  final int wrongCount;
  final String? userAnswer;

  WrongAnswer({
    required this.wordId,
    required this.english,
    required this.korean,
    required this.wrongDate,
    required this.wrongCount,
    this.userAnswer,
  });

  Map<String, dynamic> toJson() {
    return {
      'wordId': wordId,
      'english': english,
      'korean': korean,
      'wrongDate': wrongDate.toIso8601String(),
      'wrongCount': wrongCount,
      'userAnswer': userAnswer,
    };
  }

  factory WrongAnswer.fromJson(Map<String, dynamic> json) {
    return WrongAnswer(
      wordId: json['wordId'] as String,
      english: json['english'] as String,
      korean: json['korean'] as String,
      wrongDate: DateTime.parse(json['wrongDate'] as String),
      wrongCount: json['wrongCount'] as int,
      userAnswer: json['userAnswer'] as String?,
    );
  }
}
