import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart';

class TextToSpeechUseCase {
  final FlutterTts _flutterTts;
  Function()? _currentCompletionHandler;

  TextToSpeechUseCase(this._flutterTts);

  Future<void> initialize() async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  Future<void> speak(String text, {required Function() onComplete}) async {
    if (_currentCompletionHandler != null) {
      _flutterTts.setCompletionHandler(() {});
      _currentCompletionHandler = null;
    }

    _currentCompletionHandler = () {
      debugPrint('✅ [TTS] Completed');
      onComplete();
    };
    _flutterTts.setCompletionHandler(_currentCompletionHandler!);

    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
    if (_currentCompletionHandler != null) {
      _flutterTts.setCompletionHandler(() {});
      _currentCompletionHandler = null;
    }
  }
}
