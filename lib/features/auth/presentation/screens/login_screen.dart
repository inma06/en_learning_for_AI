import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'AI 영어 학습',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'AI와 함께 영어를 배워보세요',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 48),
              _buildSocialLoginButton(
                context,
                icon: Icons.g_mobiledata,
                text: 'Google로 계속하기',
                color: Colors.red,
                onPressed: () {
                  // TODO: Google 로그인 구현
                  ref.read(authProvider.notifier).login(
                        userId: '1',
                        userName: '테스트 사용자',
                        userEmail: 'test@example.com',
                        token: 'test_token',
                      );
                },
              ),
              const SizedBox(height: 16),
              _buildSocialLoginButton(
                context,
                icon: Icons.apple,
                text: 'Apple로 계속하기',
                color: Colors.black,
                onPressed: () {
                  // TODO: Apple 로그인 구현
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLoginButton(
    BuildContext context, {
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: color),
        label: Text(text, style: TextStyle(color: color)),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: color.withOpacity(0.2)),
          ),
        ),
      ),
    );
  }
}
