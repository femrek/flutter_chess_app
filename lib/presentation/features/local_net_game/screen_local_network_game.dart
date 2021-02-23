import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mychess/data/model/turn_model.dart';
import 'package:mychess/presentation/features/local_net_game/host_name_cubit.dart';
import 'package:mychess/presentation/features/local_net_game/host_redoable_cubit.dart';
import 'package:mychess/presentation/features/local_net_game/host_turn_cubit.dart';
import 'package:mychess/presentation/features/local_net_game/local_host_event.dart';

import 'local_host_bloc.dart';
import 'single_player_chess_table.dart';
import 'local_host_event.dart';

class ScreenLocalNetGame extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScreenLocalNetGameState();

}

class _ScreenLocalNetGameState extends State<ScreenLocalNetGame> {
  static const int _MENU_RESTART = 0x100;
  static const int _MENU_UNDO = 0x101;
  static const int _MENU_REDO = 0x102;

  @override
  void initState() {
    super.initState();
    initStateAsync();
  }


  Future initStateAsync() async {
    context.read<LocalHostBloc>().add(LocalHostStartEvent());
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        context.read<LocalHostBloc>().add(LocalHostStopEvent());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('CHESS'),
          centerTitle: true,
          actions: [
            BlocBuilder<HostRedoableCubit, bool>(
              builder: (_, bool redoable) {
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
              }
            ),
          ],
        ),
        body: Column(
          children: [
            SinglePlayerChessTable(size: width,),
            BlocBuilder<HostTurnCubit, TurnModel>(
              builder: (_, TurnModel turnModel) {
                final bool isWhiteTurn = turnModel.isWhiteTurn;
                final bool checkmate = turnModel.checkmate;
                if (checkmate) return Container(
                  child: Text(
                    'checkmate, ${isWhiteTurn ? 'black' : 'white'} is winner',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
                return Container(
                  child: Text(
                    isWhiteTurn ? 'white turn' : 'black turn',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
            BlocBuilder<HostNameCubit, String>(
              builder: (_, String hostName) {
                return Text(
                  hostName,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                );
              },
            )
          ],
        ),
        backgroundColor: Colors.black45,
      ),
    );
  }

  void _onMenuItemSeleced(int choice) {
    switch (choice) {
      case _MENU_RESTART:
        _showSureDialog(context, 'Are you sure to restart game', null, () {
          context.read<LocalHostBloc>().add(LocalHostLoadEvent(restart: true));
        });
        break;
      case _MENU_UNDO:
        context.read<LocalHostBloc>().add(LocalHostUndoEvent());
        break;
      case _MENU_REDO:
        context.read<LocalHostBloc>().add(LocalHostRedoEvent());
        break;
      default: break; 
    }
  }

  void _showSureDialog(BuildContext context, String title, String content, Function action) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return AlertDialog(
          title: title == null ? null : Text(title),
          content: content == null ? null : Text(content),
          actions: [
            FlatButton(
              onPressed: () {
                action();
                Navigator.pop(_);
              },
              child: Text('yes'),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(_);
              },
              child: Text('no'),
            ),
          ],
        );
      }
    );
  }

}