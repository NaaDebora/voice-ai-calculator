import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Voice AI Calculator',
      home: Scaffold(
        appBar: AppBar(title: const Text('Voice AI Calculator')),
        body: const Center(child: Text('Welcome to Voice AI Calculator!')),
      ),
    );
  }
}
