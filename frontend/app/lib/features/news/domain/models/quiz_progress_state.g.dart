// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_progress_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuizProgressStateAdapter extends TypeAdapter<QuizProgressState> {
  @override
  final int typeId = 0;

  @override
  QuizProgressState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuizProgressState(
      questionId: fields[0] as String?,
      questionDisplayIndex: fields[1] as int,
      currentQuestionPartTypeString: fields[2] as String,
      currentPageForApi: fields[3] as int,
      selectedLimit: fields[4] as int,
      lastSavedAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, QuizProgressState obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.questionId)
      ..writeByte(1)
      ..write(obj.questionDisplayIndex)
      ..writeByte(2)
      ..write(obj.currentQuestionPartTypeString)
      ..writeByte(3)
      ..write(obj.currentPageForApi)
      ..writeByte(4)
      ..write(obj.selectedLimit)
      ..writeByte(5)
      ..write(obj.lastSavedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizProgressStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
