import 'package:flutter/material.dart';
import 'blocs/score_bloc.dart';
import 'screens/match_screen.dart';
import 'screens/match_config_screen.dart';

void main() {
  runApp(const CourtCounterApp());
}

class CourtCounterApp extends StatelessWidget {
  const CourtCounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(
        primary: Colors.yellow,
       ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _controller = PageController();
  final ScoreBloc bloc = ScoreBloc();
  int _pageIndex = 0;

  String _player1Name = 'Player 1';
  String _player2Name = 'Player 2';
  int _setsToWin = 3;
  int _gamesToWin = 6;

  @override
  void dispose() {
    bloc.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onPlayerNamesChanged(String name1, String name2) {
    setState(() {
      _player1Name = name1;
      _player2Name = name2;
    });
  }

  void _onSettingsChanged(int sets, int games) {
    setState(() {
      _setsToWin = sets;
      _gamesToWin = games;
    });
    bloc.updateMatchRules(sets: sets, games: games);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (index) {
                setState(() => _pageIndex = index);
                if (index == 1) {
                  bloc.updateMatchRules(sets: _setsToWin, games: _gamesToWin);
                }
              },
              children: [
                MatchConfigScreen(
                  bloc: bloc,
                  onNamesChanged: _onPlayerNamesChanged,
                  onSettingsChanged: _onSettingsChanged,
                ),
                MatchScreen(
                  bloc: bloc,
                  player1: _player1Name,
                  player2: _player2Name,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(2, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: _pageIndex == index ? 10 : 8,
                  height: _pageIndex == index ? 50 : 8,
                  decoration: BoxDecoration(
                    color: _pageIndex == index ? Colors.white : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}
