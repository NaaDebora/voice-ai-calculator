import 'dart:async';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:voice_ai_calculator/features/calculator/models/message_model.dart';
import 'package:voice_ai_calculator/features/calculator/services/gemini_service.dart';
import 'package:voice_ai_calculator/features/calculator/widgets/chat_bubble.dart';
import 'package:voice_ai_calculator/features/calculator/widgets/chat_input.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_ai_calculator/app/theme_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController controller = TextEditingController();
  final GeminiService geminiService = GeminiService();
  final ScrollController scrollController = ScrollController();

  final List<Message> messages = [];

  late stt.SpeechToText speech;

  bool loading = false;
  bool isListening = false;
  bool ignoreSpeechResult = false;

  Timer? voiceTimer;

  @override
  void initState() {
    super.initState();
    speech = stt.SpeechToText();
  }

  Future<void> listen() async {
    ignoreSpeechResult = false;

    final available = await speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          if (!mounted) return;
          setState(() => isListening = false);
        }
      },
      onError: (error) {
        if (!mounted) return;
        setState(() => isListening = false);
      },
    );

    if (!available) return;

    setState(() => isListening = true);

    speech.listen(
      onResult: (result) {
        if (ignoreSpeechResult) return;

        setState(() {
          controller.text = result.recognizedWords;
        });

        voiceTimer?.cancel();

        voiceTimer = Timer(const Duration(seconds: 1), () async {
          final input = controller.text.trim();

          if (input.isEmpty || loading) return;

          ignoreSpeechResult = true;

          await speech.stop();

          if (!mounted) return;

          setState(() => isListening = false);

          calculate();
        });
      },
      listenOptions: stt.SpeechListenOptions(localeId: 'pt_BR'),
    );
  }

  Future<void> calculate() async {
    final input = controller.text.trim();

    if (input.isEmpty || loading) return;

    controller.clear();

    setState(() {
      messages.add(Message(text: input, isUser: true));
      loading = true;
    });

    scrollToBottom();

    try {
      final answer = await geminiService.ask(input);

      if (!mounted) return;

      setState(() {
        messages.add(Message(text: answer, isUser: false));
      });

      scrollToBottom();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        messages.add(
          Message(
            text: 'Erro ao consultar a IA. Tente novamente.',
            isUser: false,
          ),
        );
      });

      scrollToBottom();
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!scrollController.hasClients) return;

      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice AI Calculator'),
        actions: [
          IconButton(
            tooltip: 'Alternar tema',
            icon: Icon(
              ref.watch(themeModeProvider) == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              final currentTheme = ref.read(themeModeProvider);

              ref
                  .read(themeModeProvider.notifier)
                  .state = currentTheme == ThemeMode.dark
                  ? ThemeMode.light
                  : ThemeMode.dark;
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return ChatBubble(message: message);
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
    voiceTimer?.cancel();
    scrollController.dispose();
    controller.dispose();
    super.dispose();
  }
}
