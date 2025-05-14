import 'dart:async';
import '../models/match.dart';

class ScoreBloc {
  final _matchController = StreamController<Match>.broadcast();
  Match _currentMatch = Match.initial();

  Stream<Match> get matchStream => _matchController.stream;

  void addPoint(int player) {
    _currentMatch = _calculateScore(_currentMatch, player);
    _matchController.add(_currentMatch);
  }

  Match _calculateScore(Match current, int player) {
    final opponent = player == 1 ? 2 : 1;
    final newScore = [...current.score];
    final newGames = [...current.games];
    final newSets = [...current.sets];

    if (current.score[0] == 40 && current.score[1] == 40) {
      newScore[player - 1] = 45;
      return current.copyWith(score: newScore);
    }

    if (current.score[player - 1] == 45) {
      newGames[player - 1]++;
      return Match(score: [0, 0], games: newGames, sets: current.sets);
    }

    if (current.score[opponent - 1] == 45) {
      return current.copyWith(score: [40, 40]);
    }

    if (newScore[player - 1] < 40) {
      newScore[player - 1] += newScore[player - 1] == 30 ? 10 : 15;
      return current.copyWith(score: newScore);
    }

    newGames[player - 1]++;

    if (newGames[player - 1] >= 6 &&
        (newGames[player - 1] - newGames[opponent - 1] >= 2)) {
      newSets[player - 1]++;
      if (newSets[player - 1] == 3) {
        return Match.initial();
      }
      return Match(score: [0, 0], games: [0, 0], sets: newSets);
    }

    return Match(score: [0, 0], games: newGames, sets: current.sets);
  }

  void dispose() => _matchController.close();
}
