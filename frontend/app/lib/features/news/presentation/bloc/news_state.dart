part of 'news_bloc.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<QuestionItem> questionItems;
  final int currentQuestionIndex;

  const NewsLoaded(this.questionItems, {this.currentQuestionIndex = 0});

  @override
  List<Object> get props => [questionItems, currentQuestionIndex];
}

class NewsSubmittingAnswer extends NewsState {
  final List<QuestionItem> questionItems;
  final int currentQuestionIndex;

  const NewsSubmittingAnswer(this.questionItems,
      {this.currentQuestionIndex = 0});

  @override
  List<Object> get props => [questionItems, currentQuestionIndex];
}

class NewsAnswerSubmitted extends NewsState {
  final List<QuestionItem> questionItems;
  final int currentQuestionIndex;

  const NewsAnswerSubmitted(this.questionItems,
      {this.currentQuestionIndex = 0});

  @override
  List<Object> get props => [questionItems, currentQuestionIndex];
}

class NewsCompleted extends NewsState {
  final List<QuestionItem> questionItems;

  const NewsCompleted(this.questionItems);

  @override
  List<Object> get props => [questionItems];
}

class NewsError extends NewsState {
  final String message;

  const NewsError(this.message);

  @override
  List<Object> get props => [message];
}
