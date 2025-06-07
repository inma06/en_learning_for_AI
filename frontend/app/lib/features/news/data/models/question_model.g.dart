// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestionModelImpl _$$QuestionModelImplFromJson(Map<String, dynamic> json) =>
    _$QuestionModelImpl(
      id: json['_id'] as String,
      headline: json['headline'] as String,
      paragraph: json['paragraph'] as String,
      source: json['source'] as String?,
      mainIdeaQuestion: json['main_idea_question'] == null
          ? null
          : MainIdeaQuestionModel.fromJson(
              json['main_idea_question'] as Map<String, dynamic>),
      fillInTheBlankQuestion: json['fill_in_the_blank_question'] == null
          ? null
          : FillInTheBlankQuestionModel.fromJson(
              json['fill_in_the_blank_question'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      userResponse: json['userResponse'] as String?,
      isCorrect: json['isCorrect'] as bool?,
    );

Map<String, dynamic> _$$QuestionModelImplToJson(_$QuestionModelImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'headline': instance.headline,
      'paragraph': instance.paragraph,
      'source': instance.source,
      'main_idea_question': instance.mainIdeaQuestion,
      'fill_in_the_blank_question': instance.fillInTheBlankQuestion,
      'createdAt': instance.createdAt.toIso8601String(),
      'userResponse': instance.userResponse,
      'isCorrect': instance.isCorrect,
    };

_$MainIdeaQuestionModelImpl _$$MainIdeaQuestionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$MainIdeaQuestionModelImpl(
      question: json['question'] as String,
      choices:
          (json['choices'] as List<dynamic>).map((e) => e as String).toList(),
      answer: json['answer'] as String,
      difficulty: json['difficulty'] as String?,
    );

Map<String, dynamic> _$$MainIdeaQuestionModelImplToJson(
        _$MainIdeaQuestionModelImpl instance) =>
    <String, dynamic>{
      'question': instance.question,
      'choices': instance.choices,
      'answer': instance.answer,
      'difficulty': instance.difficulty,
    };

_$FillInTheBlankQuestionModelImpl _$$FillInTheBlankQuestionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$FillInTheBlankQuestionModelImpl(
      questionTextWithBlank: json['question_text_with_blank'] as String,
      questionPrompt: json['question_prompt'] as String,
      choices:
          (json['choices'] as List<dynamic>).map((e) => e as String).toList(),
      answer: json['answer'] as String,
      difficulty: json['difficulty'] as String?,
    );

Map<String, dynamic> _$$FillInTheBlankQuestionModelImplToJson(
        _$FillInTheBlankQuestionModelImpl instance) =>
    <String, dynamic>{
      'question_text_with_blank': instance.questionTextWithBlank,
      'question_prompt': instance.questionPrompt,
      'choices': instance.choices,
      'answer': instance.answer,
      'difficulty': instance.difficulty,
    };
