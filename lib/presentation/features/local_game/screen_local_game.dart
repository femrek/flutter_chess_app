import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mychess/data/storage_manager.dart';
import 'package:mychess/presentation/features/local_game/redoable_cubit.dart';

import 'board_bloc.dart';
import 'board_event.dart';
import 'checkmate_cubit.dart';
import '../../widgetes/chess_table.dart';

class ScreenLocalGame extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScreenLocalGameState();
}

class _ScreenLocalGameState extends State<ScreenLocalGame> {
  static const int _MENU_RESTART = 0x00;
  static const int _MENU_UNDO = 0x01;
  static const int _MENU_REDO = 0x02;

  void _onMenuItemSeleced(int choice) {
    switch (choice) {
      case _MENU_RESTART:
        context.read<BoardBloc>().add(BoardLoadEvent(restart: true));
        break;
      case _MENU_UNDO:
        context.read<BoardBloc>().add(BoardUndoEvent());
        break;
      case _MENU_REDO:
        context.read<BoardBloc>().add(BoardRedoEvent());
        break;
      default: break; 
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('CHESS'),
        centerTitle: true,
        actions: [
          BlocBuilder<RedoableCubit, bool>(
            builder: (BuildContext _, bool redoable) {
              return PopupMenuButton<int>(
                onSelected: _onMenuItemSeleced,
                itemBuilder: (_) {
                  return <PopupMenuEntry<int>>[
                    PopupMenuItem(
                      enabled: true,
                      value: _MENU_RESTART,
                      child: Text('restart'),
                    ),
                    PopupMenuItem(
                      enabled: true,
                      value: _MENU_UNDO,
                      child: Text('undo'),
                    ),
                    PopupMenuItem(
                      enabled: redoable,
                      value: _MENU_REDO,
                      child: Text('redo'),
                    ),
                  ];
                },
              );
            },
            buildWhen: (bool oldState, bool newState) {
              if (oldState != newState) return true;
              return false;
            },
          ),
        ],
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
                buildWhen: (oldValue, newValue) {
                  if (oldValue != newValue) return true;
                  return false;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
