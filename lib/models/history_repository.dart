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
}
