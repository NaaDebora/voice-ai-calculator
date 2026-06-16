import 'package:flutter/material.dart';
import 'package:voice_ai_calculator/features/calculator/message_model.dart';

import '../services/gemini_service.dart';

import 'package:voice_ai_calculator/features/calculator/widgets/chat_bubble.dart';
import 'package:voice_ai_calculator/features/calculator/widgets/chat_input.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController controller = TextEditingController();
  final GeminiService geminiService = GeminiService();
  final ScrollController scrollController = ScrollController();

  List<Message> messages = [];
  bool loading = false;

  late stt.SpeechToText speech;
  bool isListening = false;

  @override
  void initState() {
    super.initState();
    speech = stt.SpeechToText();
  }

  // 🎤 VOZ
  Future<void> listen() async {
    bool available = await speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          setState(() => isListening = false);
        }
      },
      onError: (error) {
        setState(() => isListening = false);
      },
    );

    if (available) {
      setState(() => isListening = true);

      speech.listen(
        localeId: 'pt_BR',
        onResult: (result) {
          setState(() {
            controller.text = result.recognizedWords;
          });
        },
      );
    }
  }

  // 🤖 IA
  Future<void> calculate() async {
    final input = controller.text.trim();

    if (input.isEmpty) return;

    controller.clear();

    setState(() {
      messages.add(Message(text: input, isUser: true));
      loading = true;
    });

    scrollToBottom();

    try {
      final answer = await geminiService.ask(input);

      setState(() {
        messages.add(Message(text: answer, isUser: false));
      });

      scrollToBottom();
    } catch (e) {
      setState(() {
        messages.add(Message(text: "Erro: $e", isUser: false));
      });

      scrollToBottom();
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voice AI Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  return ChatBubble(message: msg);
                },
              ),
            ),

            if (loading) const CircularProgressIndicator(),

            const SizedBox(height: 8),

            ChatInput(
              controller: controller,
              onSend: calculate,
              onMic: listen,
              loading: loading,
              isListening: isListening,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    controller.dispose();
    super.dispose();
  }
}
