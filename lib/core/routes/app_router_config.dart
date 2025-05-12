/// 실제 라우터 설정을 정의하는 파일
///
/// 이 파일의 목적:
/// 1. GoRouter 인스턴스 생성 및 설정
/// 2. 각 경로와 해당하는 화면을 매핑
/// 3. 라우터의 전반적인 동작 설정
///
/// 주요 기능:
/// - 초기 라우트 설정
/// - 라우트 매핑
/// - 네비게이션 키 관리
///
/// 향후 확장 가능한 기능:
/// - 딥링크 처리
/// - 라우트 가드 (인증 필요 여부 확인)
/// - 라우트 애니메이션
/// - 라우트 파라미터 처리

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/splash/presentation/screens/permission_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/home/presentation/screens/main_screen.dart';
import '../../features/practice/presentation/screens/speaking_practice_screen.dart';
import '../../features/vocabulary/presentation/screens/vocabulary_practice_screen.dart';
import 'app_routes.dart';

final navigatorKey = GlobalKey<NavigatorState>();

final routerConfig = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: AppRoutes.splash,
  routes: [
    // 스플래시 화면
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),

    // 권한 요청 화면 (웹에서는 건너뜀)
    GoRoute(
      path: AppRoutes.permissions,
      builder: (context, state) => kIsWeb
          ? const MainScreen() // 웹에서는 바로 메인 화면으로
          : const PermissionScreen(), // 앱에서는 권한 화면으로
    ),

    // 로그인 화면
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),

    // 메인 화면 (홈)
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const MainScreen(),
    ),

    // 연습 관련 라우트
    GoRoute(
      path: AppRoutes.speakingPractice,
      builder: (context, state) => const SpeakingPracticeScreen(),
    ),
    GoRoute(
      path: AppRoutes.listeningPractice,
      builder: (context, state) => const Scaffold(
        body: Center(
          child: Text('듣기 연습 화면 (개발 중)'),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.writingPractice,
      builder: (context, state) => const Scaffold(
        body: Center(
          child: Text('쓰기 연습 화면 (개발 중)'),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.vocabularyPractice,
      builder: (context, state) => const VocabularyPracticeScreen(),
    ),
  ],
  // 에러 페이지 처리
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('페이지를 찾을 수 없습니다: ${state.uri.path}'),
    ),
  ),
);
