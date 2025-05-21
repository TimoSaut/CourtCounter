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
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          children: [
            const Text('settings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            SwitchListTile(
              title: const Text('dark mode'),
              value: isDarkMode,
              onChanged: onThemeToggle,
              contentPadding: EdgeInsets.zero,
            ),
            const Divider(height: 32),
            ListTile(
              title: const Text('clear match history'),
              trailing: const Icon(Icons.delete),
              onTap: () async {
                await HistoryRepository.clearHistory();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("match history cleared")),
                );
              },
            ),
            ListTile(
              title: const Text('export match history'),
              trailing: const Icon(Icons.upload_file),
              onTap: () async {
                final json = await HistoryRepository.exportHistoryAsJson();
                await Clipboard.setData(ClipboardData(text: json));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("history copied to clipboard")),
                );
              },
            ),
            ListTile(
              title: const Text('import match history'),
              trailing: const Icon(Icons.download),
              onTap: () {
                final controller = TextEditingController();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("paste json"),
                    content: TextField(
                      controller: controller,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: "paste exported json here",
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
                              SnackBar(content: Text("invalid json: $e")),
                            );
                          }
                        },
                        child: const Text("import"),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('load sample matches'),
              trailing: const Icon(Icons.info),
              onTap: () async {
                await HistoryRepository.importSampleMatchesFromAssets();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("sample matches imported")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
