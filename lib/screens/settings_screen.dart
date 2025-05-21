import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
              const Text('settings', style: TextStyle(fontSize: 22)),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('dark mode'),
                  Switch(
                    value: isDarkMode,
                    onChanged: onThemeToggle,
                  ),
                ],
              ),
              const SizedBox(height: 60),

              ElevatedButton(
                onPressed: () async {
                  await HistoryRepository.clearHistory();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("match history cleared")),
                  );
                },
                child: const Text('clear match history'),
              ),

              const SizedBox(height: 70),

              ElevatedButton(
                onPressed: () async {
                  final json = await HistoryRepository.exportHistoryAsJson();
                  await Clipboard.setData(ClipboardData(text: json));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("history copied to clipboard")),
                  );
                },
                child: const Text('export match history'),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  final controller = TextEditingController();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("paste JSON"),
                      content: TextField(
                        controller: controller,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: "paste exported JSON here",
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            try {
                              await HistoryRepository.importHistoryFromJson(controller.text);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("import successful")),
                              );
                              Navigator.of(context).pop();
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("invalid JSON: $e")),
                              );
                            }
                          },
                          child: const Text("import"),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('import match history'),
              ),

              const SizedBox(height: 180),

              ElevatedButton(
                onPressed: () async {
                  await HistoryRepository.importSampleMatchesFromAssets();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("sample matches imported")),
                  );
                },
                child: const Text('import sample matches'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
