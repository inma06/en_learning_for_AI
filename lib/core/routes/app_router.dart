/// Riverpod을 통한 라우터 프로바이더를 정의하는 파일
///
/// 이 파일의 목적:
/// 1. 앱 전체에서 라우터를 주입하고 관리
/// 2. 라우터의 상태를 Riverpod을 통해 관리
/// 3. 라우터 관련 로직을 중앙화
///
/// 주요 기능:
/// - 라우터 프로바이더 정의
/// - 라우터 상태 관리
/// - 라우터 관련 유틸리티 함수 제공
///
/// 사용 예시:
/// ```dart
/// final router = ref.watch(routerProvider);
/// router.go(AppRoutes.home);
/// ```

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/splash/presentation/screens/permission_screen.dart';
import 'app_router_config.dart';

final navigatorKey = GlobalKey<NavigatorState>();

/// 라우터 프로바이더
///
/// 앱 전체에서 사용할 수 있는 라우터 인스턴스를 제공합니다.
/// Riverpod을 통해 라우터의 상태를 관리하고, 필요한 곳에서 주입받아 사용할 수 있습니다.
final routerProvider = Provider<GoRouter>((ref) {
  return routerConfig;
});
