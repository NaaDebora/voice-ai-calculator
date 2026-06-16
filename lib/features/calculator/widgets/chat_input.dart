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
    return Row(
      children: [
        IconButton(
          icon: Icon(isListening ? Icons.mic : Icons.mic_none),
          onPressed: onMic,
        ),
        Expanded(
          child: TextField(
            controller: controller,
            onSubmitted: (_) => onSend(),
            textInputAction: TextInputAction.send,
            decoration: const InputDecoration(
              hintText: "Digite ou fale um cálculo...",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: loading ? null : onSend,
          child: const Text("Enviar"),
        ),
      ],
    );
  }
}
