import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_ai_calculator/features/calculator/models/message_model.dart';

class HistoryService {
  static const String _historyKey = 'calculator_chat_history';

  Future<void> saveMessages(List<Message> messages) async {
    final prefs = await SharedPreferences.getInstance();

    final encodedMessages = messages
        .map((message) => message.toJson())
        .toList();

    await prefs.setString(_historyKey, jsonEncode(encodedMessages));
  }

  Future<List<Message>> loadMessages() async {
    final prefs = await SharedPreferences.getInstance();

    final history = prefs.getString(_historyKey);

    if (history == null || history.isEmpty) {
      return [];
    }

    final decodedMessages = jsonDecode(history) as List;

    return decodedMessages.map((message) => Message.fromJson(message)).toList();
  }

  Future<void> clearMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}