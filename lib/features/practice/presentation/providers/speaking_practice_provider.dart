import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import '../../domain/services/openai_service.dart';
import '../../domain/usecases/speech_recognition_usecase.dart';
import '../../domain/usecases/text_to_speech_usecase.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SpeakingPracticeState {
  final bool isListening;
  final bool isSpeaking;
  final bool isInitializing;
  final bool isProcessing;
  final String text;
  final List<Map<String, String>> conversationHistory;

  SpeakingPracticeState({
    this.isListening = false,
    this.isSpeaking = false,
    this.isInitializing = false,
    this.isProcessing = false,
    this.text = '',
    this.conversationHistory = const [],
  });

  SpeakingPracticeState copyWith({
    bool? isListening,
    bool? isSpeaking,
    bool? isInitializing,
    bool? isProcessing,
    String? text,
    List<Map<String, String>>? conversationHistory,
  }) {
    return SpeakingPracticeState(
      isListening: isListening ?? this.isListening,
      isSpeaking: isSpeaking ?? this.isSpeaking,
      isInitializing: isInitializing ?? this.isInitializing,
      isProcessing: isProcessing ?? this.isProcessing,
      text: text ?? this.text,
      conversationHistory: conversationHistory ?? this.conversationHistory,
    );
  }
}

class SpeakingPracticeNotifier extends StateNotifier<SpeakingPracticeState> {
  final SpeechRecognitionUseCase _speechRecognitionUseCase;
  final TextToSpeechUseCase _textToSpeechUseCase;
  final OpenAIService _openAIService;

  SpeakingPracticeNotifier(
    this._speechRecognitionUseCase,
    this._textToSpeechUseCase,
    this._openAIService,
  ) : super(SpeakingPracticeState());

  Future<void> initialize() async {
    await _textToSpeechUseCase.initialize();
  }

  void updateCurrentText(String text) {
    state = state.copyWith(text: text);
  }

  void addUserMessage(String text) {
    final newHistory = List<Map<String, String>>.from(state.conversationHistory)
      ..add({
        'role': 'user',
        'text': text,
      });
    state = state.copyWith(
      conversationHistory: newHistory,
      text: '',
    );
  }

  void addAIMessage(String text) {
    final newHistory = List<Map<String, String>>.from(state.conversationHistory)
      ..add({
        'role': 'ai',
        'text': text,
      });
    state = state.copyWith(conversationHistory: newHistory);
  }

  Future<void> startListening() async {
    if (state.isSpeaking || state.isProcessing) {
      return;
    }

    state = state.copyWith(isInitializing: true);

    final hasPermission = await _speechRecognitionUseCase.requestPermission();
    if (!hasPermission) {
      state = state.copyWith(isInitializing: false);
      return;
    }

    state = state.copyWith(
      isListening: true,
      isInitializing: false,
    );

    await _speechRecognitionUseCase.startListening(
      onResult: (recognizedText) {
        state = state.copyWith(text: recognizedText);
      },
      onComplete: () {
        stopListening();
      },
    );
  }

  Future<void> stopListening() async {
    if (!state.isListening) return;

    await _speechRecognitionUseCase.stopListening();
    state = state.copyWith(isListening: false);

    if (state.text.isEmpty || state.text.length < 3) {
      state = state.copyWith(text: '');
      return;
    }

    try {
      addUserMessage(state.text);

      state = state.copyWith(
        isProcessing: true,
      );

      final response = await _openAIService.getConversationResponse(state.text);
      addAIMessage(response);

      state = state.copyWith(
        isProcessing: false,
        isSpeaking: true,
      );

      await _textToSpeechUseCase.speak(
        response,
        onComplete: () {
          state = state.copyWith(
            isSpeaking: false,
            text: '',
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        isSpeaking: false,
        isProcessing: false,
        text: '',
      );
    }
  }

  Future<String> getConversationResponse(String text) async {
    try {
      state = state.copyWith(isProcessing: true);
      final response = await _openAIService.getConversationResponse(text);
      state = state.copyWith(isProcessing: false);
      return response;
    } catch (e) {
      state = state.copyWith(isProcessing: false);
      rethrow;
    }
  }

  void dispose() {
    _speechRecognitionUseCase.dispose();
    _textToSpeechUseCase.stop();
    super.dispose();
  }
}

final openAIServiceProvider = Provider((ref) => OpenAIService(
      apiKey: dotenv.env['OPENAI_API_KEY'] ?? '',
    ));

final speakingPracticeProvider =
    StateNotifierProvider<SpeakingPracticeNotifier, SpeakingPracticeState>(
        (ref) {
  final speechRecognitionUseCase = ref.watch(speechRecognitionUseCaseProvider);
  final textToSpeechUseCase = ref.watch(textToSpeechUseCaseProvider);
  final openAIService = ref.watch(openAIServiceProvider);
  return SpeakingPracticeNotifier(
    speechRecognitionUseCase,
    textToSpeechUseCase,
    openAIService,
  );
});

final speechRecognitionUseCaseProvider =
    Provider<SpeechRecognitionUseCase>((ref) {
  return SpeechRecognitionUseCase(ref.watch(speechToTextProvider));
});

final textToSpeechUseCaseProvider = Provider<TextToSpeechUseCase>((ref) {
  return TextToSpeechUseCase(ref.watch(flutterTtsProvider));
});

final speechToTextProvider = Provider<stt.SpeechToText>((ref) {
  return stt.SpeechToText();
});

final flutterTtsProvider = Provider<FlutterTts>((ref) {
  return FlutterTts();
});
