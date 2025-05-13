import 'package:flutter/material.dart';
import '../models/question.dart';
import '../services/api_service.dart';
import '../widgets/quiz_card.dart';
import '../widgets/filter_drawer.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final ApiService _apiService = ApiService();
  List<Question> _questions = [];
  bool _isLoading = false;
  String? _error;
  String _selectedDifficulty = 'all';
  String _selectedCategory = 'all';
  int _currentPage = 1;
  final int _limit = 10;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        _currentPage = 1;
        _hasMore = true;
        _questions = [];
      });
    }

    if (!_hasMore || _isLoading) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await _apiService.getQuestions(
        page: _currentPage,
        limit: _limit,
        difficulty: _selectedDifficulty != 'all' ? _selectedDifficulty : null,
        category: _selectedCategory != 'all' ? _selectedCategory : null,
      );

      setState(() {
        _questions.addAll(result.questions);
        _hasMore = _currentPage < result.totalPages;
        _currentPage++;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _submitAnswer(Question question, String answer) async {
    try {
      final isCorrect = answer == question.answer;
      await _apiService.submitAnswer(
        questionId: question.headline,
        answer: answer,
        isCorrect: isCorrect,
      );

      setState(() {
        final index =
            _questions.indexWhere((q) => q.headline == question.headline);
        if (index != -1) {
          _questions[index] = question.copyWith(
            userResponse: answer,
            isCorrect: isCorrect,
          );
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('답변 제출 중 오류가 발생했습니다: $e')),
      );
    }
  }

  void _applyFilters(String difficulty, String category) {
    setState(() {
      _selectedDifficulty = difficulty;
      _selectedCategory = category;
    });
    _loadQuestions(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('영어 학습 문제'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: FilterDrawer(
        selectedDifficulty: _selectedDifficulty,
        selectedCategory: _selectedCategory,
        onApplyFilters: _applyFilters,
      ),
      body: RefreshIndicator(
        onRefresh: () => _loadQuestions(refresh: true),
        child: _error != null
            ? Center(child: Text('오류: $_error'))
            : ListView.builder(
                itemCount: _questions.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _questions.length) {
                    if (_isLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }

                  final question = _questions[index];
                  return QuizCard(
                    question: question,
                    onSubmitAnswer: _submitAnswer,
                  );
                },
              ),
      ),
    );
  }
}
