import 'package:flutter/material.dart';
import 'blocs/score_bloc.dart';
import 'screens/match_screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: MatchScreen(bloc: ScoreBloc()),
    ),
  );
}
