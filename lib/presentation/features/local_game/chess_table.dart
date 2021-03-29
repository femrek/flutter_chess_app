import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as ch;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'board_bloc.dart';
import 'board_event.dart';
import 'board_state.dart';
import 'package:mychess/data/app_theme.dart';

class ChessTable extends StatelessWidget {
  final double size;

  ChessTable({this.size = 200, Key key}) : super(key: key);

  final List<SquareOnTheBoard> squares = List();


  static const double ninetyDegres = 3.1415926435 / 2;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: boardBgColor,
      child: _table(context),
    );
  }

  Widget _table(BuildContext context) {
    return Row(
      children: List.generate(8, (index) => _tableColumn(context, index))
        ..insert(0, _letterColumn(context, true))
        ..add(_letterColumn(context, false))
    );
  }

  Column _tableColumn(BuildContext context, int y) {
    return Column(
      children: List.generate(8, (index) => _square(context, y, index))
        ..insert(0, _text(context, (y+1).toString() , true, true))
        ..add(_text(context, (y+1).toString() , true, false)),
    );
  }

  Widget _square(BuildContext context, int y, int x) {
    final double squareSize = size / 9;
    //print("creating square with: (${x + y*16}) ${(chess.board[x + y*16]?.type?.toString() ?? '') + (chess.board[x + y*16]?.color?.toString() ?? '')}");
    return BlocBuilder<BoardBloc, BoardState>(
      builder: (_, state) {
        if (state is BoardLoadedState) {
          return SquareOnTheBoard(
            size: squareSize,
            positionX: x,
            positionY: y,
            piece: state.board[x][y],
            inCheck: (state.inCheck ?? false) 
              && (state.board[x][y]?.type?.name?.toLowerCase() ?? '') == 'k'
              && state.isWhiteTurn == ((state.board[x][y]?.color ?? -1) == ch.Color.WHITE),
          );
        }

        else if (state is BoardFocusedState) {
          return SquareOnTheBoard(
            size: squareSize,
            positionX: x,
            positionY: y,
            piece: state.board[x][y],
            inCheck:  (state.inCheck ?? false) 
              && (state.board[x][y]?.type?.name?.toLowerCase() ?? '') == 'k'
              && state.isWhiteTurn == ((state.board[x][y]?.color ?? -1) == ch.Color.WHITE),
          );
        }

        return SizedBox(
          height: size,
          width: size,
        );
      },
      buildWhen: (oldState, newState) {
        final String name = '${String.fromCharCode(x+97)}${y+1}';
        if (newState is BoardLoadedState) {
          if (oldState is BoardFocusedState) {
            /*final bool a1 = (name!='a1' && name!='a8' && name!='h1' && name!='h8');
            final bool a3 = (!oldState.movableCoors.contains(name));
            final bool a4 = (oldState.focusedCoor != name);
            final bool a5 = (!newState.movablePiecesCoors.contains(name));
            final bool a6 = (oldState.lastMoveFrom != name);
            final bool a7 = (oldState.lastMoveTo != name);
            print('$name ---- 1: $a1 | 3: $a3 | 4: $a4 | 5: $a5 | 6: $a6 | 7: $a7');
            if (a1 && a3 && a4 && a5 && a6 && a7) return false;*/
            if (   (!newState.movablePiecesCoors.contains(name))
                && (!oldState.movableCoors.contains(name))
                && (oldState.focusedCoor != name)
                && (oldState.lastMoveFrom != name)
                && (oldState.lastMoveTo != name)
                && (name!='a1' && name!='a8' && name!='h1' && name!='h8'))
              return false;
          }
        } else if (newState is BoardFocusedState) {
          if (oldState is BoardLoadedState) {
            if (!newState.movableCoors.contains(name)
                && newState.focusedCoor != name
                && !oldState.movablePiecesCoors.contains(name))
              return false;
          }
        }
        return true;
      },
    );
  
  }

  Column _letterColumn(BuildContext context, bool isRight) {
    return Column(
      children: List.generate(8, (index) =>
       _text(context, String.fromCharCode(65+index), false, isRight))
         ..insert(0, SizedBox(height: size/18,))
         ..add(SizedBox(height: size/18,)),
    );
  }

  Widget _text(BuildContext context, String content, bool horizontalSide, bool turnRight) {
    return Container(
      width: size / (horizontalSide ? 9 : 18),
      height: size / (!horizontalSide ? 9 : 18),
      alignment: Alignment.center,
      child: Transform.rotate(
        angle: turnRight ? ninetyDegres : -ninetyDegres,
        child: Text(
          content,
          style: TextStyle(
            color: Colors.white,
            fontSize: size/25/MediaQuery.of(context).textScaleFactor,
          ),
        ),
      ),
    );
  }
}


class SquareOnTheBoard extends StatelessWidget {
  final double size;
  final int positionX;
  final int positionY;
  final ch.Piece piece;
  final bool inCheck;

  SquareOnTheBoard({
    this.size,
    this.positionX,
    this.positionY,
    this.piece,
    this.inCheck = false,
    Key key}):super(key: key);

  String get name => '${String.fromCharCode(97+positionX)}${positionY+1}';
  bool get isDark => (positionX + positionY) % 2 == 0;


