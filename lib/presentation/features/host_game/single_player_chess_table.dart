import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mychess/data/app_theme.dart';
import 'package:chess/chess.dart' as ch;


import 'host_bloc.dart';
import 'host_state.dart';
import 'host_event.dart';

class SinglePlayerChessTable extends StatelessWidget {
  final double size;

  SinglePlayerChessTable({this.size = 200, Key key}) : super(key: key);

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
    return Column(
      children: List.generate(8, (index) => _tableRow(context, index)).reversed.toList()
      ..insert(0, _letterRow(context, true))
      ..add(_letterRow(context, false)),
    );
  }

  Row _tableRow(BuildContext context, int y) {
    return Row(
      children: List.generate(8, (index) => _square(context, y, index))
        ..insert(0, _text(context, (y+1).toString(), false, true))
        ..add(_text(context, (y+1).toString(), false, false)),
    );
  }

  Widget _square(BuildContext context, int y, int x) {
    final double squareSize = size / 9;
    return BlocBuilder<HostBloc, HostState>(
      builder: (_, state) {
        if (state is HostLoadedState) {
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

        else if (state is HostFocusedState) {
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

        return SquareOnTheBoard(
          size: squareSize,
          positionX: x,
          positionY: y,
          piece: null,
          inCheck: false,
        );
      },
    );
  }

  Row _letterRow(BuildContext context, bool isTop) {
    return Row(
      children: List.generate(8, (index) =>
       _text(context, String.fromCharCode(65+index), true, !isTop))
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
    if (context.read<HostBloc>().state is HostLoadedState) {
      movable = (context.read<HostBloc>().state as HostLoadedState).isWhiteTurn 
        && (context.read<HostBloc>().state as HostLoadedState).movablePiecesCoors.contains(name);
      lastMoveFromThis = (context.read<HostBloc>().state as HostLoadedState).lastMoveFrom == name;
      lastMoveToThis = (context.read<HostBloc>().state as HostLoadedState).lastMoveTo == name;
    } else if (context.read<HostBloc>().state is HostFocusedState) {
      movableToThis = (context.read<HostBloc>().state as HostFocusedState).movableCoors.contains(name);
      if (piece != null && movableToThis) {
        attackableToThis = true;
        movableToThis = false;
      }
      if ((context.read<HostBloc>().state as HostFocusedState).focusedCoor == name) {
        moveFrom = true;
      }
      lastMoveFromThis = (context.read<HostBloc>().state as HostFocusedState).lastMoveFrom == name;
      lastMoveToThis = (context.read<HostBloc>().state as HostFocusedState).lastMoveTo == name;
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
        context.read<HostBloc>().add(HostMoveEvent(to: name));
      },
      onWillAccept: (focusCoor) {
        return movableToThis || attackableToThis;
      },
      builder: (_, list1, list2) {
        return Draggable<String>(
          data: name,
          onDragStarted: () {
            context.read<HostBloc>().add(HostFocusEvent(focusCoor: name));
          },
          onDragEnd: (details) {
            if (!details.wasAccepted) 
              context.read<HostBloc>().add(HostMoveEvent());
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
        if (context.read<HostBloc>().state is HostLoadedState) {
          if (movable) {
            context.read<HostBloc>().add(HostFocusEvent(focusCoor: name));
          }
        } else if (context.read<HostBloc>().state is HostFocusedState) {
          if (movableToThis || attackableToThis|| moveFrom) {
            context.read<HostBloc>().add(HostMoveEvent(to: name));
          } else {
            context.read<HostBloc>().add(HostMoveEvent());
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