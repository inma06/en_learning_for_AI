import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/word.dart';
import '../../domain/services/vocabulary_service.dart';

enum QuizType {
  meaningToWord, // 뜻을 보고 단어 맞추기
  wordToMeaning, // 단어를 보고 뜻 맞추기
}

class WordQuiz extends ConsumerStatefulWidget {
  final Word word;
  final Function(bool) onComplete;

  const WordQuiz({
    super.key,
    required this.word,
    required this.onComplete,
  });

  @override
  ConsumerState<WordQuiz> createState() => _WordQuizState();
}

class _WordQuizState extends ConsumerState<WordQuiz> {
  final TextEditingController _answerController = TextEditingController();
  bool _isCorrect = false;
  bool _isAnswered = false;
  String? _userAnswer;
  bool _showHint = false;
  late QuizType _quizType;

  @override
  void initState() {
    super.initState();
    // 랜덤하게 퀴즈 타입 선택
    _quizType = QuizType.values[DateTime.now().millisecondsSinceEpoch % 2];
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  String _getHint(String word) {
    if (word.length <= 2) return word[0] + '*';
    return word.substring(0, 2) + '*' * (word.length - 2);
  }

  void _checkAnswer() {
    final userAnswer = _answerController.text.trim().toLowerCase();
    final correctAnswer = _quizType == QuizType.meaningToWord
        ? widget.word.english.toLowerCase()
        : widget.word.korean.toLowerCase();
    final isCorrect = userAnswer == correctAnswer;

    setState(() {
      _isCorrect = isCorrect;
      _isAnswered = true;
      _userAnswer = userAnswer;
    });

    // 단어 학습 진행 상황 업데이트
    ref.read(vocabularyServiceProvider).updateWordProgress(
          widget.word,
          isCorrect,
          userAnswer: userAnswer,
        );

    // 정답을 맞췄을 때만 마스터 상태 업데이트
    if (isCorrect) {
      final updatedWord = widget.word.copyWith(
        isMastered: true,
        accuracy: 1.0,
      );
      // TODO: 백엔드 연동 시 실제 API 호출로 대체
    }

    widget.onComplete(isCorrect);
  }

  void _retry() {
    setState(() {
      _isAnswered = false;
      _answerController.clear();
      _showHint = false;
    });
  }

  void _pass() {
    ref.read(vocabularyServiceProvider).updateWordProgress(
          widget.word,
          false,
          userAnswer: _userAnswer,
        );
    widget.onComplete(false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _quizType == QuizType.meaningToWord
                ? '다음 뜻을 가진 단어를 입력하세요:'
                : '다음 단어의 뜻을 입력하세요:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _quizType == QuizType.meaningToWord
                  ? widget.word.korean
                  : widget.word.english,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (!_isAnswered) ...[
            TextField(
              controller: _answerController,
              decoration: InputDecoration(
                hintText: _quizType == QuizType.meaningToWord
                    ? '영어 단어를 입력하세요'
                    : '한글 뜻을 입력하세요',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _checkAnswer(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _checkAnswer,
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
                '정답 확인',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isCorrect ? Colors.green[50] : Colors.red[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    _isCorrect ? Icons.check_circle : Icons.cancel,
                    color: _isCorrect ? Colors.green : Colors.red,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _isCorrect ? '정답입니다!' : '틀렸습니다.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _isCorrect ? Colors.green[900] : Colors.red[900],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (!_isCorrect && _userAnswer != null) ...[
              Text(
                '입력한 답: $_userAnswer',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 16),
              if (!_showHint) ...[
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showHint = true;
                    });
                  },
                  child: const Text('힌트 보기'),
                ),
              ] else ...[
                Text(
                  '힌트: ${_getHint(_quizType == QuizType.meaningToWord ? widget.word.english : widget.word.korean)}',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _retry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }
}
