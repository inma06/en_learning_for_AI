import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import '../../domain/services/openai_service.dart';
import '../../domain/usecases/speech_recognition_usecase.dart';
import '../../domain/usecases/text_to_speech_usecase.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class SpeakingPracticeState {
  final bool isListening;
  final bool isSpeaking;
  final bool isInitializing;
  final bool isProcessing;
  final bool isLevelAssessment;
  final int assessmentQuestionCount;
  final String text;
  final List<Map<String, String>> conversationHistory;

  SpeakingPracticeState({
    this.isListening = false,
    this.isSpeaking = false,
    this.isInitializing = false,
    this.isProcessing = false,
    this.isLevelAssessment = false,
    this.assessmentQuestionCount = 0,
    this.text = '',
    this.conversationHistory = const [],
  });

  SpeakingPracticeState copyWith({
    bool? isListening,
    bool? isSpeaking,
    bool? isInitializing,
    bool? isProcessing,
    bool? isLevelAssessment,
    int? assessmentQuestionCount,
    String? text,
    List<Map<String, String>>? conversationHistory,
  }) {
    return SpeakingPracticeState(
      isListening: isListening ?? this.isListening,
      isSpeaking: isSpeaking ?? this.isSpeaking,
      isInitializing: isInitializing ?? this.isInitializing,
      isProcessing: isProcessing ?? this.isProcessing,
      isLevelAssessment: isLevelAssessment ?? this.isLevelAssessment,
      assessmentQuestionCount:
          assessmentQuestionCount ?? this.assessmentQuestionCount,
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
    final updatedHistory =
        List<Map<String, String>>.from(state.conversationHistory)
          ..add({'role': 'user', 'text': text});
    state = state.copyWith(
      conversationHistory: updatedHistory,
      text: '',
    );
  }

  void addAIMessage(String text) {
    final updatedHistory =
        List<Map<String, String>>.from(state.conversationHistory)
          ..add({'role': 'assistant', 'text': text});
    state = state.copyWith(
      conversationHistory: updatedHistory,
      text: '',
    );
  }

  Future<void> startListening() async {
    if (state.isSpeaking || state.isProcessing) {
      return;
    }

    state = state.copyWith(isProcessing: true);

    final hasPermission = await _speechRecognitionUseCase.requestPermission();
    if (!hasPermission) {
      state = state.copyWith(isProcessing: false);
      return;
    }

    state = state.copyWith(
      isSpeaking: true,
      isProcessing: false,
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
    if (!state.isSpeaking) return;

    await _speechRecognitionUseCase.stopListening();
    state = state.copyWith(isSpeaking: false);

    if (state.text.isEmpty || state.text.length < 3) {
      state = state.copyWith(text: '');
      return;
    }

    try {
      // 음성 인식 결과를 영어로 변환
      final englishText = await _openAIService.convertToEnglish(state.text);
      addUserMessage(englishText);

      state = state.copyWith(
        isProcessing: true,
      );

      final response =
          await _openAIService.getConversationResponse(englishText);
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

  Future<String> getConversationResponse(String text, String level) async {
    try {
      state = state.copyWith(isProcessing: true);

      // 레벨에 따른 프롬프트 조정
      final prompt = '''
You are an English teacher helping a student with level $level.
The student's message: $text

Please respond in a way that:
1. Uses vocabulary and grammar appropriate for $level level
2. Keeps sentences simple and clear for $level level
3. Provides gentle corrections if needed
4. Encourages further conversation
5. Responds in a friendly and supportive manner

Your response:''';

      final response = await _openAIService.getResponse(prompt);
      state = state.copyWith(isProcessing: false);
      return response;
    } catch (e) {
      state = state.copyWith(isProcessing: false);
      rethrow;
    }
  }

  Future<String> getConversationSuggestions(
      String lastMessage, String level) async {
    try {
      final prompt = '''
Based on the last conversation message: "$lastMessage"
And the student's English level: $level

Generate 10 relevant follow-up questions or conversation starters that:
1. Are appropriate for $level level English
2. Relate to the current conversation topic
3. Help continue the conversation naturally
4. Use simple vocabulary and grammar for $level level
5. Are engaging and interesting

Format each suggestion on a new line.''';

      return await _openAIService.getResponse(prompt);
    } catch (e) {
      return "What's your favorite hobby?\nTell me about your day.\nWhat's your favorite movie?\nHow's the weather today?\nWhat did you do last weekend?\nWhat's your favorite food?\nTell me about your family.\nWhat's your dream job?\nWhat's your favorite book?\nWhat's your favorite place to visit?";
    }
  }

  Future<String> startLevelAssessment() async {
    try {
      state = state.copyWith(
        isLevelAssessment: true,
        assessmentQuestionCount: 0,
        conversationHistory: [],
      );

      const prompt = '''
You are an English teacher assessing a Korean student's speaking level.
Ask a simple question to start the assessment.
Keep the question very basic and easy to understand.
Do not include any explanations or additional text, just the question.''';

      return await _openAIService.getResponse(prompt);
    } catch (e) {
      state = state.copyWith(isLevelAssessment: false);
      rethrow;
    }
  }

  Future<String> continueLevelAssessment(String answer) async {
    try {
      print('🎯 [Level Assessment] Continuing assessment...');
      print(
          '🎯 [Level Assessment] Current count: ${state.assessmentQuestionCount}');

      state = state.copyWith(
        assessmentQuestionCount: state.assessmentQuestionCount + 1,
      );
      print(
          '🎯 [Level Assessment] Updated count: ${state.assessmentQuestionCount}');

      final count = state.assessmentQuestionCount;
      String prompt;

      if (count < 2) {
        print('🎯 [Level Assessment] Asking follow-up question');
        // 두 번째 질문까지는 난이도를 점진적으로 높임
        prompt = '''
Previous answer: $answer
Question number: ${count + 1}

Ask a follow-up question that is slightly more challenging than the previous one.
Keep the question appropriate for the student's level based on their previous answer.
Do not include any explanations or additional text, just the question.''';
      } else {
        print('🎯 [Level Assessment] Final question - evaluating level');
        // 마지막 질문 후 레벨 평가
        prompt = '''
Previous answers: ${state.conversationHistory.map((m) => m['text']).join('\n')}
Final answer: $answer

Based on the student's answers, determine their English level (A1, A2, B1, B2, C1, or C2) and provide brief feedback.
Format your response exactly like this:
Level: [level]
Feedback: [one sentence feedback]''';
      }

      final response = await _openAIService.getResponse(prompt);
      print('🎯 [Level Assessment] Got response: $response');

      // 레벨 측정이 완료된 경우 (마지막 질문)
      if (count >= 2) {
        print('🎯 [Level Assessment] Assessment complete, resetting state');
        // 레벨 측정 종료 상태로 변경
        state = state.copyWith(
          isLevelAssessment: false,
          assessmentQuestionCount: 0,
        );
        print('🎯 [Level Assessment] State reset complete');
      }

      return response;
    } catch (e) {
      print('❌ [Level Assessment] Error: $e');
      state = state.copyWith(
        isLevelAssessment: false,
        assessmentQuestionCount: 0,
      );
      rethrow;
    }
  }

  void endLevelAssessment() {
    state = state.copyWith(
      isLevelAssessment: false,
      assessmentQuestionCount: 0,
    );
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
