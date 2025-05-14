import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:language_learning_app/features/news/domain/models/question.dart';
import 'package:language_learning_app/features/news/domain/services/news_quiz_service.dart';
import 'package:language_learning_app/features/news/domain/models/paginated_questions_response.dart';
import './select_question_count_provider.dart'; // selectedQuestionLimitProvider 임포트

// Enum to represent the type of question part to display
enum QuestionPartType { mainIdea, fillInTheBlank }

// Provider to hold the current part of the question being displayed
final currentQuestionPartTypeProvider =
    StateProvider<QuestionPartType>((ref) => QuestionPartType.mainIdea);

final newsQuizServiceProvider = Provider<NewsQuizService>((ref) {
  return NewsQuizService(baseUrl: 'http://localhost:3001/api');
});

// --- 페이지네이션을 위한 Questions State 및 Notifier ---
class QuestionsState {
  final List<Question> questions;
  final bool isLoading;
  final bool isLoadingMore;
  final int currentPage;
  final int totalPages;
  final int totalQuestions;
  final String? error;
  final bool canLoadMore;

  QuestionsState({
    this.questions = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.currentPage = 0, // API는 1부터 시작하므로 초기값 조정 필요할 수 있음
    this.totalPages = 0,
    this.totalQuestions = 0,
    this.error,
    this.canLoadMore = true,
  });

  QuestionsState copyWith({
    List<Question>? questions,
    bool? isLoading,
    bool? isLoadingMore,
    int? currentPage,
    int? totalPages,
    int? totalQuestions,
    String? error,
    bool? canLoadMore,
    bool clearError = false,
  }) {
    return QuestionsState(
      questions: questions ?? this.questions,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      error: clearError ? null : error ?? this.error, // clearError 플래그 추가
      canLoadMore: canLoadMore ?? this.canLoadMore,
    );
  }
}

class QuestionsNotifier extends StateNotifier<QuestionsState> {
  final NewsQuizService _newsQuizService;
  final int _itemsPerPage; // 페이지 당 항목 수 (selectedQuestionLimitProvider에서 받아옴)

  QuestionsNotifier(this._newsQuizService, this._itemsPerPage)
      : super(QuestionsState()) {
    // 생성자에서 _itemsPerPage를 받으므로, fetchInitialQuestions 호출 시 자동으로 사용됨
    // fetchInitialQuestions(); // resetState에서 호출하거나, 화면 진입 시 최초 호출을 고려
  }

