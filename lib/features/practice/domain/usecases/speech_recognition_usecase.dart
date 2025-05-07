import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/foundation.dart';
import 'dart:html' if (dart.library.html) 'dart:html';

class SpeechRecognitionUseCase {
  final stt.SpeechToText _speech;
  MediaStream? _micStream;
  bool _isInitialized = false;

  SpeechRecognitionUseCase(this._speech);

  Future<bool> initialize() async {
    if (_isInitialized) return true;

    final available = await _speech.initialize(
      onError: (error) => debugPrint('❌ [STT Error] $error'),
      onStatus: (status) => debugPrint('ℹ️ [STT Status] $status'),
    );

    _isInitialized = available;
    return available;
  }

  Future<bool> requestPermission() async {
    if (kIsWeb) {
      try {
        _micStream?.getTracks().forEach((track) => track.stop());
        _micStream =
            await window.navigator.mediaDevices?.getUserMedia({'audio': true});
        return _micStream != null;
      } catch (e) {
        debugPrint('❌ [STT] Web microphone permission error: $e');
        return false;
      }
    }
    return true; // Native permission handled by permission_handler
  }

  Future<void> startListening({
    required Function(String) onResult,
    required Function() onComplete,
  }) async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) return;
    }

    if (_speech.isListening) {
      debugPrint('ℹ️ [STT] Already listening, stopping first');
      await stopListening();
    }

    debugPrint('🎤 [STT] Starting speech recognition...');
    await _speech.listen(
      onResult: (result) {
        final text = result.recognizedWords;
        debugPrint('🎤 [STT] Partial result: $text');
        onResult(text);

        if (result.finalResult && text.length >= 3) {
          debugPrint('✅ [STT] Final result: $text');
          onComplete();
        }
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 2),
      partialResults: true,
      onDevice: true,
      cancelOnError: true,
      listenMode: stt.ListenMode.confirmation,
    );
  }

  Future<void> stopListening() async {
    if (_speech.isListening) {
      debugPrint('🎤 [STT] Stopping speech recognition...');
      await _speech.stop();
    }
  }

  void dispose() {
    stopListening();
    _micStream?.getTracks().forEach((track) => track.stop());
  }
}
