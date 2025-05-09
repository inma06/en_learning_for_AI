import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatMessage extends ConsumerWidget {
  final Map<String, String> message;
  final bool isUser;
  final bool showAvatar;
  final VoidCallback onSpeak;
  final VoidCallback onTranslate;
  final bool isTranslated;
  final String? translatedText;

  const ChatMessage({
    super.key,
    required this.message,
    required this.isUser,
    required this.showAvatar,
    required this.onSpeak,
    required this.onTranslate,
    this.isTranslated = false,
    this.translatedText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
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
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isUser ? Colors.blue[100] : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Text(
                          message['text'] ?? '',
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
                          onPressed: onSpeak,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          tooltip: '다시 듣기',
                        ),
                        IconButton(
                          icon: Icon(
                            isTranslated
                                ? Icons.translate
                                : Icons.translate_outlined,
                            size: 20,
                            color:
                                isTranslated ? Colors.green : Colors.blue[700],
                          ),
                          onPressed: onTranslate,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          tooltip: isTranslated ? '영어로 보기' : '한국어로 번역',
                        ),
                      ],
                    ],
                  ),
                  if (isTranslated && !isUser && translatedText != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        translatedText!,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
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
  }
}