  Future<void> fetchInitialQuestions() async {
    if (state.isLoading) return;
    state = state.copyWith(
        isLoading: true,
        error: null,
        clearError: true,
        questions: [],
        currentPage: 0,
        totalPages: 0,
        totalQuestions: 0,
        canLoadMore: true); // 상태 초기화 강화
    try {
      final response =
          await _newsQuizService.getQuestions(page: 1, limit: _itemsPerPage);
      state = state.copyWith(
        questions: response.questions,
        currentPage: response.currentPage,
        totalPages: response.totalPages,
        totalQuestions: response.totalQuestions,
        isLoading: false,
        canLoadMore: response.currentPage < response.totalPages,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchNextPage() async {
    if (state.isLoadingMore || !state.canLoadMore) return;
    state = state.copyWith(isLoadingMore: true, error: null, clearError: true);
    try {
      final nextPage = state.currentPage + 1;
      final response = await _newsQuizService.getQuestions(
          page: nextPage, limit: _itemsPerPage);
      state = state.copyWith(
        questions: [...state.questions, ...response.questions], // 기존 목록에 추가
        currentPage: response.currentPage,
        totalPages: response.totalPages, // totalPages는 보통 동일하나, 응답에 따라 업데이트
        totalQuestions:
            response.totalQuestions, // totalQuestions도 보통 동일하나, 응답에 따라 업데이트
        isLoadingMore: false,
        canLoadMore: response.currentPage < response.totalPages,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e.toString());
    }
  }

  // 진행 상황 로드를 위한 새 메소드
  Future<void> fetchQuestionsStartingFromPage(int page) async {
    if (state.isLoading) return;
    state = state.copyWith(
        isLoading: true,
        error: null,
        clearError: true,
        questions: [], // 이전 질문 목록 초기화
        currentPage: 0, // 페이지 관련 상태 초기화
        totalPages: 0,
        totalQuestions: 0,
        canLoadMore: true);
    try {
      final response =
          await _newsQuizService.getQuestions(page: page, limit: _itemsPerPage);
      state = state.copyWith(
        questions: response.questions, // 새 질문 목록으로 교체
        currentPage: response.currentPage,
        totalPages: response.totalPages,
        totalQuestions: response.totalQuestions,
        isLoading: false,
        canLoadMore: response.currentPage < response.totalPages,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> resetState() async {
    // state = QuestionsState(); // fetchInitialQuestions에서 초기화 강화 부분으로 대체 또는 병합
    // fetchInitialQuestions(); // 이제 fetchInitialQuestions가 호출될 때, QuestionsState의 questions등을 초기화함.
    // resetState는 외부에서 호출되어 초기 질문 로드를 트리거
    // 예를 들어 SelectQuestionCountScreen에서 limit 변경 후 NewsQuizScreen으로 올 때 호출됨
    // 또는 NewsQuizScreen의 새로고침 버튼
    // 이 시점에서 itemsPerPage (selectedLimit)는 이미 Notifier 생성시 설정된 최신 값을 가짐.
    state = QuestionsState(
        isLoading: state
            .isLoading); // 로딩 상태만 유지하고 나머지는 fetchInitialQuestions에서 덮어쓰도록 함
    // 또는 fetchInitialQuestions 시작 부분에서 questions 등을 명시적으로 비워줌.
    await fetchInitialQuestions();
  }
}

final questionsStateNotifierProvider =
    StateNotifierProvider<QuestionsNotifier, QuestionsState>((ref) {
  final newsQuizService = ref.watch(newsQuizServiceProvider);
  final selectedLimit =
      ref.watch(selectedQuestionLimitProvider); // 사용자가 선택한 limit
  return QuestionsNotifier(newsQuizService, selectedLimit);
});

// --- 기존 Provider 수정 및 신규 Provider ---

final currentQuestionIndexProvider = StateProvider<int>((ref) => 0);

// 현재 화면에 표시될 Question 객체 (리스트에서 현재 인덱스에 해당하는 것)
final currentQuestionProvider = Provider<Question?>((ref) {
  final questionsState = ref.watch(questionsStateNotifierProvider);
  final currentIndex = ref.watch(currentQuestionIndexProvider);

  if (questionsState.questions.isEmpty ||
      currentIndex >= questionsState.questions.length) {
    return null;
  }
  return questionsState.questions[currentIndex];
});

final userResponsesProvider = StateProvider<Map<int, String>>((ref) => {});

// 전체 퀴즈(모든 페이지 포함)가 완료되었는지 여부
final isQuizCompletedProvider = Provider<bool>((ref) {
  final questionsState = ref.watch(questionsStateNotifierProvider);
  final currentIndex = ref.watch(currentQuestionIndexProvider);

  // 아직 로딩 중이거나, 질문이 없거나, 더 로드할 페이지가 있다면 완료되지 않음
  if (questionsState.isLoading || questionsState.questions.isEmpty)
    return false;
  // 현재 인덱스가 전체 로드된 질문 수보다 크거나 같고, 더 이상 로드할 페이지가 없을 때 완료
  return currentIndex >= questionsState.questions.length &&
      !questionsState.canLoadMore;
});

// 화면 상단에 표시될 전체 문항 수 (e.g., "총 50문제 중")
final totalQuestionCountDisplayProvider = Provider<int>((ref) {
  return ref.watch(questionsStateNotifierProvider).totalQuestions;
});

// 현재 풀고 있는 문제 번호 (1부터 시작, main/fill-in-the-blank 모두 고려)
final currentQuestionNumberDisplayProvider = Provider<int>((ref) {
  final questionsState = ref.watch(questionsStateNotifierProvider);
  final overallQuestionIndex =
      ref.watch(currentQuestionIndexProvider); // 현재 Question 객체의 인덱스
  final currentPart =
      ref.watch(currentQuestionPartTypeProvider); // 현재 Question 객체의 파트

  if (questionsState.questions.isEmpty ||
      overallQuestionIndex >= questionsState.questions.length) {
    return 0;
  }

  int count = 0;
  for (int i = 0; i < overallQuestionIndex; i++) {
    count++; // mainIdeaQuestion
    if (questionsState.questions[i].fillInTheBlankQuestion != null) {
      count++; // fillInTheBlankQuestion (존재한다면)
    }
  }

  count++; // 현재 Question 객체의 mainIdeaQuestion
  if (currentPart == QuestionPartType.fillInTheBlank &&
      questionsState.questions[overallQuestionIndex].fillInTheBlankQuestion !=
          null) {
    // 현재 fill-in-the-blank를 풀고 있다면 +1 (이미 mainIdea는 위에서 count됨)
    // 이부분은 currentQuestionIndexProvider가 다음 Question 객체로 넘어가기 전에 fillInTheBlank를 처리하므로,
    // 실제로는 mainIdea를 풀 때, fillInTheBlank를 풀 때 모두 동일한 overallQuestionIndex를 가짐.
    // 따라서, count는 mainIdea 기준으로 계산하고, 만약 현재가 fillInTheBlank면 +1을 해주는게 아니라,
    // mainIdea 파트를 셀 때 이미 +1이 되었고, fillInTheBlank 파트를 풀고 있다면 그 다음 번호여야함.
    // 좀 더 명확하게: 이전 문제까지의 파트 수 + 현재 문제의 mainIdea 파트 (+1) + (현재 fillInTheBlank 풀고있으면 +1)
  } else if (currentPart == QuestionPartType.mainIdea) {
    // mainIdea를 풀고 있는 경우는 위에서 이미 count++ 되었음.
  }
  // 위 로직은 복잡하니, 단순화: 각 Question 객체는 1 또는 2개의 "풀어야 할 문제"를 가짐
  // 이전 문제들까지 풀었던 "풀어야 할 문제"의 총합 + 현재 문제에서 몇 번째 "풀어야 할 문제"인지
  count = 0; // 재계산
  for (int i = 0; i < overallQuestionIndex; i++) {
    count++; // mainIdeaQuestion
    if (questionsState.questions[i].fillInTheBlankQuestion != null) {
      count++;
    }
  }
  count++; // 현재 Question의 Main Idea
  if (currentPart == QuestionPartType.fillInTheBlank) {
    count++; // 현재 Question의 Fill in the blank
  }

  return count;
});
