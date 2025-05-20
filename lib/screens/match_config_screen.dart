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
  final theme = Theme.of(context);
  final textTheme = theme.textTheme;

  return Scaffold(
    backgroundColor: theme.scaffoldBackgroundColor,
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "match settings",
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          TextField(
            style: textTheme.bodyLarge,
            decoration: InputDecoration(
              labelText: "Player 1",
              labelStyle: textTheme.labelMedium,
            ),
            onChanged: (val) {
              player1 = val;
              _updateNames();
            },
          ),
          const SizedBox(height: 16),
          TextField(
            style: textTheme.bodyLarge,
            decoration: InputDecoration(
              labelText: "Player 2",
              labelStyle: textTheme.labelMedium,
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
              Text("sets to win", style: textTheme.bodyLarge),
              DropdownButton<int>(
                value: sets,
                dropdownColor: theme.cardColor,
                style: textTheme.bodyLarge,
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
              Text("games per set", style: textTheme.bodyLarge),
              DropdownButton<int>(
                value: games,
                dropdownColor: theme.cardColor,
                style: textTheme.bodyLarge,
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
          Text(
            "swipe right to start the match",
            style: textTheme.labelMedium,
          ),
        ],
      ),
    ),
  );
}
}
