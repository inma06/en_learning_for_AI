import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: 설정 화면으로 이동
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildProfileHeader(authState.userName ?? '사용자'),
          const SizedBox(height: 24),
          _buildStatsCard(),
          const SizedBox(height: 24),
          _buildMenuSection(ref),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(String userName) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey[200],
          child: Text(
            userName[0],
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          userName,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '학습을 시작한지 30일',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '학습 통계',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  icon: Icons.timer,
                  value: '120',
                  label: '학습 시간 (분)',
                ),
                _buildStatItem(
                  icon: Icons.star,
                  value: '85',
                  label: '평균 점수',
                ),
                _buildStatItem(
                  icon: Icons.calendar_today,
                  value: '15',
                  label: '연속 학습일',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection(WidgetRef ref) {
    return Card(
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.emoji_events,
            title: '나의 성과',
            onTap: () {
              // TODO: 성과 화면으로 이동
            },
          ),
          const Divider(),
          _buildMenuItem(
            icon: Icons.history,
            title: '학습 기록',
            onTap: () {
              // TODO: 학습 기록 화면으로 이동
            },
          ),
          const Divider(),
          _buildMenuItem(
            icon: Icons.notifications,
            title: '알림 설정',
            onTap: () {
              // TODO: 알림 설정 화면으로 이동
            },
          ),
          const Divider(),
          _buildMenuItem(
            icon: Icons.logout,
            title: '로그아웃',
            onTap: () {
              ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
