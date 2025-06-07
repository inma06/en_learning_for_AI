// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wrong_answer_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WrongAnswerAdapter extends TypeAdapter<WrongAnswer> {
  @override
  final int typeId = 0;

  @override
  WrongAnswer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WrongAnswer(
      questionId: fields[0] as String,
      headline: fields[1] as String,
      paragraph: fields[2] as String,
      questionText: fields[3] as String,
      questionType: fields[4] as String,
      choices: (fields[5] as List).cast<String>(),
      correctAnswer: fields[6] as String,
      userAnswer: fields[7] as String,
      wrongDate: fields[8] as DateTime,
      source: fields[9] as String?,
      difficulty: fields[10] as String?,
      createdAt: fields[11] as DateTime,
      questionPrompt: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, WrongAnswer obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.questionId)
      ..writeByte(1)
      ..write(obj.headline)
      ..writeByte(2)
      ..write(obj.paragraph)
      ..writeByte(3)
      ..write(obj.questionText)
      ..writeByte(4)
      ..write(obj.questionType)
      ..writeByte(5)
      ..write(obj.choices)
      ..writeByte(6)
      ..write(obj.correctAnswer)
      ..writeByte(7)
      ..write(obj.userAnswer)
      ..writeByte(8)
      ..write(obj.wrongDate)
      ..writeByte(9)
      ..write(obj.source)
      ..writeByte(10)
      ..write(obj.difficulty)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.questionPrompt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WrongAnswerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WrongAnswer _$WrongAnswerFromJson(Map<String, dynamic> json) => WrongAnswer(
      questionId: json['questionId'] as String,
      headline: json['headline'] as String,
      paragraph: json['paragraph'] as String,
      questionText: json['questionText'] as String,
      questionType: json['questionType'] as String,
      choices:
          (json['choices'] as List<dynamic>).map((e) => e as String).toList(),
      correctAnswer: json['correctAnswer'] as String,
      userAnswer: json['userAnswer'] as String,
      wrongDate: DateTime.parse(json['wrongDate'] as String),
      source: json['source'] as String?,
      difficulty: json['difficulty'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      questionPrompt: json['questionPrompt'] as String?,
    );

Map<String, dynamic> _$WrongAnswerToJson(WrongAnswer instance) =>
    <String, dynamic>{
      'questionId': instance.questionId,
      'headline': instance.headline,
      'paragraph': instance.paragraph,
      'questionText': instance.questionText,
      'questionType': instance.questionType,
      'choices': instance.choices,
      'correctAnswer': instance.correctAnswer,
      'userAnswer': instance.userAnswer,
      'wrongDate': instance.wrongDate.toIso8601String(),
      'source': instance.source,
      'difficulty': instance.difficulty,
      'createdAt': instance.createdAt.toIso8601String(),
      'questionPrompt': instance.questionPrompt,
    };
