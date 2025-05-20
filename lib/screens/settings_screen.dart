import 'package:flutter/material.dart';
import '../models/history_repository.dart';

class SettingsScreen extends StatelessWidget {
  final void Function(bool isDark) onThemeToggle;
  final bool isDarkMode;

  const SettingsScreen({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Settings',
                style: TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Dark Mode'),
                  Switch(
                    value: isDarkMode,
                    onChanged: onThemeToggle,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  await HistoryRepository.clearHistory();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Match history cleared")),
                  );
                },
                child: const Text('Clear Match History'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
