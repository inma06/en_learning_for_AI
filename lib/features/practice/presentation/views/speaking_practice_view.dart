import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/speaking_practice_provider.dart';

class SpeakingPracticeView extends ConsumerStatefulWidget {
  const SpeakingPracticeView({super.key});

  @override
  ConsumerState<SpeakingPracticeView> createState() =>
      _SpeakingPracticeViewState();
}

class _SpeakingPracticeViewState extends ConsumerState<SpeakingPracticeView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(speakingPracticeProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(speakingPracticeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Speaking Practice'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.conversationHistory.length,
              itemBuilder: (context, index) {
                final message = state.conversationHistory[index];
                final isUser = message['role'] == 'user';

                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message['text'] ?? '',
                      style: TextStyle(
                        color: isUser ? Colors.blue[900] : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (state.text.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[100],
              child: Text(
                state.text,
                style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (state.isInitializing)
                  const CircularProgressIndicator()
                else if (state.isProcessing)
                  const Text('AI 응답 생성 중...')
                else
                  GestureDetector(
                    onTapDown: (_) => ref
                        .read(speakingPracticeProvider.notifier)
                        .startListening(),
                    onTapUp: (_) => ref
                        .read(speakingPracticeProvider.notifier)
                        .stopListening(),
                    onTapCancel: () => ref
                        .read(speakingPracticeProvider.notifier)
                        .stopListening(),
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: state.isListening ? Colors.red : Colors.blue,
                      ),
                      child: Icon(
                        state.isListening ? Icons.mic : Icons.mic_none,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
