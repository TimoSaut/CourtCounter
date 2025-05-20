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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Expanded(
                child: _history.isEmpty
                    ? Center(child: Text("No matches recorded", style: textTheme.bodyMedium))
                    : ListView.builder(
                        itemCount: _history.length,
                        itemBuilder: (context, index) {
                          final entry = _history[index];
                          final parts = entry.split(';');
                          if (parts.length < 4) return const SizedBox();

                          final player1 = parts[0];
                          final player2 = parts[1];
                          final winner = parts[2];
                          final setResults = parts[3].split(',');

                          final p1SetScores = <String>[];
                          final p2SetScores = <String>[];

                          for (final set in setResults) {
                            final scores = set.split('-');
                            if (scores.length == 2) {
                              p1SetScores.add(scores[0]);
                              p2SetScores.add(scores[1]);
                            }
                          }

                          final name1 = player1 == winner ? '$player1 ⭐️' : player1;
                          final name2 = player2 == winner ? '$player2 ⭐️' : player2;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 140,
                                      child: Text(name1, style: textTheme.bodyMedium),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 24),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: p1SetScores
                                              .map((s) => Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                                    child: Text(s, style: textTheme.bodyMedium),
                                                  ))
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 140,
                                      child: Text(name2, style: textTheme.bodyMedium),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 24),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: p2SetScores
                                              .map((s) => Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                                    child: Text(s, style: textTheme.bodyMedium),
                                                  ))
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
