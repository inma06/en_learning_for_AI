import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NewsScreen extends ConsumerStatefulWidget {
  const NewsScreen({super.key});

  @override
  ConsumerState<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends ConsumerState<NewsScreen> {
  final List<Map<String, String>> _newsItems = [
    {
      'title': 'Breaking News: AI Technology Advances',
      'summary':
          'Recent developments in artificial intelligence are changing how we learn languages.',
      'date': '2024-03-20',
      'category': 'Technology',
    },
    {
      'title': 'New Study Shows Benefits of Daily Practice',
      'summary':
          'Research indicates that consistent language practice leads to better retention.',
      'date': '2024-03-19',
      'category': 'Education',
    },
    {
      'title': 'Language Learning Trends in 2024',
      'summary':
          'Discover the latest trends in language learning and how they affect students.',
      'date': '2024-03-18',
      'category': 'Trends',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implement filter functionality
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '뉴스 기반 영어 학습',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '최신 뉴스를 기반으로 한 영어 문제를 풀어보세요!',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.go('/news/quiz'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text(
                '퀴즈 시작하기',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
