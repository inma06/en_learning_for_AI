import 'word.dart';

class LearningReport {
  final String wordListId;
  final DateTime generatedAt;
  final List<Word> mostIncorrectWords;
  final List<Word> recentlyPracticedWords;
  final Map<String, int> incorrectCountByWord;
  final double averageAccuracy;
  final int totalWords;
  final int masteredWords;
  final List<String> recommendedWords;

  LearningReport({
    required this.wordListId,
    required this.generatedAt,
    required this.mostIncorrectWords,
    required this.recentlyPracticedWords,
    required this.incorrectCountByWord,
    required this.averageAccuracy,
    required this.totalWords,
    required this.masteredWords,
    required this.recommendedWords,
  });

  String get completionRate =>
      '${((masteredWords / totalWords) * 100).toStringAsFixed(1)}%';

  List<Word> get wordsNeedingReview {
    return mostIncorrectWords
        .where((word) => word.wrongCount > 0)
        .take(10)
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'wordListId': wordListId,
      'generatedAt': generatedAt.toIso8601String(),
      'mostIncorrectWords': mostIncorrectWords.map((w) => w.toJson()).toList(),
      'recentlyPracticedWords':
          recentlyPracticedWords.map((w) => w.toJson()).toList(),
      'incorrectCountByWord': incorrectCountByWord,
      'averageAccuracy': averageAccuracy,
      'totalWords': totalWords,
      'masteredWords': masteredWords,
      'recommendedWords': recommendedWords,
    };
  }

  factory LearningReport.fromJson(Map<String, dynamic> json) {
    return LearningReport(
      wordListId: json['wordListId'] as String,
      generatedAt: DateTime.parse(json['generatedAt'] as String),
      mostIncorrectWords: (json['mostIncorrectWords'] as List)
          .map((w) => Word.fromJson(w as Map<String, dynamic>))
          .toList(),
      recentlyPracticedWords: (json['recentlyPracticedWords'] as List)
          .map((w) => Word.fromJson(w as Map<String, dynamic>))
          .toList(),
      incorrectCountByWord:
          Map<String, int>.from(json['incorrectCountByWord'] as Map),
      averageAccuracy: json['averageAccuracy'] as double,
      totalWords: json['totalWords'] as int,
      masteredWords: json['masteredWords'] as int,
      recommendedWords: (json['recommendedWords'] as List).cast<String>(),
    );
  }
}
