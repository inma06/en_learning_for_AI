part of 'news_bloc.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object> get props => [];
}

class LoadQuestionsEvent extends NewsEvent {}

class LoadWrongAnswersEvent extends NewsEvent {
  final List<QuestionItem> wrongQuestionItems;

  const LoadWrongAnswersEvent({
    required this.wrongQuestionItems,
  });

  @override
  List<Object> get props => [wrongQuestionItems];
}

class SubmitAnswerEvent extends NewsEvent {
  final String questionId;
  final String answer;

  const SubmitAnswerEvent({
    required this.questionId,
    required this.answer,
  });

  @override
  List<Object> get props => [questionId, answer];
}

class NextQuestionEvent extends NewsEvent {}
