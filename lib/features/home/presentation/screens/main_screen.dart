import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/home_provider.dart';
import 'learn_screen.dart';
import 'practice_screen.dart';
import 'profile_screen.dart';
import '../../../news/presentation/screens/news_screen.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(homeProvider).currentIndex;

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [
          PracticeScreen(),
          LearnScreen(),
          NewsScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          ref.read(homeProvider.notifier).changeTab(index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.sports_esports),
            label: '연습',
          ),
          NavigationDestination(
            icon: Icon(Icons.school),
            label: '학습',
          ),
          NavigationDestination(
            icon: Icon(Icons.article_rounded),
            label: '뉴스',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: '프로필',
          ),
        ],
      ),
    );
  }
}