  bool movable = false;
  bool movableToThis = false;
  bool attackableToThis = false;
  bool moveFrom = false;
  bool lastMoveFromThis = false;
  bool lastMoveToThis = false;

  @override
  Widget build(BuildContext context) {
    if (context.read<BoardBloc>().state is BoardLoadedState) {
      //print(name);
      movable = (context.read<BoardBloc>().state as BoardLoadedState).movablePiecesCoors.contains(name);
      lastMoveFromThis = (context.read<BoardBloc>().state as BoardLoadedState).lastMoveFrom == name;
      lastMoveToThis = (context.read<BoardBloc>().state as BoardLoadedState).lastMoveTo == name;
    } else if (context.read<BoardBloc>().state is BoardFocusedState) {
      movableToThis = (context.read<BoardBloc>().state as BoardFocusedState).movableCoors.contains(name);
      if (piece != null && movableToThis) {
        attackableToThis = true;
        movableToThis = false;
      }
      if ((context.read<BoardBloc>().state as BoardFocusedState).focusedCoor == name) {
        moveFrom = true;
      }
      lastMoveFromThis = (context.read<BoardBloc>().state as BoardFocusedState).lastMoveFrom == name;
      lastMoveToThis = (context.read<BoardBloc>().state as BoardFocusedState).lastMoveTo == name;
    }

    Color darkBg = darkBgColor;
    Color lightBg = lightBgColor;
    if (attackableToThis) {
      darkBg = Colors.red;
      lightBg = Colors.red;
    } else if (inCheck) {
      darkBg = Colors.red;
      lightBg = Colors.red;
    }

    return DragTarget<String>(
      onAccept: (focusCoor) {
        //print('movableToThis || attackableToThis : ${(movableToThis || attackableToThis)}');
        if (movableToThis || attackableToThis)
          context.read<BoardBloc>().add(BoardMoveEvent(to: name));
        else {
          context.read<BoardBloc>().add(BoardMoveEvent());
        }
      },
      builder: (_, list1, list2) {
        return Draggable<String>(
          data: name,
          onDragStarted: () {
            context.read<BoardBloc>().add(BoardFocusEvent(focusCoor: name));
          },
          maxSimultaneousDrags: movable ? null : 0,
          childWhenDragging: _container(darkBg, lightBg, null),
          feedback: _pieceImage(),
          child: _allOfSquare(context, darkBg, lightBg),
        );
      },
    );
  }

  Widget _allOfSquare(BuildContext context, Color darkBg, Color lightBg) {
    return GestureDetector(
      onTap: () {
        if (context.read<BoardBloc>().state is BoardLoadedState) {
          if (movable) {
            context.read<BoardBloc>().add(BoardFocusEvent(focusCoor: name));
          }
        } else if (context.read<BoardBloc>().state is BoardFocusedState) {
          if (movableToThis || attackableToThis|| moveFrom) {
            context.read<BoardBloc>().add(BoardMoveEvent(to: name));
          } else {
            context.read<BoardBloc>().add(BoardMoveEvent());
          }
        }
      },
      child: _container(darkBg, lightBg, Stack(
        children: [
          _moveDots(),
          _pieceImage(),
          _lastMoveImage(),
        ],
      )),
    );
  }

  Widget _container(Color darkBg, Color lightBg, Widget child) {
    return Container(
        width: size,
        height: size,
        color: isDark ? darkBg : lightBg,
        alignment: Alignment.center,
        child: child ?? Container(),
    );
  }

  Widget _moveDots() {
    if (movableToThis) {
      return Container(
        alignment: Alignment.center,
        child: Container(
          height: size*0.4,
          width: size*0.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9999),
            color: Colors.green,
          ),
        ),
      );
    } else if (attackableToThis) {
      return Container(
        alignment: Alignment.center,
        child: Container(
          height: size*0.8,
          width: size*0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9999),
            color: isDark ? darkBgColor : lightBgColor,
          ),
        ),
      );
    }
    return Container();
  }

  Widget _pieceImage() {
    if (piece == null) return Container();
    final String pieceName = pieceNameToAssetName[piece?.type?.name];
    final bool isBlack = piece.color.value == 1;
    return Transform.rotate(
      angle: isBlack ? -ninetyDegree : ninetyDegree,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        child: SizedBox(
          height: size*pieceNameToScale[pieceName],
          width: size*pieceNameToScale[pieceName],
          child: (pieceName != null) ?
            SvgPicture.asset(
              'assets/images/$pieceName.svg',
              color: isBlack ? blackPiecesColor : whitePiecesColor,
            ) : null,
        ),
      ),
    );
  }

  Widget _lastMoveImage() {
    if (lastMoveFromThis) return Container(
      child: Text('from'),
    );
    else if (lastMoveToThis) return Container(
      child: Text('to'),
    );
    return Container();
  }

  static const Map<String, String> pieceNameToAssetName = {
    'r': 'rok',
    'n': 'knight',
    'b': 'bishop',
    'q': 'queen',
    'k': 'king',
    'p': 'pawn',
    null: null,
  };
  static const Map<String, double> pieceNameToScale = {
    'rok': 0.68,
    'knight': 0.68,
    'bishop': 0.7,
    'queen': 0.8,
    'king': 0.8,
    'pawn': 0.55,
    null: 0.8,
  };
  static const double PI = 3.1415926535;
  static const double ninetyDegree = PI / 2;
}
