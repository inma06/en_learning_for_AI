import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/wrong_answer.dart';
import '../../domain/services/vocabulary_service.dart';

class WrongAnswersScreen extends ConsumerStatefulWidget {
  const WrongAnswersScreen({super.key});

  @override
  ConsumerState<WrongAnswersScreen> createState() => _WrongAnswersScreenState();
}

class _WrongAnswersScreenState extends ConsumerState<WrongAnswersScreen> {
  List<WrongAnswer> _wrongAnswers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWrongAnswers();
  }

  Future<void> _loadWrongAnswers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final wrongAnswers =
          await ref.read(vocabularyServiceProvider).getWrongAnswers();
      setState(() {
        _wrongAnswers = wrongAnswers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('오답노트를 불러오는 중 오류가 발생했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('오답노트'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<List<WrongAnswer>>(
        future: ref.read(vocabularyServiceProvider).getWrongAnswers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('오류가 발생했습니다: ${snapshot.error}'),
            );
          }

          final wrongAnswers = snapshot.data ?? [];

          if (wrongAnswers.isEmpty) {
            return const Center(
              child: Text('틀린 단어가 없습니다.'),
            );
          }

          return ListView.builder(
            itemCount: wrongAnswers.length,
            itemBuilder: (context, index) {
              final wrongAnswer = wrongAnswers[index];
              return ListTile(
                title: Text(wrongAnswer.english),
                subtitle: Text(wrongAnswer.korean),
                trailing: Text('틀린 횟수: ${wrongAnswer.wrongCount}'),
              );
            },
          );
        },
      ),
    );
  }
}
