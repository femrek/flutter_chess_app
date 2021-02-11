import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'board_bloc.dart';
import 'board_event.dart';
import 'checkmate_cubit.dart';
import '../widgetes/chess_table.dart';

class ScreenMain extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMain> {
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
            Visibility(
              visible: false,
              child: Center(child: RaisedButton(
                onPressed: () {
                  context.read<BoardBloc>().add(BoardUndoEvent());
                },
                child: Text(
                  'undo',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),),
            ),
          ],
        ),
      ),
    );
  }
}
