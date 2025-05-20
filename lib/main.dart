import 'package:flutter/material.dart';
import 'blocs/score_bloc.dart' as logic;
import 'screens/match_config_screen.dart';
import 'screens/match_history_screen.dart';
import 'screens/match_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const CourtCounterApp());
}

class CourtCounterApp extends StatefulWidget {
  const CourtCounterApp({super.key});

  @override
  State<CourtCounterApp> createState() => _CourtCounterAppState();
}

class _CourtCounterAppState extends State<CourtCounterApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(primary: Colors.yellow),
      ),
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(primary: Colors.lightBlue),
      ),
      home: HomePage(onThemeToggle: _toggleTheme, themeMode: _themeMode),
    );
  }
}

class HomePage extends StatefulWidget {
  final void Function(bool isDark) onThemeToggle;
  final ThemeMode themeMode;

  const HomePage({
    super.key,
    required this.onThemeToggle,
    required this.themeMode,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _controller = PageController();
  final logic.ScoreBloc bloc = logic.ScoreBloc();
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
    bloc.updatePlayerNames(name1, name2);
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
                const MatchHistoryScreen(),
                SettingsScreen(
                  onThemeToggle: widget.onThemeToggle,
                  isDarkMode: widget.themeMode == ThemeMode.dark,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                final isActive = _pageIndex == index;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: isActive ? 10 : 8,
                  height: isActive ? 50 : 8,
                  decoration: BoxDecoration(
                    color: isActive
                        ? Theme.of(context).colorScheme.onBackground
                        : Theme.of(context).colorScheme.onBackground.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
