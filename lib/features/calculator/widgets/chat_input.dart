import 'package:flutter/material.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onMic;
  final bool loading;
  final bool isListening;

  const ChatInput({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onMic,
    required this.loading,
    required this.isListening,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Falar',
            icon: Icon(
              isListening ? Icons.mic : Icons.mic_none,
              color: isListening ? Colors.red : colorScheme.primary,
            ),
            onPressed: loading ? null : onMic,
          ),
          Expanded(
            child: TextField(
              controller: controller,
              enabled: !loading,
              onSubmitted: (_) => onSend(),
              textInputAction: TextInputAction.send,
              decoration: const InputDecoration(
                hintText: 'Digite ou fale um cálculo...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton.filled(
            tooltip: 'Enviar',
            onPressed: loading ? null : onSend,
            icon: loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.arrow_upward),
          ),
        ],
      ),
    );
  }
}