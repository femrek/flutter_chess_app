import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'host_checkmate_cubit.dart';
import 'single_player_chess_table.dart';

class ScreenLocalNetGame extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScreenLocalNetGameState();

}

class _ScreenLocalNetGameState extends State<ScreenLocalNetGame> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('CHESS'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SinglePlayerChessTable(size: width,),
          BlocBuilder<HostCheckmateCubit, bool>(
            builder: (_, bool checkmate) {
              return Text(checkmate ? 'checkmate' : '');
            },
          ),
        ],
      ),
      backgroundColor: Colors.black45,
    );
  }

}