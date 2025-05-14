class Word {
  final String id;
  final String english;
  final String korean;
  final String? example;
  final DateTime lastPracticed;
  bool isMastered;
  int wrongCount;
  double accuracy;

  Word({
    required this.id,
    required this.english,
    required this.korean,
    this.example,
    required this.lastPracticed,
    this.isMastered = false,
    this.wrongCount = 0,
    this.accuracy = 0.0,
  });

  Word copyWith({
    String? id,
    String? english,
    String? korean,
    String? example,
    DateTime? lastPracticed,
    bool? isMastered,
    int? wrongCount,
    double? accuracy,
  }) {
    return Word(
      id: id ?? this.id,
      english: english ?? this.english,
      korean: korean ?? this.korean,
      example: example ?? this.example,
      lastPracticed: lastPracticed ?? this.lastPracticed,
      isMastered: isMastered ?? this.isMastered,
      wrongCount: wrongCount ?? this.wrongCount,
      accuracy: accuracy ?? this.accuracy,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'english': english,
      'korean': korean,
      'example': example,
      'lastPracticed': lastPracticed.toIso8601String(),
      'isMastered': isMastered,
      'wrongCount': wrongCount,
      'accuracy': accuracy,
    };
  }

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['id'] as String,
      english: json['english'] as String,
      korean: json['korean'] as String,
      example: json['example'] as String?,
      lastPracticed: DateTime.parse(json['lastPracticed'] as String),
      isMastered: json['isMastered'] as bool,
      wrongCount: json['wrongCount'] as int,
      accuracy: json['accuracy'] as double,
    );
  }

  String _getHint(String word) {
    if (word.length <= 2) return '${word[0]}*';
    return word.substring(0, 2) + '*' * (word.length - 2);
  }
}
