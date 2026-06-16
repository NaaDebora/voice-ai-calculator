import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:voice_ai_calculator/app/theme_controller.dart';
import 'package:voice_ai_calculator/features/calculator/screens/home_screen.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Voice AI Calculator',

      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),

      darkTheme: ThemeData(brightness: Brightness.dark, useMaterial3: true),

      themeMode: themeMode,

      home: const HomeScreen(),
    );
  }
}
