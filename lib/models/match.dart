class Match {
  final List<int> score;
  final List<int> games;
  final List<int> sets;

  const Match({
    required this.score,
    required this.games,
    required this.sets,
  });

  factory Match.initial() => const Match(
        score: [0, 0],
        games: [0, 0],
        sets: [0, 0],
      );

  Match copyWith({
    List<int>? score,
    List<int>? games,
    List<int>? sets,
  }) {
    return Match(
      score: score ?? [...this.score],
      games: games ?? [...this.games],
      sets: sets ?? [...this.sets],
    );
  }
}
