import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localchess/data/app_theme.dart';
import 'package:chess/chess.dart' as ch;

import 'guest_bloc.dart';
import 'guest_state.dart';
import 'guest_event.dart';

class GuestBoard extends StatelessWidget {
  final double size;

  GuestBoard({this.size = 200, Key key}) : super(key: key);

  final List<_SquareOnTheBoard> squares = [];

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
    return Column(
      children: List.generate(8, (index) => _tableRow(context, 7-index)).reversed.toList()
      ..insert(0, _letterRow(context, true))
      ..add(_letterRow(context, false)),
    );
  }

  Row _tableRow(BuildContext context, int y) {
    return Row(
      children: List.generate(8, (index) => _square(context, y, 7-index))
        ..insert(0, _text(context, (y+1).toString(), false, true))
        ..add(_text(context, (y+1).toString(), false, false)),
    );
  }

  Widget _square(BuildContext context, int y, int x) {
    final double squareSize = size / 9;
    return BlocBuilder<GuestBloc, GuestState>(
      builder: (_, state) {
        if (state is GuestLoadedState) {
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

        else if (state is GuestFocusedState) {
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
          height: squareSize,
          width: squareSize,
        );
      },
    );
  }

  Row _letterRow(BuildContext context, bool isTop) {
    return Row(
      children: List.generate(8, (index) =>
       _text(context, String.fromCharCode(72-index), true, !isTop))
         ..insert(0, SizedBox(width: size/18,))
         ..add(SizedBox(width: size/18,)),
    );
  }

  Widget _text(BuildContext context, String content, bool horizontalSide, bool turnRight) {
    return Container(
      width: size / (horizontalSide ? 9 : 18),
      height: size / (!horizontalSide ? 9 : 18),
      alignment: Alignment.center,
      child: Text(
        content,
        style: TextStyle(
          color: Colors.white,
          fontSize: size/25/MediaQuery.of(context).textScaleFactor,
        ),
      ),
    );
  }

}

// ignore: must_be_immutable
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
    Key key}) : super(key: key);

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
    if (context.read<GuestBloc>().state is GuestLoadedState) {
      _movable = (context.read<GuestBloc>().state as GuestLoadedState).movablePiecesCoors.contains(name);
      _lastMoveFromThis = (context.read<GuestBloc>().state as GuestLoadedState).lastMoveFrom == name;
      _lastMoveToThis = (context.read<GuestBloc>().state as GuestLoadedState).lastMoveTo == name;
    } else if (context.read<GuestBloc>().state is GuestFocusedState) {
      _movableToThis = (context.read<GuestBloc>().state as GuestFocusedState).movableCoors.contains(name);
      if (piece != null && _movableToThis) {
        _attackableToThis = true;
        _movableToThis = false;
      }
      if ((context.read<GuestBloc>().state as GuestFocusedState).focusedCoordinate == name) {
        _moveFrom = true;
      }
      _lastMoveFromThis = (context.read<GuestBloc>().state as GuestFocusedState).lastMoveFrom == name;
      _lastMoveToThis = (context.read<GuestBloc>().state as GuestFocusedState).lastMoveTo == name;
    }

    Color darkBg = darkBgColor;
    Color lightBg = lightBgColor;
    if (_attackableToThis) {
      darkBg = attackableToThisBg;
      lightBg = attackableToThisBg;
    } else if (inCheck) {
      darkBg = inCheckBg;
      lightBg = inCheckBg;
    } else if (_moveFrom) {
      darkBg = moveFromBg;
      lightBg = moveFromBg;
    }

    return DragTarget<String>(
      onAccept: (focusCoordinate) {
        if (_movableToThis || _attackableToThis)
          context.read<GuestBloc>().add(GuestMoveEvent(to: name));
        else
          context.read<GuestBloc>().add(GuestMoveEvent());
      },
      builder: (_, list1, list2) {
        return Draggable<String>(
          data: name,
          onDragStarted: () {
            context.read<GuestBloc>().add(GuestFocusEvent(focusCoordinate: name));
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
        if (context.read<GuestBloc>().state is GuestLoadedState) {
          if (_movable) {
            context.read<GuestBloc>().add(GuestFocusEvent(focusCoordinate: name));
          }
        } else if (context.read<GuestBloc>().state is GuestFocusedState) {
          if (_movableToThis || _attackableToThis|| _moveFrom) {
            context.read<GuestBloc>().add(GuestMoveEvent(to: name));
          } else {
            context.read<GuestBloc>().add(GuestMoveEvent());
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
            color: moveDotsColor,
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
    final bool isBlack = piece.color == ch.Color.BLACK;
    return Container(
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
