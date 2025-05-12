import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewsScreen extends ConsumerWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('뉴스 학습'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNewsCard(
            title: 'CNN 헤드라인',
            description: '최신 CNN 뉴스 헤드라인으로 영어 학습하기',
            icon: Icons.newspaper_rounded,
            onTap: () {
              // TODO: CNN 뉴스 화면으로 이동
            },
          ),
          const SizedBox(height: 16),
          _buildNewsCard(
            title: 'BBC 헤드라인',
            description: '최신 BBC 뉴스 헤드라인으로 영어 학습하기',
            icon: Icons.article_rounded,
            onTap: () {
              // TODO: BBC 뉴스 화면으로 이동
            },
          ),
          const SizedBox(height: 16),
          _buildNewsCard(
            title: 'Reuters 헤드라인',
            description: '최신 Reuters 뉴스 헤드라인으로 영어 학습하기',
            icon: Icons.description_rounded,
            onTap: () {
              // TODO: Reuters 뉴스 화면으로 이동
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Colors.blue,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey[400],
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
