import 'package:flutter/material.dart';

import '../services/gemini_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController controller = TextEditingController();

  final GeminiService geminiService = GeminiService();

  String result = '';

  bool loading = false;

  Future<void> calculate() async {
    if (controller.text.trim().isEmpty) {
      return;
    }

    setState(() {
      loading = true;
      result = '';
    });

    try {
      final answer = await geminiService.ask(controller.text.trim());

      setState(() {
        result = answer;
      });
    } catch (e) {
      setState(() {
        result =
            '''
Erro ao consultar a IA.

Verifique:

- Chave API
- Conexão com internet
- Limites da API Gemini

Detalhes:
$e
''';
      });
    } finally {
      setState(() {
        loading = false;
      });
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
            TextField(
              controller: controller,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Digite um cálculo ou situação...',
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : calculate,
                child: const Text('Calcular'),
              ),
            ),

            const SizedBox(height: 24),

            if (loading) const CircularProgressIndicator(),

            if (!loading && result.isNotEmpty)
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: SelectableText(
                        result,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
