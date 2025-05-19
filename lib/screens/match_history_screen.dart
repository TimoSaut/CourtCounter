import 'package:flutter/material.dart';
import '../models/history_repository.dart';

class MatchHistoryScreen extends StatefulWidget {
  const MatchHistoryScreen({super.key});

  @override
  State<MatchHistoryScreen> createState() => _MatchHistoryScreenState();
}

class _MatchHistoryScreenState extends State<MatchHistoryScreen> {
  List<String> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await HistoryRepository.getHistory();
    setState(() {
      _history = history;
    });
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.black,
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Expanded(
              child: _history.isEmpty
                  ? const Center(
                      child: Text("No matches recorded", style: TextStyle(color: Colors.white)),
                    )
                  : ListView.builder(
                      itemCount: _history.length,
                      itemBuilder: (context, index) {
                        final entry = _history[index];
                        final parts = entry.split(';');
                        final player1 = parts[0];
                        final player2 = parts[1];
                        final result = parts[2];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(player1, style: const TextStyle(fontSize: 16, color: Colors.white)),
                                    Text(player2, style: const TextStyle(fontSize: 16, color: Colors.white)),
                                  ],
                                ),
                              ),
                              Text(result, style: const TextStyle(fontSize: 16, color: Colors.white)),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await HistoryRepository.clearHistory();
                final newHistory = await HistoryRepository.getHistory();
                setState(() {
                  _history = newHistory;
                });
              },
              child: const Text('Clear History'),
            ),
          ],
        ),
      ),
    ),
  );
}
}