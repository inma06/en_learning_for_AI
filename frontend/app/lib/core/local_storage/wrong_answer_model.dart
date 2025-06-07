import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wrong_answer_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class WrongAnswer extends HiveObject {
  @HiveField(0)
  final String questionId;

  @HiveField(1)
  final String headline;

  @HiveField(2)
  final String paragraph;

  @HiveField(3)
  final String questionText;

  @HiveField(4)
  final String questionType; // 'main_idea' or 'fill_in_blank'

  @HiveField(5)
  final List<String> choices;

  @HiveField(6)
  final String correctAnswer;

  @HiveField(7)
  final String userAnswer;

  @HiveField(8)
  final DateTime wrongDate;

  @HiveField(9)
  final String? source;

  @HiveField(10)
  final String? difficulty;

  @HiveField(11)
  final DateTime createdAt;

  @HiveField(12)
  final String? questionPrompt;

  WrongAnswer({
    required this.questionId,
    required this.headline,
    required this.paragraph,
    required this.questionText,
    required this.questionType,
    required this.choices,
    required this.correctAnswer,
    required this.userAnswer,
    required this.wrongDate,
    this.source,
    this.difficulty,
    required this.createdAt,
    this.questionPrompt,
  });

  factory WrongAnswer.fromJson(Map<String, dynamic> json) =>
      _$WrongAnswerFromJson(json);

  Map<String, dynamic> toJson() => _$WrongAnswerToJson(this);
}
