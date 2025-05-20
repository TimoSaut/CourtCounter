import 'package:flutter/material.dart';
import '../blocs/score_bloc.dart';
import '../models/match.dart';

class MatchScreen extends StatelessWidget {
  final ScoreBloc bloc;
  final String player1;
  final String player2;

  const MatchScreen({
    super.key,
    required this.bloc,
    this.player1 = "Player 1",
    this.player2 = "Player 2",
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Center(
            child: StreamBuilder<Match>(
              stream: bloc.matchStream,
              builder: (context, snapshot) {
                final current = snapshot.data ?? Match.initial();
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 120),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(player1, style: textTheme.bodySmall),
                          Text(player2, style: textTheme.bodySmall),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatScore(current.score[0], current.score[1]),
                      style: textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 40),
                    _buildScoreRow(context, 'Games', current.games[0], current.games[1]),
                    const SizedBox(height: 20),
                    _buildScoreRow(context, 'Sets', current.sets[0], current.sets[1]),
                  ],
                );
              },
            ),
          ),
          Positioned.fill(
            child: Row(
              children: [
                Expanded(child: GestureDetector(onTap: () => bloc.addPoint(1))),
                Expanded(child: GestureDetector(onTap: () => bloc.addPoint(2))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreRow(BuildContext context, String label, int left, int right) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$left', style: textTheme.titleLarge),
            const SizedBox(width: 40),
            Text('$right', style: textTheme.titleLarge),
          ],
        ),
        const SizedBox(height: 4),
        Text(label, style: textTheme.labelSmall),
      ],
    );
  }

  String _formatScore(int a, int b) {
    if (a == 45) return 'AD-40';
    if (b == 45) return '40-AD';
    return '${a.toString().padLeft(2, '0')}-${b.toString().padLeft(2, '0')}';
  }
}
