import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Hive 사용을 위해 추가
import 'package:intl/intl.dart'; // 날짜 포맷팅을 위해 intl 패키지 임포트
import 'package:language_learning_app/features/news/domain/models/question.dart'; // Question 모델 import
import 'package:language_learning_app/features/news/presentation/providers/news_quiz_provider.dart';
import 'package:language_learning_app/features/news/domain/models/quiz_progress_state.dart'; // QuizProgressState 임포트
import 'package:language_learning_app/features/news/presentation/providers/select_question_count_provider.dart'; // selectedQuestionLimitProvider 임포트

// ConsumerStatefulWidget으로 변경 이유: 앱 라이프사이클(예: 백그라운드 전환) 감지 및 퀴즈 상태 저장을 위해 WidgetsBindingObserver를 사용하기 위함.
class NewsQuizScreen extends ConsumerStatefulWidget {
  const NewsQuizScreen({super.key});

  @override
  ConsumerState<NewsQuizScreen> createState() => _NewsQuizScreenState();
}

class _NewsQuizScreenState extends ConsumerState<NewsQuizScreen>
    with WidgetsBindingObserver {
  // WidgetsBindingObserver mixin

  Box<QuizProgressState>? _progressBox;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _openBox(); // Hive Box 열기
  }

  Future<void> _openBox() async {
    _progressBox = await Hive.openBox<QuizProgressState>('quizProgressBox');
    // Box가 열린 후 초기 상태 로드 또는 UI 업데이트가 필요하다면 여기서 수행
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // _progressBox?.close(); // 앱 전체에서 하나의 Box 인스턴스를 계속 사용할 것이라면 닫지 않을 수도 있음. 앱 종료 시 자동으로 닫힘.
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _saveProgress();
    }
  }

  Future<void> _saveProgress() async {
    if (_progressBox == null || !(_progressBox?.isOpen ?? false))
      return; // Box가 열려있지 않으면 저장하지 않음

    final isCompleted = ref.read(isQuizCompletedProvider);
    if (isCompleted) {
      await _progressBox!.delete('currentProgress');
      print("퀴즈 완료. 진행 상황 삭제됨.");
      return;
    }

    final currentQuestion = ref.read(currentQuestionProvider);
    if (currentQuestion == null) return; // 현재 질문이 없으면 저장하지 않음

    final questionId = currentQuestion.id;
    final displayIndex = ref.read(currentQuestionIndexProvider);
    final partType = ref.read(currentQuestionPartTypeProvider);
    final currentPage = ref.read(questionsStateNotifierProvider).currentPage;
    final limit = ref.read(selectedQuestionLimitProvider);

    final progress = QuizProgressState(
      questionId: questionId,
      questionDisplayIndex: displayIndex,
      currentQuestionPartTypeString: partType.toString(),
      currentPageForApi: currentPage == 0
          ? 1
          : currentPage, // API 페이지는 1부터 시작, 0이면 초기 로드 전일 수 있으므로 1로 보정
      selectedLimit: limit,
      lastSavedAt: DateTime.now(),
    );

    await _progressBox!.put('currentProgress', progress);
    print(
        "퀴즈 진행 상황 저장됨: ${progress.questionId}, Index: ${progress.questionDisplayIndex}, Part: ${progress.currentQuestionPartTypeString}, API Page: ${progress.currentPageForApi}");
  }

  // 피드백 다이얼로그 표시 함수 (이제는 _NewsQuizScreenState의 메소드)
  Future<void> _showFeedbackDialog(BuildContext context,
      Question currentQuestion, String correctAnswer, String userAnswer) async {
    final bool isCorrect = userAnswer == correctAnswer;
    final String title = isCorrect ? '정답입니다!' : '틀렸습니다.';
    final String contentMessage =
        isCorrect ? '훌륭해요! 다음 문제로 진행하세요.' : '아쉽네요. 정답은 "$correctAnswer" 입니다.';

    // '다음' 버튼 로직
    _onNextPressed() {
      Navigator.of(context).pop(); // 다이얼로그 닫기

      // userResponsesProvider는 build 메소드 내 ref를 사용하므로 여기서 직접 접근
      final userResponses = ref.read(userResponsesProvider.notifier).state;
      ref.read(userResponsesProvider.notifier).state = {
        ...userResponses,
      }..remove(currentQuestion.hashCode);

      final questionsState = ref.read(questionsStateNotifierProvider);
      final currentPartType = ref.read(currentQuestionPartTypeProvider);
      final currentIndex = ref.read(currentQuestionIndexProvider);
      final questionsNotifier =
          ref.read(questionsStateNotifierProvider.notifier);

      if (currentPartType == QuestionPartType.mainIdea &&
          currentQuestion.fillInTheBlankQuestion != null) {
        ref.read(currentQuestionPartTypeProvider.notifier).state =
            QuestionPartType.fillInTheBlank;
      } else {
        ref.read(currentQuestionPartTypeProvider.notifier).state =
            QuestionPartType.mainIdea;
        final nextIndex = currentIndex + 1;
        if (nextIndex < questionsState.questions.length) {
          ref.read(currentQuestionIndexProvider.notifier).state = nextIndex;
        } else if (questionsState.canLoadMore) {
          questionsNotifier.fetchNextPage();
        }
      }
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: SelectableText(title),
          content: SelectableText(contentMessage),
          actions: <Widget>[
            TextButton(
              child: const Text('다음'),
              onPressed: _onNextPressed,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // ConsumerStatefulWidget은 build 메소드에서 WidgetRef를 직접 받지 않음. `ref`는 클래스 멤버로 사용.
    final questionsState = ref.watch(questionsStateNotifierProvider);
    final currentQuestion = ref.watch(currentQuestionProvider);
    final userResponses = ref.watch(userResponsesProvider);
    final isQuizOverallCompleted = ref.watch(isQuizCompletedProvider);
    final currentPartType = ref.watch(currentQuestionPartTypeProvider);

    final currentQuestionNumber =
        ref.watch(currentQuestionNumberDisplayProvider);
    final totalQuestionsCount = ref.watch(selectedQuestionLimitProvider);

    Widget bodyContent = const Center(
        child: CircularProgressIndicator(semanticsLabel: '콘텐츠 로딩 중...'));

    if (questionsState.isLoading && questionsState.questions.isEmpty) {
      // bodyContent는 이미 기본 로딩 인디케이터로 설정됨, 그대로 두거나 좀 더 구체적인 로딩으로 변경 가능
      // bodyContent = const Center(child: CircularProgressIndicator(semanticsLabel: '초기 질문 로딩 중...'));
    } else if (questionsState.error != null &&
        questionsState.questions.isEmpty) {
      bodyContent = Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 60),
              const SizedBox(height: 20),
              SelectableText('데이터를 불러오는데 실패했습니다.\n${questionsState.error}',
                  textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('다시 시도'),
                onPressed: () => ref
                    .read(questionsStateNotifierProvider.notifier)
                    .fetchInitialQuestions(),
              ),
            ],
          ),
        ),
      );
    } else if (questionsState.questions.isEmpty && !questionsState.isLoading) {
      bodyContent = const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: SelectableText(
            '오늘 풀 수 있는 새로운 문제가 없습니다.\n나중에 다시 확인해주세요.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
      );
    } else if (isQuizOverallCompleted) {
      bodyContent = const Center(
        child: SelectableText(
          '모든 문제를 다 푸셨습니다! 대단해요!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      );
    } else if (currentQuestion == null) {
      bodyContent = const Center(
          child: CircularProgressIndicator(semanticsLabel: '다음 질문 준비 중...'));
    } else {
      dynamic currentQuestionPart;
      String questionText = "";
      List<String> choices = [];
      String correctAnswer = "";
      String? displayTextForContext;
      String? currentQuestionDifficulty; // 현재 질문의 난이도를 저장할 변수

      if (currentPartType == QuestionPartType.mainIdea &&
          currentQuestion.mainIdeaQuestion != null) {
        currentQuestionPart = currentQuestion.mainIdeaQuestion!;
        questionText = currentQuestionPart.question;
        choices = currentQuestionPart.choices;
        correctAnswer = currentQuestionPart.answer;
        displayTextForContext = currentQuestion.paragraph;
        currentQuestionDifficulty = currentQuestionPart.difficulty; // 난이도 가져오기
      } else if (currentPartType == QuestionPartType.fillInTheBlank &&
          currentQuestion.fillInTheBlankQuestion != null) {
        currentQuestionPart = currentQuestion.fillInTheBlankQuestion!;
        displayTextForContext = currentQuestionPart.questionTextWithBlank;
        questionText = currentQuestionPart.questionPrompt;
        choices = currentQuestionPart.choices;
        correctAnswer = currentQuestionPart.answer;
        currentQuestionDifficulty = currentQuestionPart.difficulty; // 난이도 가져오기
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!questionsState.isLoadingMore && currentQuestion != null) {
            ref
                .read(userResponsesProvider.notifier)
                .state
                .remove(currentQuestion.hashCode);
            ref.read(currentQuestionPartTypeProvider.notifier).state =
                QuestionPartType.mainIdea;
            final currentIndex =
                ref.read(currentQuestionIndexProvider.notifier).state;
            final questionsNotifier =
                ref.read(questionsStateNotifierProvider.notifier);
            if (currentIndex + 1 >= questionsState.questions.length &&
                questionsState.canLoadMore) {
              questionsNotifier.fetchNextPage();
            } else if (currentIndex + 1 < questionsState.questions.length) {
              ref.read(currentQuestionIndexProvider.notifier).state++;
            }
          }
        });
        bodyContent =
            const Center(child: Text("현재 질문 파트를 불러올 수 없습니다. 다음 문제로 이동합니다..."));
      }

      if (currentQuestionPart != null) {
        final userResponseForCurrentQuestion =
            userResponses[currentQuestion.hashCode];
        final bool isThisQuestionAnswered =
            userResponseForCurrentQuestion != null;
        final newsDateFormatted =
            DateFormat('yyyy년 MM월').format(currentQuestion.createdAt.toLocal());

        bodyContent = Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SelectableText(
                          '출처 : $newsDateFormatted${currentQuestion.source != null && currentQuestion.source!.isNotEmpty ? " ${currentQuestion.source}" : ""}',
                          style: Theme.of(context).textTheme.bodySmall),
                      if (totalQuestionsCount > 0)
                        SelectableText(
                          '$currentQuestionNumber / $totalQuestionsCount',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                    ],
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectableText(currentQuestion.headline,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        if (displayTextForContext != null &&
                            displayTextForContext.isNotEmpty) ...[
                          SelectableText(displayTextForContext,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey[700])),
                          const SizedBox(height: 20),
                          const Divider(),
                          const SizedBox(height: 20),
                        ],
                        SelectableText(questionText,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500)),
                        if (currentQuestionDifficulty != null &&
                            currentQuestionDifficulty.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          SelectableText(
                              '난이도 : ${currentQuestionDifficulty[0].toUpperCase()}${currentQuestionDifficulty.substring(1)}', // 첫 글자 대문자로 표시
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blueGrey[700],
                                  fontStyle: FontStyle.italic)),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ...choices.map((choice) {
                  final isSelected = userResponseForCurrentQuestion == choice;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ElevatedButton(
                      onPressed: isThisQuestionAnswered
                          ? null
                          : () {
                              ref.read(userResponsesProvider.notifier).state = {
                                ...userResponses,
                                currentQuestion.hashCode: choice,
                              };
                              _showFeedbackDialog(context, currentQuestion,
                                  correctAnswer, choice);
                            },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: isThisQuestionAnswered
                              ? (isSelected
                                  ? (userResponseForCurrentQuestion ==
                                          correctAnswer
                                      ? Colors.green.shade100
                                      : Colors.red.shade100)
                                  : null)
                              : null,
                          padding: const EdgeInsets.all(16)),
                      child: Text(choice),
                    ),
                  );
                }).toList(),
                if (questionsState.isLoadingMore) ...[
                  const SizedBox(height: 20),
                  const Center(
                      child: CircularProgressIndicator(
                          semanticsLabel: "다음 페이지 문제 로딩 중")),
                  const SizedBox(height: 20),
                ]
              ],
            ),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('뉴스 퀴즈'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(currentQuestionIndexProvider.notifier).state = 0;
              ref.read(currentQuestionPartTypeProvider.notifier).state =
                  QuestionPartType.mainIdea;
              ref.read(userResponsesProvider.notifier).state = {};
              ref.read(questionsStateNotifierProvider.notifier).resetState();
            },
            tooltip: '퀴즈 초기화',
          )
        ],
      ),
      body: bodyContent,
    );
  }
}
