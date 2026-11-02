import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AppStorage {
  static const String _key = 'solo_chat_history';

  static Future<void> saveChat(String userText, String aiText) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getChatHistory();
    history.add({'user': userText, 'ai': aiText});
    if (history.length > 50) {
      history.removeAt(0);
    }
    await prefs.setString(_key, jsonEncode(history));
  }

  static Future<List<Map<String, String>>> getChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);
    if (data == null) return [];
    final List decoded = jsonDecode(data);
    return decoded.map((e) => Map<String, String>.from(e)).toList();
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
