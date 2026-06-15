import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voice AI Calculator')),
      body: const Center(
        child: Text('Em construção...', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
