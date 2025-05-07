import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

class SpeechService {
  final SpeechToText _speechToText = SpeechToText();
  bool _isInitialized = false;

  Future<bool> initialize() async {
    print('SpeechService: Initializing...');
    if (_isInitialized) {
      print('SpeechService: Already initialized');
      return true;
    }

    print('SpeechService: Requesting microphone permission...');
    final status = await Permission.microphone.status;
    print('SpeechService: Current microphone permission status: $status');

    if (status != PermissionStatus.granted) {
      print('SpeechService: Requesting microphone permission...');
      final result = await Permission.microphone.request();
      print('SpeechService: Microphone permission request result: $result');
      if (result != PermissionStatus.granted) {
        print('SpeechService: Microphone permission denied');
        return false;
      }
    }
    print('SpeechService: Microphone permission granted');

    print('SpeechService: Initializing Speech to Text...');
    _isInitialized = await _speechToText.initialize(
      onError: (error) =>
          print('SpeechService: Speech recognition error: $error'),
      onStatus: (status) =>
          print('SpeechService: Speech recognition status: $status'),
    );
    print('SpeechService: Speech to Text initialized: $_isInitialized');

    return _isInitialized;
  }

  Future<void> startListening({
    required Function(String text) onResult,
    required Function() onComplete,
  }) async {
    print('SpeechService: Starting speech recognition...');
    if (!_isInitialized) {
      print('SpeechService: Not initialized, initializing now...');
      final initialized = await initialize();
      if (!initialized) {
        print('SpeechService: Failed to initialize speech recognition');
        return;
      }
    }

    print('SpeechService: Starting to listen...');
    try {
      await _speechToText.listen(
        localeId: 'en_US',
        onResult: (result) {
          print(
              'SpeechService: Speech recognition result: ${result.recognizedWords}');
          if (result.finalResult) {
            print('SpeechService: Final result received');
            onResult(result.recognizedWords);
            onComplete();
          }
        },
      );
      print('SpeechService: Listening started successfully');
    } catch (e) {
      print('SpeechService: Error starting listening: $e');
    }
  }

  Future<void> stopListening() async {
    print('SpeechService: Stopping speech recognition...');
    try {
      await _speechToText.stop();
      print('SpeechService: Speech recognition stopped successfully');
    } catch (e) {
      print('SpeechService: Error stopping speech recognition: $e');
    }
  }

  bool get isListening => _speechToText.isListening;
}

final speechServiceProvider = Provider((ref) => SpeechService());
