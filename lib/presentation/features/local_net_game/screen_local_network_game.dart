import 'package:flutter/material.dart';
import 'package:mychess/presentation/features/local_game/chess_table.dart';
import 'package:mychess/presentation/features/local_net_game/single_player_chess_table.dart';

class ScreenLocalNetGame extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScreenLocalNetGameState();

}

class _ScreenLocalNetGameState extends State<ScreenLocalNetGame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CHESS'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SinglePlayerChessTable(),
        ],
      ),
    );
  }

}