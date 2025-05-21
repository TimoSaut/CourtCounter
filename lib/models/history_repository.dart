import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryRepository {
  static const String _historyKey = 'matchHistory';

  static Future<List<String>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_historyKey) ?? [];
  }

  static Future<void> addMatch(
    String player1,
    String player2,
    String winner,
    List<String> setResults,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_historyKey) ?? [];
    final entry = "$player1;$player2;$winner;${setResults.join(',')}";
    history.add(entry);
    await prefs.setStringList(_historyKey, history);
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }

  static Future<String> exportHistoryAsJson() async {
    final history = await getHistory();
    return jsonEncode(history);
  }

  static Future<void> importHistoryFromJson(String jsonString) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final List<dynamic> parsed = jsonDecode(jsonString);
      final List<String> stringList = parsed.cast<String>();
      await prefs.setStringList(_historyKey, stringList);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> importSampleMatchesFromAssets() async {
    final jsonString = await rootBundle.loadString('assets/sample_matches.json');
    await importHistoryFromJson(jsonString);
  }
}
