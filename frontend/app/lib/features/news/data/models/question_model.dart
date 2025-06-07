import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/question_entity.dart';

part 'question_model.freezed.dart';
part 'question_model.g.dart';

@freezed
class QuestionModel with _$QuestionModel {
  const factory QuestionModel({
    @JsonKey(name: '_id') required String id,
    required String headline,
    required String paragraph,
    String? source,
    @JsonKey(name: 'main_idea_question')
    MainIdeaQuestionModel? mainIdeaQuestion,
    @JsonKey(name: 'fill_in_the_blank_question')
    FillInTheBlankQuestionModel? fillInTheBlankQuestion,
    required DateTime createdAt,
    String? userResponse,
    bool? isCorrect,
  }) = _QuestionModel;

  factory QuestionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionModelFromJson(json);
}

@freezed
class MainIdeaQuestionModel with _$MainIdeaQuestionModel {
  const factory MainIdeaQuestionModel({
    required String question,
    required List<String> choices,
    required String answer,
    String? difficulty,
  }) = _MainIdeaQuestionModel;

  factory MainIdeaQuestionModel.fromJson(Map<String, dynamic> json) =>
      _$MainIdeaQuestionModelFromJson(json);
}

@freezed
class FillInTheBlankQuestionModel with _$FillInTheBlankQuestionModel {
  const factory FillInTheBlankQuestionModel({
    @JsonKey(name: 'question_text_with_blank')
    required String questionTextWithBlank,
    @JsonKey(name: 'question_prompt') required String questionPrompt,
    required List<String> choices,
    required String answer,
    String? difficulty,
  }) = _FillInTheBlankQuestionModel;

  factory FillInTheBlankQuestionModel.fromJson(Map<String, dynamic> json) =>
      _$FillInTheBlankQuestionModelFromJson(json);
}

// Extension methods to convert to domain entities
extension QuestionModelX on QuestionModel {
  Question toEntity() => Question(
        id: id,
        headline: headline,
        paragraph: paragraph,
        source: source,
        mainIdeaQuestion: mainIdeaQuestion?.toEntity(),
        fillInTheBlankQuestion: fillInTheBlankQuestion?.toEntity(),
        createdAt: createdAt,
        userResponse: userResponse,
        isCorrect: isCorrect,
      );
}

extension MainIdeaQuestionModelX on MainIdeaQuestionModel {
  MainIdeaQuestion toEntity() => MainIdeaQuestion(
        question: question,
        choices: choices,
        answer: answer,
        difficulty: difficulty,
      );
}

extension FillInTheBlankQuestionModelX on FillInTheBlankQuestionModel {
  FillInTheBlankQuestion toEntity() => FillInTheBlankQuestion(
        questionTextWithBlank: questionTextWithBlank,
        questionPrompt: questionPrompt,
        choices: choices,
        answer: answer,
        difficulty: difficulty,
      );
}
