import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;
import 'package:permission_handler/permission_handler.dart';

/// 권한 상태를 확인하는 유틸리티 클래스
class PermissionUtils {
  /// 마이크와 음성 인식 권한이 모두 허용되었는지 확인
  static Future<bool> hasRequiredPermissions() async {
    if (kIsWeb) {
      // 웹에서는 권한 화면을 건너뛰고 true 반환
      return true;
    } else if (Platform.isAndroid) {
      final micStatus = await Permission.microphone.status;
      final speechStatus = await Permission.speech.status;
      return micStatus.isGranted && speechStatus.isGranted;
    } else if (Platform.isIOS) {
      final micStatus = await Permission.microphone.status;
      return micStatus.isGranted;
    } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      return true;
    }
    return false;
  }

  /// 필요한 모든 권한 요청
  static Future<bool> requestRequiredPermissions() async {
    if (kIsWeb) {
      // 웹에서는 권한 화면을 건너뛰고 true 반환
      return true;
    } else if (Platform.isAndroid) {
      final micResult = await Permission.microphone.request();
      final speechResult = await Permission.speech.request();
      return micResult.isGranted && speechResult.isGranted;
    } else if (Platform.isIOS) {
      final micResult = await Permission.microphone.request();
      return micResult.isGranted;
    } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      return true;
    }
    return false;
  }

  /// 권한이 영구적으로 거부되었는지 확인
  static Future<bool> isPermanentlyDenied() async {
    if (kIsWeb) {
      return false; // 웹에서는 영구 거부 개념이 없음
    } else if (Platform.isAndroid) {
      final micStatus = await Permission.microphone.status;
      final speechStatus = await Permission.speech.status;
      return micStatus.isPermanentlyDenied || speechStatus.isPermanentlyDenied;
    } else if (Platform.isIOS) {
      final micStatus = await Permission.microphone.status;
      return micStatus.isPermanentlyDenied;
    } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      return false; // 데스크톱 플랫폼에서는 영구 거부 개념이 없음
    }
    return false;
  }

  static Future<bool> requestPermission(
    BuildContext context,
    Permission permission,
    String title,
    String message,
  ) async {
    if (kIsWeb) {
      // 웹에서는 브라우저가 자체적으로 권한 처리
      return true;
    } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      // 데스크톱 플랫폼은 기본적으로 권한이 있다고 가정
      return true;
    }

    final status = await permission.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      final result = await permission.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      if (context.mounted) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () {
                  openAppSettings();
                  Navigator.pop(context);
                },
                child: const Text('설정으로 이동'),
              ),
            ],
          ),
        );
      }
      return false;
    }

    return false;
  }

  // 마이크 권한 요청
  static Future<bool> requestMicrophonePermission(BuildContext context) async {
    if (kIsWeb) {
      // 웹에서는 브라우저가 자체적으로 권한 처리
      return true;
    } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      // 데스크톱 플랫폼은 기본적으로 권한이 있다고 가정
      return true;
    }

    return requestPermission(
      context,
      Permission.microphone,
      '마이크 권한 필요',
      '음성 인식을 위해 마이크 권한이 필요합니다.\n'
          '설정에서 마이크 권한을 허용해주세요.',
    );
  }

  // 카메라 권한 요청
  static Future<bool> requestCameraPermission(BuildContext context) async {
    return requestPermission(
      context,
      Permission.camera,
      '카메라 권한 필요',
      '사진 촬영을 위해 카메라 권한이 필요합니다.\n'
          '설정에서 카메라 권한을 허용해주세요.',
    );
  }

  // 갤러리 권한 요청
  static Future<bool> requestPhotosPermission(BuildContext context) async {
    return requestPermission(
      context,
      Permission.photos,
      '사진 접근 권한 필요',
      '사진 선택을 위해 갤러리 접근 권한이 필요합니다.\n'
          '설정에서 사진 접근 권한을 허용해주세요.',
    );
  }

  // 위치 권한 요청
  static Future<bool> requestLocationPermission(BuildContext context) async {
    return requestPermission(
      context,
      Permission.location,
      '위치 권한 필요',
      '위치 기반 서비스를 위해 위치 권한이 필요합니다.\n'
          '설정에서 위치 권한을 허용해주세요.',
    );
  }
}
