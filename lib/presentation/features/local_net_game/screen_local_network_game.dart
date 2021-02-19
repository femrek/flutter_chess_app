import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mychess/presentation/features/local_net_game/local_host_event.dart';

import 'host_checkmate_cubit.dart';
import 'local_host_bloc.dart';
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
          RaisedButton(
            onPressed: () {
              context.read<LocalHostBloc>().add(LocalHostLoadEvent(restart: true));
            },
            child: Text('restart'),
          )
        ],
      ),
      backgroundColor: Colors.black45,
    );
  }

}