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
  final int _initialItemsPerPage; // 생성 시점의 아이템 수
  final Ref _ref; // Ref 객체를 저장하기 위한 멤버 변수

  QuestionsNotifier(this._newsQuizService, this._initialItemsPerPage, this._ref)
      : super(QuestionsState()) {
    // fetchInitialQuestions();
  }

  Future<void> fetchInitialQuestions() async {
    if (state.isLoading) return;
    final selectedLimit =
        _ref.read(selectedQuestionLimitProvider); // 현재 선택된 limit 가져오기
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
      final response = await _newsQuizService.getQuestions(
          page: 1, limit: selectedLimit); // _itemsPerPage 대신 selectedLimit 사용
      final bool canActuallyLoadMore =
          response.currentPage < response.totalPages &&
              response.questions.length < selectedLimit;
      state = state.copyWith(
        questions: response.questions,
        currentPage: response.currentPage,
        totalPages: response.totalPages,
        totalQuestions: response.totalQuestions, // API가 반환하는 전체 문제 수
        isLoading: false,
        canLoadMore: canActuallyLoadMore,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchNextPage() async {
    final selectedLimit = _ref.read(selectedQuestionLimitProvider);
    if (state.isLoadingMore ||
        !state.canLoadMore ||
        state.questions.length >= selectedLimit) {
      if (state.questions.length >= selectedLimit && state.canLoadMore) {
        // 추가: 더 로드할 수 있다고 착각하는 경우 방지
        state = state.copyWith(canLoadMore: false, isLoadingMore: false);
      }
      return;
    }
    state = state.copyWith(isLoadingMore: true, error: null, clearError: true);
    try {
      final nextPage = state.currentPage + 1;
      // 다음 페이지에서 가져올 문제 수 결정: selectedLimit - 현재까지 로드된 문제 수
      // 하지만 API는 페이지 단위로 가져오므로, limit은 selectedLimit을 그대로 사용하되,
      // 가져온 후에는 selectedLimit을 넘지 않도록 잘라내거나,
      // 또는 API의 limit 파라미터는 페이지당 가져올 최대 개수이므로 selectedLimit을 사용
      final response = await _newsQuizService.getQuestions(
          page: nextPage, limit: selectedLimit); // API limit은 선택된 전체 limit으로 요청

      List<Question> newQuestions = response.questions;
      List<Question> combinedQuestions = [...state.questions, ...newQuestions];

      // 선택된 limit을 초과하지 않도록 질문 목록 조정
      if (combinedQuestions.length > selectedLimit) {
        combinedQuestions = combinedQuestions.sublist(0, selectedLimit);
      }

      final bool canActuallyLoadMore =
          response.currentPage < response.totalPages &&
              combinedQuestions.length < selectedLimit;

      state = state.copyWith(
        questions: combinedQuestions,
        currentPage: response.currentPage,
        totalPages: response.totalPages,
        totalQuestions: response.totalQuestions,
        isLoadingMore: false,
        canLoadMore: canActuallyLoadMore,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e.toString());
    }
  }

  // 진행 상황 로드를 위한 새 메소드
  Future<void> fetchQuestionsStartingFromPage(
      int page, int displayIndexToResume, int limitFromSaved) async {
    // displayIndexToResume: 저장된 진행 상황에서 몇 번째 "파트"였는지 (0-indexed)
    // limitFromSaved: 저장된 진행 상황에서의 limit 값
    if (state.isLoading) return;
    state = state.copyWith(
        isLoading: true,
        error: null,
        clearError: true,
        questions: [],
        currentPage: 0,
        totalPages: 0,
        totalQuestions: 0,
        canLoadMore: true);
    try {
      // 목표: displayIndexToResume 파트가 포함된 Question 객체들을 가져오고,
      // 총 question 파트 수가 limitFromSaved를 넘지 않도록 한다.

      // 먼저, displayIndexToResume 파트가 몇 번째 Question 객체에 속하는지,
      // 그리고 그 Question 객체 내에서 몇 번째 파트인지 알아야 한다.
      // 이는 API 응답을 받아봐야 알 수 있으므로, 일단 첫 페이지부터 limitFromSaved 만큼 가져와서 처리.
      // 또는, API가 특정 ID부터 가져오는 기능을 지원하면 더 효율적. 여기서는 페이지 기반으로 가정.

      // 우선 저장된 limit 만큼의 문제를 가져온다. (여러 페이지에 걸쳐 있을 수 있음)
      List<Question> allPotentiallyNeededQuestions = [];
      int currentPageToFetch = page; // 저장된 페이지부터 시작
      bool moreDataExistsInApi = true;
      int accumulatedQuestionCount = 0;

      while (allPotentiallyNeededQuestions.length < limitFromSaved &&
          moreDataExistsInApi) {
        // 실제 API에 요청하는 limit은 _itemsPerPage(또는 selectedQuestionLimitProvider)가 아닌,
        // 한 번에 가져올 적절한 양 (예: 10 또는 limitFromSaved) 이어야 한다.
        // 여기서는 limitFromSaved를 페이지별 limit으로 가정하지 않고, 전체 목표치로 본다.
        // API 호출 시 limit은 newsQuizService의 페이지당 기본 limit을 따르거나,
        // 여기서는 selectedLimitProvider의 현재 값을 사용한다 (저장된 limit이 아닌).
        final currentSelectedLimit = _ref.read(selectedQuestionLimitProvider);

        final response = await _newsQuizService.getQuestions(
            page: currentPageToFetch, limit: currentSelectedLimit);
        allPotentiallyNeededQuestions.addAll(response.questions);
        moreDataExistsInApi = response.currentPage < response.totalPages;
        currentPageToFetch++;
        if (response.questions.isEmpty && moreDataExistsInApi) {
          // 가져온 문제가 없는데 더 있다면 무한루프 방지
          moreDataExistsInApi = false; // 문제가 없으면 더 이상 가져올 수 없음으로 처리
        }

        // 너무 많은 데이터를 가져오는 것을 방지하기 위한 안전장치
        // (예: limitFromSaved가 매우 크고, 페이지당 문제는 적을 경우)
        if (currentPageToFetch > response.totalPages + 5 &&
            response.totalPages > 0) {
          // 예시: 5페이지 이상 초과 시 중단
          break;
        }
        if (allPotentiallyNeededQuestions.length >= limitFromSaved * 2 &&
            limitFromSaved > 0) {
          // 예상보다 2배 이상 많으면 중단
          break;
        }
      }

      // 가져온 문제들 중에서 limitFromSaved 개수만큼만 유지
      if (allPotentiallyNeededQuestions.length > limitFromSaved) {
        allPotentiallyNeededQuestions =
            allPotentiallyNeededQuestions.sublist(0, limitFromSaved);
      }

      final bool canActuallyLoadMore = moreDataExistsInApi && // API에 더 페이지가 있고
          allPotentiallyNeededQuestions.length <
              limitFromSaved && // 아직 저장된 limit만큼 못 채웠고
          allPotentiallyNeededQuestions.length <
              _ref.read(selectedQuestionLimitProvider); // 현재 선택된 limit보다도 작아야 함

      state = state.copyWith(
        questions: allPotentiallyNeededQuestions,
        currentPage: currentPageToFetch - 1, // 마지막으로 성공적으로 가져온 페이지
        totalPages: state
            .totalPages, // totalPages는 초기 fetch나 다음 페이지 fetch때 결정되므로 여기선 유지하거나 API 응답 기반으로 업데이트. 여기선 일단 유지.
        totalQuestions: state.totalQuestions, // 위와 동일
        isLoading: false,
        canLoadMore: canActuallyLoadMore,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> resetState() async {
    // resetState는 외부에서 호출되어 초기 질문 로드를 트리거
    // 이 시점에서 itemsPerPage (_itemsPerPage)는 Notifier 생성 시점의 값이다.
    // selectedQuestionLimitProvider의 최신 값을 사용하려면 fetchInitialQuestions 내부에서 읽어야 한다.
    // QuestionsNotifier 생성자에 Reader를 주입하여 selectedQuestionLimitProvider에 접근하도록 변경
    state = QuestionsState(isLoading: state.isLoading);
    await fetchInitialQuestions();
  }
}

final questionsStateNotifierProvider =
    StateNotifierProvider<QuestionsNotifier, QuestionsState>((ref) {
  final newsQuizService = ref.watch(newsQuizServiceProvider);
  final selectedLimit = ref.watch(selectedQuestionLimitProvider);
  return QuestionsNotifier(
      newsQuizService, selectedLimit, ref); // ref 객체 전체를 전달
});

// --- 기존 Provider 수정 및 신규 Provider ---

final currentQuestionIndexProvider = StateProvider<int>((ref) => 0);

// 현재 화면에 표시될 Question 객체 (리스트에서 현재 인덱스에 해당하는 것)
final currentQuestionProvider = Provider<Question?>((ref) {
  final questionsState = ref.watch(questionsStateNotifierProvider);
  final currentIndex = ref.watch(currentQuestionIndexProvider);
  final selectedLimit = ref.watch(selectedQuestionLimitProvider);

  // 로드된 질문의 수가 선택된 제한보다 클 경우, UI에서는 제한된 수만큼만 고려해야 함.
  // 하지만 questionsState.questions 자체가 이미 notifier 레벨에서 제한되어야 함.
  // 여기서 추가적인 sublist를 하는 것은 상태 불일치를 가릴 수 있음.
  // Notifier에서 questions 리스트 자체가 selectedLimit을 넘지 않도록 보장하는 것이 중요.

  if (questionsState.questions.isEmpty ||
      currentIndex >=
          questionsState
              .questions.length /* || currentIndex >= selectedLimit */) {
    // currentIndex가 selectedLimit을 넘는 경우는 퀴즈 완료로 처리되어야 함.
    // currentQuestionProvider는 유효한 질문 객체를 반환하거나 null을 반환.
    // isQuizCompletedProvider에서 이 제한을 주로 다룬다.
    return null;
  }
  return questionsState.questions[currentIndex];
});

final userResponsesProvider = StateProvider<Map<int, String>>((ref) => {});

// 전체 퀴즈(모든 페이지 포함)가 완료되었는지 여부
final isQuizCompletedProvider = Provider<bool>((ref) {
  final questionsState = ref.watch(questionsStateNotifierProvider);
  final currentIndex =
      ref.watch(currentQuestionIndexProvider); // 현재 Question 객체의 인덱스
  final currentPartType = ref.watch(currentQuestionPartTypeProvider);
  final selectedLimit =
      ref.watch(selectedQuestionLimitProvider); // 사용자가 선택한 문제 수

  if (questionsState.isLoading || questionsState.questions.isEmpty) {
    return false;
  }

  // 현재까지 푼 "파트"의 수를 계산
  int partsSolved = 0;
  for (int i = 0; i < currentIndex; i++) {
    partsSolved++; // Main idea part
    if (questionsState.questions[i].fillInTheBlankQuestion != null) {
      partsSolved++; // Fill in the blank part
    }
  }
  // 현재 문제의 파트 추가
  partsSolved++; // Current question's main idea part (or the only part if no fill-in-the-blank)
  if (currentPartType == QuestionPartType.fillInTheBlank &&
      currentIndex < questionsState.questions.length && // 유효한 인덱스인지 확인
      questionsState.questions[currentIndex].fillInTheBlankQuestion != null) {
    // 만약 현재 풀고 있는 것이 fill-in-the-blank 파트라면,
    // 위에서 main idea를 센 후 fill-in-the-blank를 위해 추가 카운트 된 것으로 본다.
    // 좀 더 정확히는: partsSolved는 다음 문제로 넘어가기 직전까지 푼 파트 수여야 함.
    // 다음 문제로 넘어가는 _onNextPressed 로직과 연관지어 생각해야 함.
    // 쉽게 생각하면: (현재 문제의 표시 번호) >= selectedLimit 이면 완료.
    // currentQuestionNumberDisplayProvider가 1부터 시작하므로,
    // currentQuestionNumberDisplayProvider > selectedLimit 이거나,
    // currentQuestionNumberDisplayProvider == selectedLimit 이고 현재 파트가 마지막 파트일 때.
  }

  // currentQuestionNumberDisplayProvider는 1부터 시작.
  final currentQuestionNumber = ref.watch(currentQuestionNumberDisplayProvider);

  if (currentQuestionNumber > selectedLimit) return true;

  // 만약 현재 로드된 질문 수가 selectedLimit보다 적고, 더 로드할 수 없다면,
  // (예: API에 총 7문제밖에 없는데 사용자가 10문제를 선택한 경우)
  // 현재까지 푼 문제 수가 로드된 문제의 총 파트 수와 같거나 크면 완료로 본다.
  if (currentQuestionNumber >= selectedLimit) {
    // selectedLimit 만큼 풀었으면 완료
    return true;
  }

  // 더 이상 로드할 질문이 없고 (canLoadMore is false),
  // 현재 질문 인덱스가 로드된 질문의 마지막을 가리키고,
  // 해당 질문의 마지막 파트까지 풀었다면 완료.
  // 이 조건은 selectedLimit보다 적은 수의 문제만 있을 때를 대비.
  if (!questionsState.canLoadMore &&
      currentIndex >= questionsState.questions.length - 1) {
    final currentQ = questionsState.questions[currentIndex];
    bool isLastPart = (currentPartType == QuestionPartType.fillInTheBlank) ||
        (currentPartType == QuestionPartType.mainIdea &&
            currentQ.fillInTheBlankQuestion == null);
    if (isLastPart) {
      // 로드된 모든 문제를 다 풀었는지 확인
      // 이 경우, selectedLimit에 도달하지 못했더라도 퀴즈는 "있는 문제를 다 푼" 상태.
      // "11/10" 문제와 별개로, 사용자가 선택한 N개를 다 풀었는지가 주 관심사.
      // 따라서 위 currentQuestionNumber >= selectedLimit 가 주요 조건이 되어야 함.
      // 아래는 API에 문제가 selectedLimit보다 적게 있는 특수 케이스.
      int totalAvailableParts = 0;
      for (var q_idx = 0; q_idx < questionsState.questions.length; q_idx++) {
        totalAvailableParts++;
        if (questionsState.questions[q_idx].fillInTheBlankQuestion != null) {
          totalAvailableParts++;
        }
      }
      if (currentQuestionNumber >= totalAvailableParts &&
          totalAvailableParts < selectedLimit) {
        return true;
      }
    }
  }

  // 주된 완료 조건: 현재 풀고 있는 문제 번호(1-based)가 선택된 문제 수를 초과하면 완료.
  // 또는, 선택된 문제 수에 도달했고, 현재 파트가 해당 문제의 마지막 파트일 때.
  // 그러나 _onNextPressed에서 다음 문제로 넘어가면서 currentQuestionNumberDisplayProvider가 업데이트 되므로,
  // 단순히 currentQuestionNumberDisplayProvider > selectedLimit 로도 충분할 수 있음.

  // 예를 들어 10문제 선택. 10번째 문제의 마지막 파트를 풀고 "다음"을 누르면
  // currentQuestionNumberDisplayProvider가 11이 되면서 isQuizCompleted가 true가 되어야 함.

  // 만약 fetchNextPage가 selectedLimit 이상으로 가져오지 않도록 수정되었다면,
  // questionsState.questions.length 는 selectedLimit을 넘지 않게 됨 (또는 API의 전체 문제 수가 selectedLimit보다 작은 경우 그 수).

  // 가장 간단한 조건: 현재까지 푼 문제 "파트"의 수가 selectedLimit과 같거나 크면 완료.
  // currentQuestionNumberDisplayProvider가 정확히 "푼 파트 수 + 1" (다음에 풀 파트 번호) 또는 "현재 풀고 있는 파트 번호"인지 확인 필요.
  // currentQuestionNumberDisplayProvider는 "현재 풀고 있는 문제 번호 (1부터 시작)" 임.

  // 다시 정의:
  // 1. isLoading 상태면 미완료.
  // 2. 에러 상태면 미완료 (사용자가 재시도할 수 있도록).
  // 3. 현재 문제 번호가 selectedLimit을 초과하면 완료.
  if (currentQuestionNumber > selectedLimit) {
    // 이전에 호출된 currentQuestion.hashCode에 대한 userResponse를 제거한 후,
    // 다음 문제로 넘어가거나 fetchNextPage()를 호출하기 직전에 이 상태가 true가 될 수 있어야 함.
    // _onNextPressed 로직에서 다음 문제로 넘어가기 전에 이 provider가 true가 되면,
    // "모든 문제를 다 푸셨습니다" 화면이 바로 떠야함.
    return true;
  }

  // 만약 API에 문제가 selectedLimit보다 적게 있고, 로드할 수 있는 문제를 모두 풀었다면 완료.
  int totalPartsInLoadedQuestions = 0;
  for (final question in questionsState.questions) {
    totalPartsInLoadedQuestions++; // main idea
    if (question.fillInTheBlankQuestion != null) {
      totalPartsInLoadedQuestions++; // fill in the blank
    }
  }

  if (!questionsState.canLoadMore && // 더 이상 API에서 가져올 문제가 없고
      questionsState.questions.isNotEmpty && // 로드된 질문이 있고
      currentQuestionNumber >= totalPartsInLoadedQuestions && // 로드된 모든 파트를 풀었고
      totalPartsInLoadedQuestions < selectedLimit) {
    // 그리고 그 수가 selectedLimit 보다 작다면
    return true;
  }

  return false; // 위의 조건에 해당하지 않으면 미완료
});

// 화면 상단에 표시될 전체 문항 수 (e.g., "총 50문제 중")
// 이 부분은 이전 커밋에서 selectedQuestionLimitProvider를 직접 사용하도록 UI에서 변경되었음.
// provider 자체는 API가 반환하는 전체 문제 수를 나타낼 수 있으나, UI 표시용으로는 selectedLimit이 맞음.
final totalQuestionCountDisplayProvider = Provider<int>((ref) {
  return ref.watch(selectedQuestionLimitProvider); // 사용자가 선택한 문제 수
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
