import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/word_list.dart';
import '../../domain/models/word.dart';
import '../../domain/services/vocabulary_service.dart';
import '../../domain/models/learning_report.dart';
import '../widgets/word_quiz.dart';
import '../screens/wrong_answers_screen.dart';

class VocabularyPracticeScreen extends ConsumerStatefulWidget {
  const VocabularyPracticeScreen({super.key});

  @override
  ConsumerState<VocabularyPracticeScreen> createState() =>
      _VocabularyPracticeScreenState();
}

class _VocabularyPracticeScreenState
    extends ConsumerState<VocabularyPracticeScreen> {
  WordList? _currentWordList;
  LearningReport? _learningReport;
  bool _isLoading = false;
  String? _errorMessage;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadWordList();
  }

  Future<void> _loadWordList() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // TODO: 백엔드 연동 시 실제 사용자의 단어장을 가져오도록 수정
      // 임시로 기본 단어장 사용
      _currentWordList = WordList(
        id: 'temp',
        title: '기본 단어장',
        description: '기본 단어 학습',
        words: [
          Word(
              id: '1',
              english: 'apple',
              korean: '사과',
              lastPracticed: DateTime.now()),
          Word(
              id: '2',
              english: 'banana',
              korean: '바나나',
              lastPracticed: DateTime.now()),
          Word(
              id: '3',
              english: 'orange',
              korean: '오렌지',
              lastPracticed: DateTime.now()),
          Word(
              id: '4',
              english: 'grape',
              korean: '포도',
              lastPracticed: DateTime.now()),
          Word(
              id: '5',
              english: 'strawberry',
              korean: '딸기',
              lastPracticed: DateTime.now()),
          Word(
              id: '6',
              english: 'book',
              korean: '책',
              lastPracticed: DateTime.now()),
          Word(
              id: '7',
              english: 'pencil',
              korean: '연필',
              lastPracticed: DateTime.now()),
          Word(
              id: '8',
              english: 'eraser',
              korean: '지우개',
              lastPracticed: DateTime.now()),
          Word(
              id: '9',
              english: 'ruler',
              korean: '자',
              lastPracticed: DateTime.now()),
          Word(
              id: '10',
              english: 'school',
              korean: '학교',
              lastPracticed: DateTime.now()),
          Word(
              id: '11',
              english: 'teacher',
              korean: '선생님',
              lastPracticed: DateTime.now()),
          Word(
              id: '12',
              english: 'student',
              korean: '학생',
              lastPracticed: DateTime.now()),
          Word(
              id: '13',
              english: 'friend',
              korean: '친구',
              lastPracticed: DateTime.now()),
          Word(
              id: '14',
              english: 'mother',
              korean: '엄마',
              lastPracticed: DateTime.now()),
          Word(
              id: '15',
              english: 'father',
              korean: '아빠',
              lastPracticed: DateTime.now()),
          Word(
              id: '16',
              english: 'sister',
              korean: '자매',
              lastPracticed: DateTime.now()),
          Word(
              id: '17',
              english: 'brother',
              korean: '형제',
              lastPracticed: DateTime.now()),
          Word(
              id: '18',
              english: 'house',
              korean: '집',
              lastPracticed: DateTime.now()),
          Word(
              id: '19',
              english: 'room',
              korean: '방',
              lastPracticed: DateTime.now()),
          Word(
              id: '20',
              english: 'door',
              korean: '문',
              lastPracticed: DateTime.now()),
          Word(
              id: '21',
              english: 'window',
              korean: '창문',
              lastPracticed: DateTime.now()),
          Word(
              id: '22',
              english: 'chair',
              korean: '의자',
              lastPracticed: DateTime.now()),
          Word(
              id: '23',
              english: 'table',
              korean: '책상',
              lastPracticed: DateTime.now()),
          Word(
              id: '24',
              english: 'bed',
              korean: '침대',
              lastPracticed: DateTime.now()),
          Word(
              id: '25',
              english: 'clock',
              korean: '시계',
              lastPracticed: DateTime.now()),
          Word(
              id: '26',
              english: 'phone',
              korean: '전화',
              lastPracticed: DateTime.now()),
          Word(
              id: '27',
              english: 'computer',
              korean: '컴퓨터',
              lastPracticed: DateTime.now()),
          Word(
              id: '28',
              english: 'television',
              korean: '텔레비전',
              lastPracticed: DateTime.now()),
          Word(
              id: '29',
              english: 'radio',
              korean: '라디오',
              lastPracticed: DateTime.now()),
          Word(
              id: '30',
              english: 'camera',
              korean: '카메라',
              lastPracticed: DateTime.now()),
          Word(
              id: '31',
              english: 'dog',
              korean: '개',
              lastPracticed: DateTime.now()),
          Word(
              id: '32',
              english: 'cat',
              korean: '고양이',
              lastPracticed: DateTime.now()),
          Word(
              id: '33',
              english: 'bird',
              korean: '새',
              lastPracticed: DateTime.now()),
          Word(
              id: '34',
              english: 'fish',
              korean: '물고기',
              lastPracticed: DateTime.now()),
          Word(
              id: '35',
              english: 'rabbit',
              korean: '토끼',
              lastPracticed: DateTime.now()),
          Word(
              id: '36',
              english: 'tiger',
              korean: '호랑이',
              lastPracticed: DateTime.now()),
          Word(
              id: '37',
              english: 'lion',
              korean: '사자',
              lastPracticed: DateTime.now()),
          Word(
              id: '38',
              english: 'elephant',
              korean: '코끼리',
              lastPracticed: DateTime.now()),
          Word(
              id: '39',
              english: 'monkey',
              korean: '원숭이',
              lastPracticed: DateTime.now()),
          Word(
              id: '40',
              english: 'bear',
              korean: '곰',
              lastPracticed: DateTime.now()),
          Word(
              id: '41',
              english: 'red',
              korean: '빨간색',
              lastPracticed: DateTime.now()),
          Word(
              id: '42',
              english: 'blue',
              korean: '파란색',
              lastPracticed: DateTime.now()),
          Word(
              id: '43',
              english: 'yellow',
              korean: '노란색',
              lastPracticed: DateTime.now()),
          Word(
              id: '44',
              english: 'green',
              korean: '초록색',
              lastPracticed: DateTime.now()),
          Word(
              id: '45',
              english: 'white',
              korean: '흰색',
              lastPracticed: DateTime.now()),
          Word(
              id: '46',
              english: 'black',
              korean: '검은색',
              lastPracticed: DateTime.now()),
          Word(
              id: '47',
              english: 'one',
              korean: '1',
              lastPracticed: DateTime.now()),
          Word(
              id: '48',
              english: 'two',
              korean: '2',
              lastPracticed: DateTime.now()),
          Word(
              id: '49',
              english: 'three',
              korean: '3',
              lastPracticed: DateTime.now()),
          Word(
              id: '50',
              english: 'four',
              korean: '4',
              lastPracticed: DateTime.now()),
        ],
        createdAt: DateTime.now(),
        lastStudied: DateTime.now(),
      );

      // 마스터 상태 로드
      await ref
          .read(vocabularyServiceProvider)
          .loadMasteredStatus(_currentWordList!);

      // 학습 보고서 생성
      if (_currentWordList != null) {
        _learningReport = await ref
            .read(vocabularyServiceProvider)
            .generateLearningReport(_currentWordList!);
      }
    } catch (e) {
      setState(() {
        _errorMessage = '단어장을 불러오는 중 오류가 발생했습니다: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onQuizComplete(bool isCorrect) {
    // 정답을 맞췄을 때 다음 단어로 자동 스크롤
    if (isCorrect && _currentWordList != null) {
      final currentIndex = _currentWordList!.words.indexWhere((w) =>
          w.id ==
          _currentWordList!
              .words[
                  _scrollController.offset ~/ MediaQuery.of(context).size.width]
              .id);
      if (currentIndex < _currentWordList!.words.length - 1) {
        _scrollController.animateTo(
          (currentIndex + 1) * MediaQuery.of(context).size.width,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        // 마지막 단어를 풀었을 때 결과 화면 표시
        _showCompletionDialog();
      }
    }
  }

  void _showCompletionDialog() {
    if (_currentWordList == null) return;

    final correctCount =
        _currentWordList!.words.where((w) => w.isMastered).length;
    final wrongCount =
        _currentWordList!.words.where((w) => w.wrongCount > 0).length;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '모두 풀었습니다!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildResultItem(
                    '맞춘 단어',
                    correctCount.toString(),
                    Colors.green,
                    Icons.check_circle,
                  ),
                  _buildResultItem(
                    '틀린 단어',
                    wrongCount.toString(),
                    Colors.red,
                    Icons.cancel,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _loadWordList(); // 단어장 새로고침
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '다시 시작',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // 결과 화면 닫기
                      Navigator.of(context).pop(); // 학습 화면 닫기
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '종료',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultItem(
      String title, String count, Color color, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 48,
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          count,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  void _showLearningReport() {
    if (_learningReport == null) return;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '학습 보고서',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
              const SizedBox(height: 24),
              _buildReportItem(
                '전체 단어 수',
                '${_learningReport!.totalWords}개',
                Icons.format_list_numbered,
                Colors.blue,
              ),
              const SizedBox(height: 16),
              _buildReportItem(
                '마스터한 단어',
                '${_learningReport!.masteredWords}개',
                Icons.check_circle,
                Colors.green,
              ),
              const SizedBox(height: 16),
              _buildReportItem(
                '평균 정확도',
                '${(_learningReport!.averageAccuracy * 100).toStringAsFixed(1)}%',
                Icons.analytics,
                Colors.orange,
              ),
              const SizedBox(height: 24),
              if (_learningReport!.recommendedWords.isNotEmpty) ...[
                Text(
                  '추천 단어',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _learningReport!.recommendedWords.map((word) {
                    return Chip(
                      label: Text(word),
                      backgroundColor: Colors.blue[50],
                      labelStyle: TextStyle(color: Colors.blue[900]),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '확인',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportItem(
      String title, String value, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showMasteredWordsDialog() {
    if (_currentWordList == null) return;

    final masteredWords =
        _currentWordList!.words.where((w) => w.isMastered).toList();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          height: 400,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '마스터한 단어',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: masteredWords.length,
                  itemBuilder: (context, index) {
                    final word = masteredWords[index];
                    return ListTile(
                      title: Text(word.english),
                      subtitle: Text(word.korean),
                      dense: true,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _loadWordList,
                  child: const Text('다시 시도'),
                ),
              ],
            ),
          ],
        ),
      );
    }

    if (_currentWordList == null) {
      return const Center(
        child: Text('단어장을 불러올 수 없습니다.'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('단어 학습'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: _showLearningReport,
            tooltip: '학습 보고서',
          ),
          IconButton(
            icon: const Icon(Icons.book),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WrongAnswersScreen(),
                ),
              );
            },
            tooltip: '오답노트',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadWordList,
            tooltip: '단어장 새로고침',
          ),
        ],
      ),
      body: Column(
        children: [
          // 진행 상황 표시
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: _showMasteredWordsDialog,
                  icon: const Icon(Icons.star, color: Colors.amber),
                  label: Text(
                    '마스터한 단어: ${_currentWordList!.words.where((w) => w.isMastered).length}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 단어 퀴즈 가로 스크롤 뷰
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: _currentWordList!.words.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        WordQuiz(
                          word: _currentWordList!.words[index],
                          onComplete: _onQuizComplete,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_currentWordList != null) {
                              // 현재 단어를 오답으로 표시
                              final currentIndex = (_scrollController.offset /
                                      MediaQuery.of(context).size.width)
                                  .round();
                              final currentWord =
                                  _currentWordList!.words[currentIndex];
                              currentWord.wrongCount++;
                              currentWord.isMastered = false;

                              // 다음 단어로 이동
                              if (currentIndex <
                                  _currentWordList!.words.length - 1) {
                                _scrollController.animateTo(
                                  (currentIndex + 1) *
                                      MediaQuery.of(context).size.width,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              } else {
                                _showCompletionDialog();
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('다음 문제(통과)'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
