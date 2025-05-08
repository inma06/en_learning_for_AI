import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import '../../../../core/utils/permission_handler.dart';
import '../../../../core/services/web_permission_service.dart';
import '../../domain/services/speech_service.dart';
import '../providers/speaking_practice_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpeakingPracticeScreen extends ConsumerStatefulWidget {
  const SpeakingPracticeScreen({super.key});

  @override
  ConsumerState<SpeakingPracticeScreen> createState() =>
      _SpeakingPracticeScreenState();
}

class _SpeakingPracticeScreenState
    extends ConsumerState<SpeakingPracticeScreen> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  final WebPermissionService _webPermissionService = WebPermissionService();
  bool _isListening = false;
  String _text = '';
  bool _hasPermission = false;
  bool _isSpeaking = false;
  bool _isInitializing = false;
  bool _isConversationComplete = true;
  bool _showToast = false;
  String _toastMessage = '';
  final List<Map<String, String>> _conversationHistory = [];
  final ScrollController _scrollController = ScrollController();
  String _currentLevel = 'A1'; // 기본 레벨 설정
  List<String> _suggestions = []; // 동적 추천 문장을 위한 리스트

  // 초기 추천 문장
  final List<String> _initialSuggestions = [
    "What's your favorite hobby?",
    "Tell me about your day.",
    "What's your favorite movie?",
    "How's the weather today?",
    "What did you do last weekend?",
    "What's your favorite food?",
    "Tell me about your family.",
    "What's your dream job?",
    "What's your favorite book?",
    "What's your favorite place to visit?",
  ];

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _initTts();
    _loadSavedLevel();
    _suggestions = List.from(_initialSuggestions);
    Future.microtask(() {
      ref.read(speakingPracticeProvider.notifier).initialize();
    });
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  Future<void> _initSpeech() async {
    if (kIsWeb) {
      try {
        debugPrint('🎤 [STT] Requesting microphone permission for web...');
        final hasPermission =
            await _webPermissionService.requestMicrophonePermission();
        setState(() => _hasPermission = hasPermission);
        if (hasPermission) {
          debugPrint('✅ [STT] Web microphone permission granted');
          await _initializeSpeechToText();
        }
      } catch (e) {
        debugPrint('❌ [STT] Web microphone permission error: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('마이크 권한이 필요합니다.')),
          );
        }
      }
    } else {
      debugPrint('🎤 [STT] Requesting microphone permission for native...');
      final hasPermission = await PermissionUtils.hasRequiredPermissions();
      setState(() => _hasPermission = hasPermission);
      if (hasPermission) {
        debugPrint('✅ [STT] Native microphone permission granted');
        await _initializeSpeechToText();
      }
    }
  }

  Future<void> _initializeSpeechToText() async {
    debugPrint('🎤 [STT] Initializing speech recognition...');
    bool available = await _speech.initialize(
      onError: (error) {
        debugPrint('❌ [STT Error] $error');
      },
      onStatus: (status) {
        debugPrint('ℹ️ [STT Status] $status');
      },
    );

    if (!available) {
      debugPrint('❌ [STT] Speech recognition not available');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('음성 인식 기능을 사용할 수 없습니다.')),
        );
      }
    } else {
      debugPrint('✅ [STT] Speech recognition initialized successfully');
      // 사용 가능한 로케일 출력
      final locales = await _speech.locales();
      debugPrint(
          '🎤 [STT] Available locales: ${locales.map((l) => l.name).join(', ')}');
    }
  }

  void _showToastMessage(String message) {
    setState(() {
      _toastMessage = message;
      _showToast = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showToast = false;
        });
      }
    });
  }

  void _showFeedback(String message) {
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: false,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    ).then((_) {
      // Bottom sheet가 닫힐 때 추가 작업이 필요한 경우 여기에 작성
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(speakingPracticeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Speaking Practice'),
        actions: [
          if (!state.isLevelAssessment)
            IconButton(
              icon: const Icon(Icons.assessment),
              onPressed: () async {
                try {
                  final response = await ref
                      .read(speakingPracticeProvider.notifier)
                      .startLevelAssessment();
                  ref
                      .read(speakingPracticeProvider.notifier)
                      .addAIMessage(response);
                  await _speakResponse(response);
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('레벨 측정 중 오류 발생: $e')),
                    );
                  }
                }
              },
              tooltip: '영어 레벨 측정',
            ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // 추천 예문 섹션
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                color: Colors.blue[50],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Text(
                            '대화 시작하기',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.arrow_forward_ios,
                              size: 16, color: Colors.blue[700]),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 160,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: _suggestions.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: InkWell(
                                onTap: () async {
                                  setState(() => _text = _suggestions[index]);
                                  // 추천 예문을 대화 기록에 추가
                                  ref
                                      .read(speakingPracticeProvider.notifier)
                                      .addUserMessage(_suggestions[index]);
                                  // AI 응답 받기
                                  final response = await ref
                                      .read(speakingPracticeProvider.notifier)
                                      .getConversationResponse(
                                          _suggestions[index], _currentLevel);
                                  // AI 응답을 대화 기록에 추가
                                  ref
                                      .read(speakingPracticeProvider.notifier)
                                      .addAIMessage(response);
                                  // TTS로 응답 재생
                                  await _speakResponse(response);
                                  // 추천 문장 업데이트
                                  await _updateSuggestions();
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  width: 200,
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.chat_bubble_outline,
                                        color: Colors.blue[700],
                                        size: 24,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        _suggestions[index],
                                        textAlign: TextAlign.center,
                                        maxLines: 5,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.blue[900],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // 대화 기록 섹션
              Expanded(
                child: Container(
                  color: Colors.grey[100],
                  child: Stack(
                    children: [
                      ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(
                            16, 8, 16, 80), // 하단 여백 추가
                        itemCount: state.conversationHistory.length,
                        itemBuilder: (context, index) {
                          final message = state.conversationHistory[index];
                          final isUser = message['role'] == 'user';
                          final showAvatar = index == 0 ||
                              state.conversationHistory[index - 1]['role'] !=
                                  message['role'];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: isUser
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (!isUser && showAvatar) ...[
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.blue[100],
                                    child: const Icon(
                                      Icons.smart_toy,
                                      color: Colors.blue,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ] else if (!isUser) ...[
                                  const SizedBox(width: 40),
                                ],
                                Flexible(
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.7,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isUser
                                          ? Colors.blue[100]
                                          : Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(16),
                                        topRight: const Radius.circular(16),
                                        bottomLeft:
                                            Radius.circular(isUser ? 16 : 4),
                                        bottomRight:
                                            Radius.circular(isUser ? 4 : 16),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 2,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            message['text'] ?? '',
                                            style: TextStyle(
                                              color: isUser
                                                  ? Colors.blue[900]
                                                  : Colors.black87,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        if (!isUser) ...[
                                          const SizedBox(width: 8),
                                          IconButton(
                                            icon: Icon(
                                              Icons.volume_up,
                                              size: 20,
                                              color: Colors.blue[700],
                                            ),
                                            onPressed: () => _speakResponse(
                                                message['text'] ?? ''),
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            tooltip: '다시 듣기',
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                                if (isUser && showAvatar) ...[
                                  const SizedBox(width: 8),
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.blue[100],
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.blue,
                                      size: 20,
                                    ),
                                  ),
                                ] else if (isUser) ...[
                                  const SizedBox(width: 40),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
                      // 실시간 STT 텍스트 표시
                      if (state.text.isNotEmpty)
                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.mic,
                                    color: Colors.blue[700], size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    state.text,
                                    style: TextStyle(
                                      color: Colors.blue[900],
                                      fontSize: 15,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      // 처리 중 상태 표시
                      if (state.isProcessing || state.isSpeaking)
                        Positioned(
                          bottom: state.text.isNotEmpty ? 80 : 16,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    state.isProcessing ? '생각 중...' : '말하는 중...',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // 중앙 마이크 버튼
          Positioned(
            bottom: 15,
            right: 15,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  GestureDetector(
                    onTapDown: (_) => _startListening(),
                    onTapUp: (_) => _stopListening(),
                    onTapCancel: () => _stopListening(),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: _isListening ? 72 : 56,
                      height: _isListening ? 72 : 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isListening ? Colors.red : Colors.blue,
                        boxShadow: _isListening
                            ? [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.3),
                                  blurRadius: 12,
                                  spreadRadius: 4,
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: _isListening
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.mic,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '말하는 중...',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )
                              : Icon(
                                  Icons.mic_none,
                                  color: Colors.white,
                                  size: 28,
                                ),
                        ),
                      ),
                    ),
                  ),
                  if (_isInitializing)
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.3),
                      ),
                      child: const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // 토스트 메시지
          if (_showToast)
            Center(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _showToast ? 1.0 : 0.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _toastMessage,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // 레벨 측정 중 상태 표시
          if (state.isLevelAssessment)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                color: Colors.blue.withOpacity(0.1),
                child: Center(
                  child: Text(
                    '영어 레벨 측정 중 (${state.assessmentQuestionCount + 1}/3)',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _startListening() async {
    if (!_hasPermission) {
      debugPrint('🎤 [STT] No permission, requesting...');
      if (kIsWeb) {
        await _initSpeech();
      } else {
        final granted = await PermissionUtils.requestRequiredPermissions();
        setState(() => _hasPermission = granted);
      }
      return;
    }

    final state = ref.read(speakingPracticeProvider);
    if (state.isSpeaking || state.isProcessing) {
      debugPrint('ℹ️ [STT] Waiting for AI response or TTS to complete');
      return;
    }

    debugPrint('🎤 [STT] Starting speech recognition...');
    setState(() => _isInitializing = true);

    bool available = await _speech.initialize(
      onError: (error) {
        debugPrint('❌ [STT Error] $error');
        setState(() => _isInitializing = false);
      },
      onStatus: (status) {
        debugPrint('ℹ️ [STT Status] $status');
        if (status == 'done') {
          _stopListening();
        }
      },
    );

    if (available) {
      setState(() {
        _isListening = true;
        _isInitializing = false;
        _text = '';
      });

      final locales = await _speech.locales();
      String? localeId;

      if (locales.isNotEmpty) {
        final enLocale = locales.firstWhere(
          (locale) => locale.name.toLowerCase().contains('en_us'),
          orElse: () => locales.firstWhere(
            (locale) => locale.name.toLowerCase().contains('en_gb'),
            orElse: () => locales.firstWhere(
              (locale) => locale.name.toLowerCase().contains('en'),
              orElse: () => locales.first,
            ),
          ),
        );
        localeId = enLocale.localeId;
        debugPrint('🎤 [STT] Using locale: ${enLocale.name}');
      }

      _speech.listen(
        onResult: (result) async {
          debugPrint('🎤 [STT] Partial result: ${result.recognizedWords}');
          // 실시간으로 한국어를 영어로 변환
          try {
            final openAIService = ref.read(openAIServiceProvider);
            final englishText =
                await openAIService.convertToEnglish(result.recognizedWords);
            setState(() {
              _text = englishText;
            });
            ref
                .read(speakingPracticeProvider.notifier)
                .updateCurrentText(englishText);
          } catch (e) {
            debugPrint('❌ [Error] Failed to convert text: $e');
            setState(() {
              _text = result.recognizedWords;
            });
            ref
                .read(speakingPracticeProvider.notifier)
                .updateCurrentText(result.recognizedWords);
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 5),
        partialResults: true,
        onDevice: true,
        cancelOnError: true,
        listenMode: stt.ListenMode.dictation,
        localeId: localeId,
      );
    } else {
      debugPrint('❌ [STT] Failed to initialize speech recognition');
      setState(() => _isInitializing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('음성 인식 초기화에 실패했습니다.')),
        );
      }
    }
  }

  Future<void> _stopListening() async {
    if (!_isListening) return;

    setState(() {
      _isListening = false;
      _isInitializing = false;
    });

    await _speech.stop();
    debugPrint('🎤 [STT] Stopped listening');

    if (_text.isEmpty || _text.length < 3) {
      setState(() => _text = '');
      return;
    }

    try {
      setState(() => _isSpeaking = true);

      // 음성 인식 결과를 영어로 변환
      final openAIService = ref.read(openAIServiceProvider);
      final englishText = await openAIService.convertToEnglish(_text);
      setState(() => _text = englishText);

      // 사용자 메시지 추가
      ref.read(speakingPracticeProvider.notifier).addUserMessage(englishText);

      String response;
      final state = ref.read(speakingPracticeProvider);

      if (state.isLevelAssessment) {
        print('🎯 [Screen] Processing level assessment response');
        response = await ref
            .read(speakingPracticeProvider.notifier)
            .continueLevelAssessment(_text);

        // 레벨 측정이 완료된 경우 (마지막 질문)
        if (state.assessmentQuestionCount >= 2) {
          print('🎯 [Screen] Final question answered');
          print('🎯 [Screen] Response: $response');

          // 레벨과 피드백 파싱
          final levelMatch =
              RegExp(r'Level:\s*([A-C][1-2])').firstMatch(response);
          if (levelMatch != null) {
            final level = levelMatch.group(1);
            // 피드백은 "Level: X" 이후의 모든 텍스트
            final feedback =
                response.substring(response.indexOf('\n') + 1).trim();

            if (level != null) {
              print('🎯 [Screen] Level found: $level');
              print('🎯 [Screen] Feedback: $feedback');

              // AI 응답을 대화 기록에 추가
              ref
                  .read(speakingPracticeProvider.notifier)
                  .addAIMessage(response);

              // 레벨 저장
              await _saveLevel(level);
              print('🎯 [Screen] Level saved');

              // TTS로 레벨과 피드백만 재생
              await _speakResponse('Your English level is $level. $feedback');
              setState(() => _isSpeaking = false);
              return;
            }
          } else {
            print('❌ [Screen] Failed to parse level from response');
          }
        }
      } else {
        response = await ref
            .read(speakingPracticeProvider.notifier)
            .getConversationResponse(_text, _currentLevel);
        await _updateSuggestions();
      }

      ref.read(speakingPracticeProvider.notifier).addAIMessage(response);
      setState(() {});
      _scrollToBottom();
      await _speakResponse(response);
    } catch (e) {
      setState(() => _isSpeaking = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('API 오류: $e')),
        );
      }
    }
  }

  Future<void> _speakResponse(String text) async {
    setState(() => _isSpeaking = true);
    debugPrint('🔊 [TTS] Speaking: $text');
    await _flutterTts.speak(text);
    _flutterTts.setCompletionHandler(() {
      debugPrint('✅ [TTS] Completed');
      setState(() => _isSpeaking = false);
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // 저장된 레벨 불러오기
  Future<void> _loadSavedLevel() async {
    // TODO: 백엔드 연동 시 사용자 레벨 정보를 서버에서 가져오도록 수정
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentLevel = prefs.getString('user_level') ?? 'A1';
    });
  }

  // 레벨 저장하기
  Future<void> _saveLevel(String level) async {
    // TODO: 백엔드 연동 시 사용자 레벨 정보를 서버에 저장하도록 수정
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_level', level);
    setState(() {
      _currentLevel = level;
    });
  }

  // 레벨에 따른 대화 난이도 조정
  String _adjustConversationForLevel(String text) {
    // TODO: 백엔드 연동 시 AI 모델에 레벨 정보를 전달하여 응답 생성
    return text;
  }

  // 추천 문장 업데이트
  Future<void> _updateSuggestions() async {
    try {
      final state = ref.read(speakingPracticeProvider);
      if (state.conversationHistory.isEmpty) {
        setState(() {
          _suggestions = List.from(_initialSuggestions);
        });
        return;
      }

      // 마지막 대화 내용을 기반으로 새로운 추천 문장 생성
      final lastMessage = state.conversationHistory.last['text'] ?? '';
      final response = await ref
          .read(speakingPracticeProvider.notifier)
          .getConversationSuggestions(lastMessage, _currentLevel);

      setState(() {
        _suggestions =
            response.split('\n').where((s) => s.isNotEmpty).take(10).toList();
      });
    } catch (e) {
      debugPrint('❌ [Error] Failed to update suggestions: $e');
      // 에러 발생 시 초기 추천 문장 유지
      setState(() {
        _suggestions = List.from(_initialSuggestions);
      });
    }
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _speech.stop();
    _scrollController.dispose();
    _webPermissionService.dispose();
    super.dispose();
  }
}
