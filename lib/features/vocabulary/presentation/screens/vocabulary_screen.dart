import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/word.dart';
import '../../domain/models/word_list.dart';
import '../../domain/services/vocabulary_service.dart';
import '../widgets/word_quiz.dart';

class VocabularyScreen extends ConsumerStatefulWidget {
  const VocabularyScreen({super.key});

  @override
  ConsumerState<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends ConsumerState<VocabularyScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<Word> _words = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  Future<void> _loadWords() async {
    // TODO: 백엔드 연동 시 실제 단어장 데이터를 가져오도록 수정
    setState(() {
      _words.clear();
      // 100개의 임시 단어 데이터 생성
      for (int i = 1; i <= 100; i++) {
        _words.add(
          Word(
            id: i.toString(),
            english: 'Word $i',
            korean: '단어 $i',
            lastPracticed: DateTime.now(),
          ),
        );
      }
      _isLoading = false;
    });
  }

  void _onQuizComplete(bool isCorrect) {
    // 정답을 맞췄을 때 다음 단어로 자동 스크롤
    if (isCorrect) {
      final currentIndex = _words.indexWhere((w) =>
          w.id ==
          _words[_scrollController.offset ~/ MediaQuery.of(context).size.width]
              .id);
      if (currentIndex < _words.length - 1) {
        _scrollController.animateTo(
          (currentIndex + 1) * MediaQuery.of(context).size.width,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('단어 학습'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadWords,
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
                Text(
                  '마스터한 단어: ${_words.where((w) => w.isMastered).length}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
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
              itemCount: _words.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: WordQuiz(
                      word: _words[index],
                      onComplete: _onQuizComplete,
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
