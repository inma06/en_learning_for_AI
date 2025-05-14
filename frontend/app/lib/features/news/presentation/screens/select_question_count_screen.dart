import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:language_learning_app/features/news/domain/models/quiz_progress_state.dart';
import 'package:language_learning_app/features/news/presentation/providers/select_question_count_provider.dart';
import 'package:language_learning_app/features/news/presentation/screens/news_quiz_screen.dart';
import 'package:language_learning_app/features/news/presentation/providers/news_quiz_provider.dart';

class SelectQuestionCountScreen extends ConsumerStatefulWidget {
  const SelectQuestionCountScreen({super.key});

  @override
  ConsumerState<SelectQuestionCountScreen> createState() =>
      _SelectQuestionCountScreenState();
}

class _SelectQuestionCountScreenState
    extends ConsumerState<SelectQuestionCountScreen> {
  QuizProgressState? _savedProgress;
  Box<QuizProgressState>? _progressBox;
  bool _isLoadingInitialProgress = true; // 초기 Hive 로드 상태
  bool _isResumingQuiz = false; // 이어하기 버튼 클릭 후 로딩 상태

  @override
  void initState() {
    super.initState();
    _loadSavedProgress();
  }

  Future<void> _loadSavedProgress() async {
    if (!mounted) return;
    setState(() {
      _isLoadingInitialProgress = true;
    });
    _progressBox = await Hive.openBox<QuizProgressState>('quizProgressBox');
    if (mounted) {
      setState(() {
        _savedProgress = _progressBox!.get('currentProgress');
        _isLoadingInitialProgress = false;
      });
    }
  }

  Future<void> _clearSavedProgress() async {
    await _progressBox?.delete('currentProgress');
    if (mounted) {
      setState(() {
        _savedProgress = null;
      });
    }
  }

  void _startNewQuiz(BuildContext context, WidgetRef ref, int count) async {
    await _clearSavedProgress();
    ref.read(selectedQuestionLimitProvider.notifier).state = count;
    ref.read(currentQuestionIndexProvider.notifier).state = 0;
    ref.read(currentQuestionPartTypeProvider.notifier).state =
        QuestionPartType.mainIdea;
    ref.read(userResponsesProvider.notifier).state = {};
    // resetState는 내부적으로 fetchInitialQuestions를 호출 (새로운 limit으로)
    await ref.read(questionsStateNotifierProvider.notifier).resetState();

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const NewsQuizScreen()),
    );
  }

  // _resumeQuiz를 async로 변경하고, 데이터 로딩 후 화면 전환
  Future<void> _resumeQuiz(
      BuildContext context, WidgetRef ref, QuizProgressState progress) async {
    if (!mounted) return;
    setState(() {
      _isResumingQuiz = true;
    });

    try {
      ref.read(selectedQuestionLimitProvider.notifier).state =
          progress.selectedLimit;
      ref.read(currentQuestionIndexProvider.notifier).state =
          progress.questionDisplayIndex;
      ref.read(currentQuestionPartTypeProvider.notifier).state =
          progress.currentQuestionPartType;
      ref.read(userResponsesProvider.notifier).state = {}; // 이전 응답은 초기화

      // 데이터 로드가 완료될 때까지 기다림
      await ref
          .read(questionsStateNotifierProvider.notifier)
          .fetchQuestionsStartingFromPage(progress.currentPageForApi,
              progress.questionDisplayIndex, progress.selectedLimit);

      // 저장된 진행 상태는 이어풀기 후 삭제 (다음에 다시 이 화면으로 오면 새로 시작해야 함)
      await _clearSavedProgress();

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NewsQuizScreen()),
      );
    } catch (e) {
      // 에러 처리 (예: 사용자에게 메시지 표시)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('퀴즈를 이어오는데 실패했습니다: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isResumingQuiz = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<int> questionCounts = [10, 20, 30, 50, 100];

    return Scaffold(
      appBar: AppBar(
        title: const Text('퀴즈 설정'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_isLoadingInitialProgress)
                const Center(
                    child: CircularProgressIndicator(
                        semanticsLabel: '저장된 진행 확인 중...'))
              else if (_isResumingQuiz)
                const Center(
                    child: CircularProgressIndicator(
                        semanticsLabel: '퀴즈 이어가는 중...'))
              else ...[
                if (_savedProgress != null) ...[
                  const Text(
                    '이전에 풀던 문제가 있습니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('지난 문제 이어서 도전하기'),
                    onPressed: () => _resumeQuiz(context, ref, _savedProgress!),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    '새로운 퀴즈를 시작하려면 문항 수를 선택하세요.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                ],
                if (_savedProgress == null) // 저장된 진행 상황이 없을 때만 제목 표시
                  const Text(
                    '오늘은 몇 문항에 도전할까요?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                const SizedBox(height: 20),
                ...questionCounts.map((count) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      // _startNewQuiz도 async이므로 onPressed도 async로 만들 수 있으나, 버튼의 onPressed는 보통 void를 반환
                      // _startNewQuiz 내부에서 await을 하지만, 버튼 자체는 즉시 반응하는 것처럼 보임.
                      onPressed: () => _startNewQuiz(context, ref, count),
                      child: Text('$count문항 새로 시작'),
                    ),
                  );
                }).toList(),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
