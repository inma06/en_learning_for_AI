import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/permission_handler.dart';

class PermissionScreen extends ConsumerStatefulWidget {
  const PermissionScreen({super.key});

  @override
  ConsumerState<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends ConsumerState<PermissionScreen> {
  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    if (kIsWeb) {
      // 웹에서는 권한 화면을 건너뛰고 바로 홈으로 이동
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
      return;
    }

    final hasPermissions = await PermissionUtils.hasRequiredPermissions();
    if (hasPermissions) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    }
  }

  Future<void> _requestPermissions() async {
    if (kIsWeb) {
      // 웹에서는 권한 화면을 건너뛰고 바로 홈으로 이동
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
      return;
    }

    final granted = await PermissionUtils.requestRequiredPermissions();
    if (granted && mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // 웹에서는 빈 화면을 보여주고 바로 홈으로 이동
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '권한 요청',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              '음성 인식 기능을 사용하기 위해\n마이크 권한이 필요합니다.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _requestPermissions,
              child: const Text('권한 허용하기'),
            ),
          ],
        ),
      ),
    );
  }
}
