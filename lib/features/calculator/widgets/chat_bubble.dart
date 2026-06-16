import 'package:flutter/material.dart';
import 'package:voice_ai_calculator/features/calculator/models/message_model.dart';

class ChatBubble extends StatelessWidget {
  final Message message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Align(
        alignment: message.isUser
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 700),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: message.isUser
                ? colorScheme.primary
                : colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: Radius.circular(message.isUser ? 18 : 4),
              bottomRight: Radius.circular(message.isUser ? 4 : 18),
            ),
          ),
          child: SelectableText(
            message.text,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: message.isUser
                  ? colorScheme.onPrimary
                  : colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}