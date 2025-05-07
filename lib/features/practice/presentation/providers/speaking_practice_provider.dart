import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'speaking_practice_provider.freezed.dart';

@freezed
class SpeakingPracticeState with _$SpeakingPracticeState {
  const factory SpeakingPracticeState({
    @Default(false) bool isRecording,
    @Default(false) bool isProcessing,
    String? userSpeech,
    String? aiResponse,
    String? error,
  }) = _SpeakingPracticeState;
}

class SpeakingPracticeNotifier extends StateNotifier<SpeakingPracticeState> {
  SpeakingPracticeNotifier() : super(const SpeakingPracticeState());

  Future<void> startRecording() async {
    state = state.copyWith(
      isRecording: true,
      error: null,
    );
    // TODO: 음성 인식 시작
  }

  Future<void> stopRecording() async {
    state = state.copyWith(
      isRecording: false,
      isProcessing: true,
    );
    // TODO: 음성 인식 중지 및 OpenAI API 호출
  }

  void setUserSpeech(String speech) {
    state = state.copyWith(
      userSpeech: speech,
    );
  }

  void setAiResponse(String response) {
    state = state.copyWith(
      aiResponse: response,
      isProcessing: false,
    );
  }

  void setError(String error) {
    state = state.copyWith(
      error: error,
      isRecording: false,
      isProcessing: false,
    );
  }
}

final speakingPracticeProvider =
    StateNotifierProvider<SpeakingPracticeNotifier, SpeakingPracticeState>(
  (ref) => SpeakingPracticeNotifier(),
);
