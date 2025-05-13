import 'package:flutter/foundation.dart';
import 'dart:html' if (dart.library.html) 'dart:html';

class WebPermissionService {
  MediaStream? _micStream;

  Future<bool> requestMicrophonePermission() async {
    if (!kIsWeb) return false;

    try {
      _micStream?.getTracks().forEach((track) => track.stop());
      _micStream =
          await window.navigator.mediaDevices?.getUserMedia({'audio': true});
      return _micStream != null;
    } catch (e) {
      debugPrint('❌ [Web] Microphone permission error: $e');
      return false;
    }
  }

  void dispose() {
    _micStream?.getTracks().forEach((track) => track.stop());
  }
}
