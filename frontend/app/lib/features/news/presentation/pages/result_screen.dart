import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:confetti/confetti.dart';
import '../../domain/entities/question_entity.dart';

class ResultScreen extends StatefulWidget {
  final List<QuestionItem> questionItems;

  const ResultScreen({
    super.key,
    required this.questionItems,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));

    // 점수가 좋으면 축하 애니메이션 실행
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final score = _calculateScore();
      if (score >= 70) {
        _confettiController.play();
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  int _calculateScore() {
    final correctCount =
        widget.questionItems.where((item) => item.isCorrect == true).length;
    return ((correctCount / widget.questionItems.length) * 100).round();
  }

  int _getCorrectCount() {
    return widget.questionItems.where((item) => item.isCorrect == true).length;
  }

  int _getWrongCount() {
    return widget.questionItems.where((item) => item.isCorrect == false).length;
  }

  @override
  Widget build(BuildContext context) {
    final score = _calculateScore();
    final correctCount = _getCorrectCount();
    final wrongCount = _getWrongCount();
    final totalCount = widget.questionItems.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('채점 결과'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // 축하 애니메이션
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    particleDrag: 0.05,
                    emissionFrequency: 0.05,
                    numberOfParticles: 50,
                    gravity: 0.05,
                    shouldLoop: false,
                  ),
                ),

                // 점수 카드
                Card(
                  elevation: 8,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: _getScoreGradientColors(score),
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _getScoreIcon(score),
                          size: 80,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '$score점',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          _getScoreMessage(score),
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 통계 카드
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        '전체',
                        totalCount.toString(),
                        Icons.quiz,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatCard(
                        '정답',
                        correctCount.toString(),
                        Icons.check_circle,
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatCard(
                        '오답',
                        wrongCount.toString(),
                        Icons.cancel,
                        Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 문제별 상세 결과
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '문제별 결과',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 16),
                        ...widget.questionItems.asMap().entries.map(
                          (entry) {
                            final index = entry.key;
                            final item = entry.value;
                            return _buildQuestionResult(index + 1, item);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 액션 버튼들
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.go('/wrong-answers');
                        },
                        icon: const Icon(Icons.note_alt),
                        label: const Text(
                          '오답노트 보기',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onSecondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.go('/questions');
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text(
                          '다시 풀기',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          context.go('/');
                        },
                        icon: const Icon(Icons.home),
                        label: const Text(
                          '홈으로',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionResult(int number, QuestionItem item) {
    final isCorrect = item.isCorrect ?? false;
    final questionType = item.type == QuestionType.mainIdea ? '객관식' : '빈칸 채우기';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green[50] : Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCorrect ? Colors.green : Colors.red,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isCorrect ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      questionType,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const Spacer(),
                    Icon(
                      isCorrect ? Icons.check_circle : Icons.cancel,
                      color: isCorrect ? Colors.green : Colors.red,
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                if (item.userResponse != null) ...[
                  Text(
                    '선택: ${item.userResponse}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (!isCorrect) ...[
                    Text(
                      '정답: ${item.correctAnswer}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.green[700],
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getScoreGradientColors(int score) {
    if (score >= 90) {
      return [Colors.purple, Colors.pink];
    } else if (score >= 80) {
      return [Colors.blue, Colors.lightBlue];
    } else if (score >= 70) {
      return [Colors.green, Colors.lightGreen];
    } else if (score >= 60) {
      return [Colors.orange, Colors.amber];
    } else {
      return [Colors.red, Colors.redAccent];
    }
  }

  IconData _getScoreIcon(int score) {
    if (score >= 90) {
      return Icons.emoji_events;
    } else if (score >= 80) {
      return Icons.star;
    } else if (score >= 70) {
      return Icons.thumb_up;
    } else if (score >= 60) {
      return Icons.sentiment_satisfied;
    } else {
      return Icons.sentiment_dissatisfied;
    }
  }

  String _getScoreMessage(int score) {
    if (score >= 90) {
      return '완벽해요! 🏆';
    } else if (score >= 80) {
      return '훌륭해요! ⭐';
    } else if (score >= 70) {
      return '잘했어요! 👍';
    } else if (score >= 60) {
      return '좋아요! 😊';
    } else {
      return '다시 도전해보세요! 💪';
    }
  }
}
