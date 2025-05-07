import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:language_learning_app/features/auth/presentation/screens/login_screen.dart';
import 'package:language_learning_app/features/learning/presentation/screens/main_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // TODO: Implement auto login check
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    // TODO: Replace with actual auto login check
    final bool isLoggedIn = false;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) =>
            isLoggedIn ? const MainScreen() : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: Replace with actual app logo
            const FlutterLogo(size: 100),
            const SizedBox(height: 24),
            const Text(
              'AI English Learning',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
