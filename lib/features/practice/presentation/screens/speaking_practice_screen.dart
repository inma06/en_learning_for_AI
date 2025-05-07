import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/utils/permission_handler.dart';
import '../../../../core/services/web_permission_service.dart';
import '../../domain/services/speech_service.dart';
import '../providers/speaking_practice_provider.dart';

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

  final List<String> _suggestions = [
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
                      height: 120,
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
                                onTap: () {
                                  setState(() => _text = _suggestions[index]);
                                  _stopListening();
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
    // API 응답이나 TTS 재생 중에는 음성 인식 시작하지 않음
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
        _text = ''; // 새로운 대화 시작 시 텍스트 초기화
      });
      _speech.listen(
        onResult: (result) {
          debugPrint('🎤 [STT] Partial result: ${result.recognizedWords}');
          setState(() {
            _text = result.recognizedWords;
          });

          // 실시간으로 Provider를 통해 상태 업데이트
          ref.read(speakingPracticeProvider.notifier).updateCurrentText(_text);
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 2),
        partialResults: true,
        onDevice: true,
        cancelOnError: true,
        listenMode: stt.ListenMode.confirmation,
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
    if (_isListening) {
      debugPrint('🎤 [STT] Stopping speech recognition...');
      await _speech.stop();
      setState(() => _isListening = false);

      // 텍스트가 너무 짧으면 대화로 처리하지 않음
      if (_text.isEmpty || _text.length < 3) {
        debugPrint('ℹ️ [STT] Text too short, ignoring');
        _showFeedback('음성이 너무 짧습니다. 좀 더 길게 말씀해 보세요.');
        return;
      }

      try {
        // 사용자 발화를 대화 기록에 추가
        ref.read(speakingPracticeProvider.notifier).addUserMessage(_text);

        // API 응답 대기 중 상태 표시
        setState(() => _isSpeaking = true);

        final response = await ref
            .read(speakingPracticeProvider.notifier)
            .getConversationResponse(_text);

        debugPrint('🤖 [AI] Response: $response');

        // AI 응답을 대화 기록에 추가
        ref.read(speakingPracticeProvider.notifier).addAIMessage(response);

        setState(() {});
        _scrollToBottom();

        // TTS로 응답 읽어주기
        await _speakResponse(response);
      } catch (e) {
        debugPrint('❌ [Error] API Error: $e');
        setState(() => _isSpeaking = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('API 오류: $e')),
          );
        }
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

  @override
  void dispose() {
    _flutterTts.stop();
    _speech.stop();
    _scrollController.dispose();
    _webPermissionService.dispose();
    super.dispose();
  }
}
