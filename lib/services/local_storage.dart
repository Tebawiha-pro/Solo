import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AppStorage {
  static const String keyHistory = 'chat_history';

  static Future<void> saveMessage(String role, String text) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(keyHistory) ?? [];
    history.add(jsonEncode({'role': role, 'text': text, 'time': DateTime.now().toIso8601String()}));
    if (history.length > 100) history = history.sublist(history.length - 100);
    await prefs.setStringList(keyHistory, history);
  }

  static Future<List<Map<String, dynamic>>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(keyHistory) ?? [];
    return history.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyHistory);
  }
}
