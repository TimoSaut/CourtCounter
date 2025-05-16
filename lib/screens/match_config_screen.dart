import 'package:flutter/material.dart';
import '../blocs/score_bloc.dart';

class MatchConfigScreen extends StatefulWidget {
  final ScoreBloc bloc;
  final void Function(String player1, String player2)? onNamesChanged;
  final void Function(int sets, int games)? onSettingsChanged;

  const MatchConfigScreen({
    super.key,
    required this.bloc,
    this.onNamesChanged,
    this.onSettingsChanged,
  });

  @override
  State<MatchConfigScreen> createState() => _MatchConfigScreenState();
}

class _MatchConfigScreenState extends State<MatchConfigScreen> {
  int sets = 3;
  int games = 6;
  String player1 = "Player 1";
  String player2 = "Player 2";

  void _updateNames() {
    widget.onNamesChanged?.call(player1, player2);
  }

  void _updateSettings() {
    widget.onSettingsChanged?.call(sets, games);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "match settings",
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
            const SizedBox(height: 20),
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Player 1",
                labelStyle: TextStyle(color: Colors.grey),
              ),
              onChanged: (val) {
                player1 = val;
                _updateNames();
              },
            ),
            const SizedBox(height: 16),
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Player 2",
                labelStyle: TextStyle(color: Colors.grey),
              ),
              onChanged: (val) {
                player2 = val;
                _updateNames();
              },
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("sets to win", style: TextStyle(color: Colors.white)),
                DropdownButton<int>(
                  value: sets,
                  dropdownColor: Colors.grey[900],
                  style: const TextStyle(color: Colors.white),
                  items: List.generate(6, (index) => index + 1)
                      .map((val) => DropdownMenuItem(
                            value: val,
                            child: Text("$val"),
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      sets = val ?? 3;
                      _updateSettings();
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("games per set", style: TextStyle(color: Colors.white)),
                DropdownButton<int>(
                  value: games,
                  dropdownColor: Colors.grey[900],
                  style: const TextStyle(color: Colors.white),
                  items: List.generate(6, (index) => index + 1)
                      .map((val) => DropdownMenuItem(
                            value: val,
                            child: Text("$val"),
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      games = val ?? 6;
                      _updateSettings();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              "swipe right to start the match",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
