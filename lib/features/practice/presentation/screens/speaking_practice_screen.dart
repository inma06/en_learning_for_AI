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
import '../widgets/chat_message.dart';
import '../widgets/mic_button.dart';
import '../widgets/suggestion_list.dart';
import '../../../vocabulary/domain/models/word_list.dart';
import '../../../vocabulary/domain/models/word.dart';

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
  bool _isTranslationEnabled = false; // 번역 활성화 상태
  Map<String, String> _translatedMessages = {}; // 메시지별 번역 저장
  Map<String, bool> _translationStates = {};

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

  // CEFR 레벨 설명
  final Map<String, String> cefrLevelDescriptions = {
    'A1': '일상적인 아주 간단한 표현을 이해하고 사용할 수 있어요. 자기소개, 인사, 숫자, 시간 등 기초 표현이 가능해요.',
    'A2':
        '일상생활에 자주 쓰이는 문장과 표현을 이해할 수 있고, 간단한 요구나 정보를 말할 수 있어요. 여행 시 기본적인 소통이 가능해요.',
    'B1':
        '익숙한 주제에 대해 간단한 의견을 말하고 이해할 수 있어요. 직장, 학교, 여가 등 일상에서 꽤 자연스럽게 대화할 수 있어요.',
    'B2': '원어민과 큰 어려움 없이 대부분의 상황에서 자유롭게 대화할 수 있어요. 논리적으로 자신의 의견을 설명할 수 있어요.',
    'C1': '다양한 주제에 대해 유창하고 자연스럽게 대화할 수 있어요. 복잡한 문장 구조와 고급 어휘도 잘 활용할 수 있어요.',
    'C2': '실수 없이 거의 완벽하게 영어를 구사할 수 있어요. 학문적, 전문적 상황에서도 완전한 의사소통이 가능해요.',
  };

  // 임시 단어장 데이터 (나중에 실제 데이터로 교체)
  final WordList _tempWordList = WordList(
    id: 'temp',
    title: '기본 단어장',
    description: '기본 단어 학습',
    words: [
      Word(
        id: '1',
        english: 'apple',
        korean: '사과',
        lastPracticed: DateTime.now(),
      ),
      Word(
        id: '2',
        english: 'banana',
        korean: '바나나',
        lastPracticed: DateTime.now(),
      ),
      // ... more words
    ],
    createdAt: DateTime.now(),
    lastStudied: DateTime.now(),
  );

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
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showLevelDescriptionDialog(),
            tooltip: '레벨 설명',
          ),
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
              SuggestionList(
                suggestions: _suggestions,
                onSuggestionSelected: (suggestion) async {
                  setState(() => _text = suggestion);
                  ref
                      .read(speakingPracticeProvider.notifier)
                      .addUserMessage(suggestion);
                  final response = await ref
                      .read(speakingPracticeProvider.notifier)
                      .getConversationResponse(suggestion, _currentLevel);
                  ref
                      .read(speakingPracticeProvider.notifier)
                      .addAIMessage(response);
                  await _speakResponse(response);
                  await _updateSuggestions();
                },
              ),
              Expanded(
                child: Container(
                  color: Colors.grey[100],
                  child: Stack(
                    children: [
                      ListView(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                        children: [
                          // 기존 대화 기록
                          ...state.conversationHistory.map((message) {
                            final isUser = message['role'] == 'user';
                            final showAvatar =
                                state.conversationHistory.indexOf(message) ==
                                        0 ||
                                    state.conversationHistory[state
                                                .conversationHistory
                                                .indexOf(message) -
                                            1]['role'] !=
                                        message['role'];
                            final messageText = message['text'] ?? '';
                            final isTranslated =
                                _translationStates[messageText] ?? false;

                            return ChatMessage(
                              message: message,
                              isUser: isUser,
                              showAvatar: showAvatar,
                              onSpeak: () => _speakResponse(messageText),
                              onTranslate: () async {
                                setState(() {
                                  _translationStates[messageText] =
                                      !isTranslated;
                                });
                                if (!isTranslated) {
                                  final translatedText =
                                      await _translateMessage(messageText);
                                  setState(() {
                                    _translatedMessages[messageText] =
                                        translatedText;
                                  });
                                }
                              },
                              isTranslated: isTranslated,
                              translatedText: _translatedMessages[messageText],
                            );
                          }).toList(),
                        ],
                      ),
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
          Positioned(
            bottom: 15,
            right: 15,
            child: MicButton(
              isListening: _isListening,
              isInitializing: _isInitializing,
              onTapDown: _startListening,
              onTapUp: _stopListening,
              onTapCancel: _stopListening,
            ),
          ),
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

  Widget _buildMessageContent(Map<String, String> message, bool isUser) {
    final messageText = message['text'] ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Text(
                messageText,
                style: TextStyle(
                  color: isUser ? Colors.blue[900] : Colors.black87,
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
                onPressed: () => _speakResponse(messageText),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: '다시 듣기',
              ),
            ],
          ],
        ),
      ],
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
        response = await ref
            .read(speakingPracticeProvider.notifier)
            .continueLevelAssessment(_text);

        if (state.assessmentQuestionCount >= 2) {
          final levelMatch =
              RegExp(r'Level:\s*([A-C][1-2])').firstMatch(response);
          if (levelMatch != null) {
            final level = levelMatch.group(1);
            final feedback =
                response.substring(response.indexOf('\n') + 1).trim();

            if (level != null) {
              ref
                  .read(speakingPracticeProvider.notifier)
                  .addAIMessage(response);

              await _saveLevel(level);
              await _speakResponse('Your English level is $level. $feedback');
              setState(() => _isSpeaking = false);
              return;
            }
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

  // 레벨 설명 다이얼로그 표시 함수
  void _showLevelDescriptionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'CEFR 레벨 설명',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: cefrLevelDescriptions.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  entry.key,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[700],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                entry.value,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '확인',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String> _translateMessage(String text) async {
    try {
      final openAIService = ref.read(openAIServiceProvider);
      return await openAIService.translateToKorean(text);
    } catch (e) {
      debugPrint('❌ [Error] Failed to translate message: $e');
      return '번역 중 오류가 발생했습니다.';
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
