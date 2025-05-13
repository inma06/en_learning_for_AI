import 'word.dart';

class WordList {
  final String id;
  final String title;
  final String description;
  final List<Word> words;
  final DateTime createdAt;
  final DateTime lastStudied;
  final bool isCompleted;

  WordList({
    required this.id,
    required this.title,
    required this.description,
    required this.words,
    required this.createdAt,
    required this.lastStudied,
    this.isCompleted = false,
  });

  int get totalWords => words.length;
  int get masteredWords => words.where((word) => word.isMastered).length;
  double get completionRate => totalWords == 0 ? 0 : masteredWords / totalWords;

  List<Word> get mostIncorrectWords {
    final sortedWords = List<Word>.from(words);
    sortedWords.sort((a, b) => b.wrongCount.compareTo(a.wrongCount));
    return sortedWords;
  }

  List<Word> get recentlyPracticedWords {
    final sortedWords = List<Word>.from(words);
    sortedWords.sort((a, b) => b.lastPracticed.compareTo(a.lastPracticed));
    return sortedWords;
  }

  WordList copyWith({
    String? id,
    String? title,
    String? description,
    List<Word>? words,
    DateTime? createdAt,
    DateTime? lastStudied,
    bool? isCompleted,
  }) {
    return WordList(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      words: words ?? this.words,
      createdAt: createdAt ?? this.createdAt,
      lastStudied: lastStudied ?? this.lastStudied,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'words': words.map((word) => word.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'lastStudied': lastStudied.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  factory WordList.fromJson(Map<String, dynamic> json) {
    return WordList(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      words: (json['words'] as List)
          .map((wordJson) => Word.fromJson(wordJson as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastStudied: DateTime.parse(json['lastStudied'] as String),
      isCompleted: json['isCompleted'] as bool,
    );
  }
}
