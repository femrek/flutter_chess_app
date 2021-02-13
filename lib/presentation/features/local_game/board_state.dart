import 'package:equatable/equatable.dart';
import 'package:chess/chess.dart' as ch;

abstract class BoardState extends Equatable {
  @override
  List<Object> get props => [];
}

class BoardInitialState extends BoardState {}

class BoardLoadedState extends BoardState {
  final List<List<ch.Piece>> board;
  final Set<String> movablePiecesCoors;
  final bool isWhiteTurn;
  final bool inCheck;
  final String history;

  BoardLoadedState({
    this.board,
    this.movablePiecesCoors,
    this.isWhiteTurn,
    this.inCheck,
    this.history,
  }):super();

  @override
  List<Object> get props => []
    ..addAll(board[0])
    ..addAll(board[1])
    ..addAll(board[2])
    ..addAll(board[3])
    ..addAll(board[4])
    ..addAll(board[5])
    ..addAll(board[6])
    ..addAll(board[7])
    ..addAll(movablePiecesCoors.toList())
    ..add(inCheck)
    ..add(isWhiteTurn)
    ..add(history)
  ;

    // ..addAll(List.generate(8, (i) => board[0][i]?.type?.name))
    // ..addAll(List.generate(8, (i) => board[1][i]?.type?.name))
    // ..addAll(List.generate(8, (i) => board[2][i]?.type?.name))
    // ..addAll(List.generate(8, (i) => board[3][i]?.type?.name))
    // ..addAll(List.generate(8, (i) => board[4][i]?.type?.name))
    // ..addAll(List.generate(8, (i) => board[5][i]?.type?.name))
    // ..addAll(List.generate(8, (i) => board[6][i]?.type?.name))
    // ..addAll(List.generate(8, (i) => board[7][i]?.type?.name))
}

class BoardFocusedState extends BoardState {
  final List<List<ch.Piece>> board;
  final String focusedCoor;
  final Set<String> movableCoors;
  final bool isWhiteTurn;
  final bool inCheck;
  final String history;

  BoardFocusedState({
    this.board,
    this.focusedCoor,
    this.movableCoors,
    this.isWhiteTurn,
    this.inCheck,
    this.history,
  });

  @override
  List<Object> get props => []
    ..addAll(board[0])
    ..addAll(board[1])
    ..addAll(board[2])
    ..addAll(board[3])
    ..addAll(board[4])
    ..addAll(board[5])
    ..addAll(board[6])
    ..addAll(board[7])
    ..addAll(movableCoors)
    ..add(focusedCoor)
    ..add(isWhiteTurn)
    ..add(inCheck)
    ..add(history)
  ;

}
