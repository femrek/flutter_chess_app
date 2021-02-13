import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mychess/data/storage_manager.dart';

import 'board_bloc.dart';
import 'board_event.dart';
import 'checkmate_cubit.dart';
import '../../widgetes/chess_table.dart';

class ScreenLocalGame extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScreenLocalGameState();
}

class _ScreenLocalGameState extends State<ScreenLocalGame> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('CHESS'),
        centerTitle: true,
      ),
      body: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ChessTable(
              size: width,
            ),
            Container(
              color: Colors.pink,
              child: BlocBuilder<CheckmateCubit, bool>(
                builder: (_, bool state) {
                  if (state) {
                    return Text(
                      'checkmate',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                      ),
                    );
                  }
                  else return Text('');
                },
              ),
            ),
            RaisedButton(
              onPressed: () async {
                if (await StorageManager().setLastGameFen(null)) {
                  context.read<BoardBloc>().add(BoardLoadEvent(restart: true));
                } else {
                  print('error');
                }
              },
              child: Text('restart'),
            ),
            RaisedButton(
              onPressed: () {
                context.read<BoardBloc>().add(BoardUndoEvent());
              },
              child: Text(
                'undo',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            RaisedButton(
              onPressed: () {
                context.read<BoardBloc>().add(BoardRedoEvent());
              },
              child: Text(
                'redo',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
