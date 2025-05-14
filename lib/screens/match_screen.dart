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
    this.player1 = "Timo",
    this.player2 = "Marcel",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
                          Text(
                            player1,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            player2,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatScore(current.score[0], current.score[1]),
                      style: const TextStyle(
                        fontSize: 80,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    _buildScoreRow('game', current.games[0], current.games[1]),
                    const SizedBox(height: 20),
                    _buildScoreRow('set', current.sets[0], current.sets[1]),
                  ],
                );
              },
            ),
          ),
          Positioned.fill(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => bloc.addPoint(1),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => bloc.addPoint(2),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreRow(String label, int leftValue, int rightValue) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$leftValue',
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 40),
            Text(
              '$rightValue',
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  String _formatScore(int a, int b) {
    if (a == 45) return 'AD-40';
    if (b == 45) return '40-AD';
    return '${a.toString().padLeft(2, '0')}-${b.toString().padLeft(2, '0')}';
  }
}
