import 'dart:async';
import '../models/match.dart';
import '../models/history_repository.dart';

class ScoreBloc {
  final _matchController = StreamController<Match>.broadcast();
  Match _currentMatch = Match.initial();

  int _setsToWin = 3;
  int _gamesToWin = 6;
  String _player1Name = "Player 1";
  String _player2Name = "Player 2";
  final List<List<int>> _setResults = [];

  Stream<Match> get matchStream => _matchController.stream;

  void addPoint(int player) {
    _currentMatch = _calculateScore(_currentMatch, player);
    _matchController.add(_currentMatch);
  }

  void updateMatchRules({required int sets, required int games}) {
    _setsToWin = sets;
    _gamesToWin = games;
    _currentMatch = Match.initial();
    _setResults.clear();
    _matchController.add(_currentMatch);
  }

  void updatePlayerNames(String name1, String name2) {
    _player1Name = name1;
    _player2Name = name2;
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
      newScore[0] = 0;
      newScore[1] = 0;

      if (newGames[player - 1] >= _gamesToWin &&
          (newGames[player - 1] - newGames[opponent - 1] >= 2)) {
        newSets[player - 1]++;
        _setResults.add([...newGames]);
        newGames[0] = 0;
        newGames[1] = 0;

        if (newSets[player - 1] == _setsToWin) {
          final winner = player == 1 ? _player1Name : _player2Name;
          final setResultStrings = _setResults.map((s) => "${s[0]}-${s[1]}").toList();
          HistoryRepository.addMatch(
            _player1Name,
            _player2Name,
            winner,
            setResultStrings,
          );

          _setResults.clear();
          return Match.initial();
        }

        return Match(score: [0, 0], games: [0, 0], sets: newSets);
      }

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
    newScore[0] = 0;
    newScore[1] = 0;

    if (newGames[player - 1] >= _gamesToWin &&
        (newGames[player - 1] - newGames[opponent - 1] >= 2)) {
      newSets[player - 1]++;
      _setResults.add([...newGames]);
      newGames[0] = 0;
      newGames[1] = 0;

      if (newSets[player - 1] == _setsToWin) {
        final winner = player == 1 ? _player1Name : _player2Name;
        final setResultStrings = _setResults.map((s) => "${s[0]}-${s[1]}").toList();
        HistoryRepository.addMatch(
          _player1Name,
          _player2Name,
          winner,
          setResultStrings,
        );

        _setResults.clear();
        return Match.initial();
      }

      return Match(score: [0, 0], games: [0, 0], sets: newSets);
    }

    return Match(score: [0, 0], games: newGames, sets: current.sets);
  }

  void dispose() => _matchController.close();
}
