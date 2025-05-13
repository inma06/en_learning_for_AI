import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_routes.dart';

class PracticeScreen extends ConsumerWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('연습하기'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildPracticeTypeCard(
            title: '말하기 연습',
            description: 'AI와 함께 영어 회화 연습하기',
            icon: Icons.mic,
            color: Colors.blue,
            onTap: () {
              context.push(AppRoutes.speakingPractice);
            },
          ),
          const SizedBox(height: 16),
          _buildPracticeTypeCard(
            title: '단어 연습',
            description: '효과적인 단어 암기와 복습',
            icon: Icons.book,
            color: Colors.purple,
            onTap: () {
              context.push(AppRoutes.vocabularyPractice);
            },
          ),
          const SizedBox(height: 16),
          _buildPracticeTypeCard(
            title: '듣기 연습',
            description: '영어 듣기 실력을 향상시켜보세요',
            icon: Icons.headphones,
            color: Colors.green,
            onTap: () {
              context.push(AppRoutes.listeningPractice);
            },
          ),
          const SizedBox(height: 16),
          _buildPracticeTypeCard(
            title: '쓰기 연습',
            description: 'AI가 첨삭해주는 영작문 연습',
            icon: Icons.edit,
            color: Colors.orange,
            onTap: () {
              context.push(AppRoutes.writingPractice);
            },
          ),
          const SizedBox(height: 24),
          _buildRecommendedPracticeSection(),
        ],
      ),
    );
  }

  Widget _buildPracticeTypeCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
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
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendedPracticeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '추천 연습',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildRecommendedPracticeCard(
          title: '일상 회화 마스터하기',
          description: '카페에서 주문하기, 길 묻기 등',
          difficulty: '초급',
          estimatedTime: '30분',
          onTap: () {
            // TODO: 추천 연습 화면으로 이동
          },
        ),
        const SizedBox(height: 12),
        _buildRecommendedPracticeCard(
          title: '비즈니스 이메일 작성',
          description: '공식적인 이메일 작성 방법 배우기',
          difficulty: '중급',
          estimatedTime: '45분',
          onTap: () {
            // TODO: 추천 연습 화면으로 이동
          },
        ),
      ],
    );
  }

  Widget _buildRecommendedPracticeCard({
    required String title,
    required String description,
    required String difficulty,
    required String estimatedTime,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
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
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildTag(difficulty),
                  const SizedBox(width: 8),
                  _buildTag(estimatedTime),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
