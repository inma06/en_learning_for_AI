import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import '../../../../core/local_storage/hive_service.dart';
import '../../../../core/local_storage/wrong_answer_model.dart';
import '../../../news/domain/entities/question_entity.dart';
import '../widgets/wrong_answer_card.dart';

class WrongAnswersScreen extends StatefulWidget {
  const WrongAnswersScreen({super.key});

  @override
  State<WrongAnswersScreen> createState() => _WrongAnswersScreenState();
}

class _WrongAnswersScreenState extends State<WrongAnswersScreen> {
  final HiveService _hiveService = GetIt.instance<HiveService>();
  List<WrongAnswer> wrongAnswers = [];
  String sortBy = 'date'; // 'date', 'type', 'difficulty'
  bool isAscending = false;

  @override
  void initState() {
    super.initState();
    _loadWrongAnswers();
  }

  void _loadWrongAnswers() {
    setState(() {
      wrongAnswers = _hiveService.getAllWrongAnswers();
      _sortWrongAnswers();
    });
  }

  void _sortWrongAnswers() {
    switch (sortBy) {
      case 'date':
        wrongAnswers.sort((a, b) => isAscending
            ? a.wrongDate.compareTo(b.wrongDate)
            : b.wrongDate.compareTo(a.wrongDate));
        break;
      case 'type':
        wrongAnswers.sort((a, b) => isAscending
            ? a.questionType.compareTo(b.questionType)
            : b.questionType.compareTo(a.questionType));
        break;
      case 'difficulty':
        wrongAnswers.sort((a, b) {
          final aDifficulty = a.difficulty ?? 'unknown';
          final bDifficulty = b.difficulty ?? 'unknown';
          return isAscending
              ? aDifficulty.compareTo(bDifficulty)
              : bDifficulty.compareTo(aDifficulty);
        });
        break;
    }
  }

  void _deleteWrongAnswer(String questionId) async {
    await _hiveService.deleteWrongAnswer(questionId);
    _loadWrongAnswers();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('오답이 삭제되었습니다')),
      );
    }
  }

  void _clearAllWrongAnswers() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('모든 오답 삭제'),
        content: const Text('모든 오답을 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _hiveService.clearAllWrongAnswers();
      _loadWrongAnswers();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('모든 오답이 삭제되었습니다')),
        );
      }
    }
  }

  List<QuestionItem> _convertWrongAnswersToQuestionItems(
      List<WrongAnswer> wrongAnswersList) {
    return wrongAnswersList.map((wrongAnswer) {
      return QuestionItem(
        id: wrongAnswer.questionId,
        headline: wrongAnswer.headline,
        paragraph: wrongAnswer.paragraph,
        questionText: wrongAnswer.questionText,
        questionPrompt: wrongAnswer.questionPrompt,
        type: wrongAnswer.questionType == 'main_idea'
            ? QuestionType.mainIdea
            : QuestionType.fillInBlank,
        choices: wrongAnswer.choices,
        correctAnswer: wrongAnswer.correctAnswer,
        createdAt: wrongAnswer.createdAt,
        source: wrongAnswer.source,
        difficulty: wrongAnswer.difficulty,
      );
    }).toList();
  }

  void _retryWrongAnswers() {
    // 오답 문제들을 QuestionItem으로 변환
    final List<QuestionItem> questionItems =
        _convertWrongAnswersToQuestionItems(wrongAnswers);

    // 오답 문제 다시 풀기 라우팅 - extra 파라미터로 오답 문제들 전달
    context.go('/questions/wrong-answers', extra: questionItems);
  }

  void _retryWrongAnswer(WrongAnswer wrongAnswer) {
    // 개별 오답 문제를 QuestionItem으로 변환
    final List<QuestionItem> questionItems =
        _convertWrongAnswersToQuestionItems([wrongAnswer]);

    // 개별 오답 문제 다시 풀기
    context.go('/questions/wrong-answers', extra: questionItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('오답노트 (${wrongAnswers.length})'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'sort':
                  _showSortDialog();
                  break;
                case 'clear':
                  _clearAllWrongAnswers();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'sort',
                child: ListTile(
                  leading: Icon(Icons.sort),
                  title: Text('정렬'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'clear',
                child: ListTile(
                  leading: Icon(Icons.clear_all),
                  title: Text('모두 삭제'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: wrongAnswers.isEmpty
          ? _buildEmptyState()
          : Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: wrongAnswers.length,
                    itemBuilder: (context, index) {
                      final wrongAnswer = wrongAnswers[index];
                      return WrongAnswerCard(
                        wrongAnswer: wrongAnswer,
                        onDelete: () =>
                            _deleteWrongAnswer(wrongAnswer.questionId),
                        onRetry: () => _retryWrongAnswer(wrongAnswer),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: wrongAnswers.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _retryWrongAnswers,
              icon: const Icon(Icons.refresh),
              label: const Text('모두 다시 풀기'),
            )
          : null,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '틀린 문제가 없습니다!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '완벽한 성과네요! 계속해서 문제를 풀어보세요.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[500],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => context.go('/questions'),
            icon: const Icon(Icons.quiz),
            label: const Text('문제 풀러가기'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Row(
        children: [
          Expanded(
            child: Text(
              '총 ${wrongAnswers.length}개의 틀린 문제',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Text(
            _getSortText(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  String _getSortText() {
    String sortText = '';
    switch (sortBy) {
      case 'date':
        sortText = '날짜순';
        break;
      case 'type':
        sortText = '유형순';
        break;
      case 'difficulty':
        sortText = '난이도순';
        break;
    }
    return '$sortText ${isAscending ? '▲' : '▼'}';
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('정렬 방식'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('날짜순'),
              value: 'date',
              groupValue: sortBy,
              onChanged: (value) {
                setState(() {
                  sortBy = value!;
                  _sortWrongAnswers();
                });
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<String>(
              title: const Text('문제 유형순'),
              value: 'type',
              groupValue: sortBy,
              onChanged: (value) {
                setState(() {
                  sortBy = value!;
                  _sortWrongAnswers();
                });
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<String>(
              title: const Text('난이도순'),
              value: 'difficulty',
              groupValue: sortBy,
              onChanged: (value) {
                setState(() {
                  sortBy = value!;
                  _sortWrongAnswers();
                });
                Navigator.of(context).pop();
              },
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('오름차순'),
              value: isAscending,
              onChanged: (value) {
                setState(() {
                  isAscending = value;
                  _sortWrongAnswers();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }
}
