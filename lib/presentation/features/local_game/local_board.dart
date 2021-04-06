import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as ch;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mychess/utils.dart';

import 'board_bloc.dart';
import 'board_event.dart';
import 'board_state.dart';
import 'package:mychess/data/app_theme.dart';

class LocalBoard extends StatelessWidget {
  final double size;

  LocalBoard({this.size = 200, Key key}) : super(key: key);

  final List<_SquareOnTheBoard> squares = List();


  static const double ninetyDegres = 3.1415926435 / 2;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: boardBgColor,
      child: Container(
        child: _table(context),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              spreadRadius: 5,
            )
          ]
        ),
      ),
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
    return BlocBuilder<BoardBloc, BoardState>(
      builder: (_, state) {
        if (state is BoardLoadedState) {
          return _SquareOnTheBoard(
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
          return _SquareOnTheBoard(
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


class _SquareOnTheBoard extends StatelessWidget {
  final double size;
  final int positionX;
  final int positionY;
  final ch.Piece piece;
  final bool inCheck;

  _SquareOnTheBoard({
    this.size,
    this.positionX,
    this.positionY,
    this.piece,
    this.inCheck = false,
    Key key}):super(key: key);

  String get name => '${String.fromCharCode(97+positionX)}${positionY+1}';
  bool get isDark => (positionX + positionY) % 2 == 0;


  bool _movable = false;
  bool _movableToThis = false;
  bool _attackableToThis = false;
  bool _moveFrom = false;
  bool _lastMoveFromThis = false;
  bool _lastMoveToThis = false;

  @override
  Widget build(BuildContext context) {
    if (context.read<BoardBloc>().state is BoardLoadedState) {
      _movable = (context.read<BoardBloc>().state as BoardLoadedState).movablePiecesCoors.contains(name);
      _lastMoveFromThis = (context.read<BoardBloc>().state as BoardLoadedState).lastMoveFrom == name;
      _lastMoveToThis = (context.read<BoardBloc>().state as BoardLoadedState).lastMoveTo == name;
    } else if (context.read<BoardBloc>().state is BoardFocusedState) {
      _movableToThis = (context.read<BoardBloc>().state as BoardFocusedState).movableCoors.contains(name);
      if (piece != null && _movableToThis) {
        _attackableToThis = true;
        _movableToThis = false;
      }
      if ((context.read<BoardBloc>().state as BoardFocusedState).focusedCoor == name) {
        _moveFrom = true;
      }
      _lastMoveFromThis = (context.read<BoardBloc>().state as BoardFocusedState).lastMoveFrom == name;
      _lastMoveToThis = (context.read<BoardBloc>().state as BoardFocusedState).lastMoveTo == name;
    }

    Color darkBg = darkBgColor;
    Color lightBg = lightBgColor;
    if (_attackableToThis) {
      darkBg = Colors.red;
      lightBg = Colors.red;
    } else if (inCheck) {
      darkBg = Colors.red;
      lightBg = Colors.red;
    } else if (_moveFrom) {
      darkBg = Colors.green;
      lightBg = Colors.green;
    }

    return DragTarget<String>(
      onAccept: (focusCoor) {
        if (_movableToThis || _attackableToThis)
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
          maxSimultaneousDrags: _movable ? null : 0,
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
          if (_movable) {
            context.read<BoardBloc>().add(BoardFocusEvent(focusCoor: name));
          }
        } else if (context.read<BoardBloc>().state is BoardFocusedState) {
          if (_movableToThis || _attackableToThis|| _moveFrom) {
            context.read<BoardBloc>().add(BoardMoveEvent(to: name));
          } else {
            context.read<BoardBloc>().add(BoardMoveEvent());
          }
        }
      },
      child: _container(darkBg, lightBg, Stack(
        children: [
          _lastMoveImage(),
          _moveDots(),
          _pieceImage(),
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
    if (_movableToThis) {
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
    } else if (_attackableToThis && (_lastMoveToThis || _lastMoveFromThis)) {
      return Container(
        alignment: Alignment.center,
        child: Stack(
          children: [
            Container(
              height: size*0.9,
              width: size*0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9999),
                color: isDark ? darkBgColor : lightBgColor,
              ),
            ),
            Container(
              height: size*0.9,
              width: size*0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9999),
                color: lastMoveEffect,
              ),
            ),
          ],
        ),
      );
    } else if (_attackableToThis || _moveFrom) {
      return Container(
        alignment: Alignment.center,
        child: Container(
          height: size*0.9,
          width: size*0.9,
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
    if (_attackableToThis) {
      return Container();
    } else if (_lastMoveFromThis) return Container(
      color: lastMoveEffect,
    );
    else if (_lastMoveToThis) return Container(
      color: lastMoveEffect,
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
}
