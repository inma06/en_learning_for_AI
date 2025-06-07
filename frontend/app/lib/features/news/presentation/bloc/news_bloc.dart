import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/local_storage/hive_service.dart';
import '../../../../core/local_storage/wrong_answer_model.dart';
import '../../domain/entities/question_entity.dart';
import '../../domain/usecases/get_questions.dart';
import '../../domain/usecases/submit_answer.dart';

part 'news_event.dart';
part 'news_state.dart';

@injectable
class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetQuestions _getQuestions;
  final SubmitAnswer _submitAnswer;
  final HiveService _hiveService = GetIt.instance<HiveService>();

  NewsBloc(
    this._getQuestions,
    this._submitAnswer,
  ) : super(NewsInitial()) {
    on<LoadQuestionsEvent>(_onLoadQuestions);
    on<LoadWrongAnswersEvent>(_onLoadWrongAnswers);
    on<SubmitAnswerEvent>(_onSubmitAnswer);
    on<NextQuestionEvent>(_onNextQuestion);
  }

  Future<void> _onLoadQuestions(
    LoadQuestionsEvent event,
    Emitter<NewsState> emit,
  ) async {
    emit(NewsLoading());

    final result = await _getQuestions(NoParams());

    result.fold(
      (failure) => emit(NewsError(_mapFailureToMessage(failure))),
      (questions) {
        // Questions를 QuestionItems로 변환
        List<QuestionItem> questionItems = [];
        for (Question question in questions) {
          questionItems.addAll(questionToItems(question));
        }
        emit(NewsLoaded(questionItems, currentQuestionIndex: 0));
      },
    );
  }

  void _onLoadWrongAnswers(
    LoadWrongAnswersEvent event,
    Emitter<NewsState> emit,
  ) {
    emit(NewsLoading());

    // 오답 문제들을 바로 로드
    if (event.wrongQuestionItems.isNotEmpty) {
      emit(NewsLoaded(event.wrongQuestionItems, currentQuestionIndex: 0));
    } else {
      emit(const NewsError('오답 문제가 없습니다.'));
    }
  }

  Future<void> _onSubmitAnswer(
    SubmitAnswerEvent event,
    Emitter<NewsState> emit,
  ) async {
    if (state is NewsLoaded) {
      final currentState = state as NewsLoaded;
      emit(NewsSubmittingAnswer(currentState.questionItems,
          currentQuestionIndex: currentState.currentQuestionIndex));

      // 정답 확인
      final currentItem =
          currentState.questionItems[currentState.currentQuestionIndex];
      final isCorrect = currentItem.correctAnswer == event.answer;

      // 오답인 경우 Hive에 저장
      if (!isCorrect) {
        final wrongAnswer = WrongAnswer(
          questionId: currentItem.id,
          headline: currentItem.headline,
          paragraph: currentItem.paragraph,
          questionText: currentItem.questionText,
          questionType: currentItem.type == QuestionType.mainIdea
              ? 'main_idea'
              : 'fill_in_blank',
          choices: currentItem.choices,
          correctAnswer: currentItem.correctAnswer,
          userAnswer: event.answer,
          wrongDate: DateTime.now(),
          source: currentItem.source,
          difficulty: currentItem.difficulty,
          createdAt: currentItem.createdAt,
          questionPrompt: currentItem.questionPrompt,
        );

        await _hiveService.saveWrongAnswer(wrongAnswer);
        print('Wrong answer saved: ${currentItem.id}');
      } else {
        // 정답인 경우, 오답노트에서 해당 문제를 삭제
        await _hiveService.deleteWrongAnswer(currentItem.id);
        print('Correct answer - removed from wrong answers: ${currentItem.id}');
      }

      // QuestionItem 업데이트
      final updatedItems = List<QuestionItem>.from(currentState.questionItems);
      updatedItems[currentState.currentQuestionIndex] = currentItem.copyWith(
        userResponse: event.answer,
        isCorrect: isCorrect,
      );

      // QuestionItem ID에서 원래 question ID 추출 (_main, _fill 제거)
      String originalQuestionId = event.questionId;
      if (originalQuestionId.endsWith('_main') ||
          originalQuestionId.endsWith('_fill')) {
        originalQuestionId = originalQuestionId.substring(
            0, originalQuestionId.lastIndexOf('_'));
      }

      final result = await _submitAnswer(
        SubmitAnswerParams(
          questionId: originalQuestionId,
          answer: event.answer,
        ),
      );

      result.fold(
        (failure) => emit(NewsError(_mapFailureToMessage(failure))),
        (_) {
          emit(NewsAnswerSubmitted(updatedItems,
              currentQuestionIndex: currentState.currentQuestionIndex));
        },
      );
    }
  }

  void _onNextQuestion(
    NextQuestionEvent event,
    Emitter<NewsState> emit,
  ) {
    print('NextQuestionEvent received - Current state: ${state.runtimeType}');

    // NewsAnswerSubmitted 또는 NewsLoaded 상태에서 다음 문제로 이동
    List<QuestionItem>? questionItems;
    int? currentIndex;

    if (state is NewsAnswerSubmitted) {
      final currentState = state as NewsAnswerSubmitted;
      questionItems = currentState.questionItems;
      currentIndex = currentState.currentQuestionIndex;
      print(
          'State: NewsAnswerSubmitted, Current index: $currentIndex, Total questions: ${questionItems.length}');
    } else if (state is NewsLoaded) {
      final currentState = state as NewsLoaded;
      questionItems = currentState.questionItems;
      currentIndex = currentState.currentQuestionIndex;
      print(
          'State: NewsLoaded, Current index: $currentIndex, Total questions: ${questionItems.length}');
    } else if (state is NewsSubmittingAnswer) {
      final currentState = state as NewsSubmittingAnswer;
      questionItems = currentState.questionItems;
      currentIndex = currentState.currentQuestionIndex;
      print(
          'State: NewsSubmittingAnswer, Current index: $currentIndex, Total questions: ${questionItems.length}');
    }

    if (questionItems == null || currentIndex == null) {
      print('Error: questionItems or currentIndex is null');
      emit(const NewsError('상태 오류가 발생했습니다.'));
      return;
    }

    final nextIndex = currentIndex + 1;
    print('Moving from index $currentIndex to $nextIndex');

    if (nextIndex < questionItems.length) {
      print('Loading next question at index $nextIndex');
      emit(NewsLoaded(questionItems, currentQuestionIndex: nextIndex));
    } else {
      // 모든 문제를 완료했을 때 - 결과 상태로 변경
      print('All questions completed - showing results');
      emit(NewsCompleted(questionItems));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server Failure';
      case CacheFailure:
        return 'Cache Failure';
      case NetworkFailure:
        return 'Network Failure';
      default:
        return 'Unexpected Error';
    }
  }
}
