import 'package:equatable/equatable.dart';
import 'package:chess/chess.dart' as ch;
import 'package:mychess/board_event.dart';

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

  BoardLoadedState({
    this.board,
    this.movablePiecesCoors,
    this.isWhiteTurn,
    this.inCheck,
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
    ..addAll(movablePiecesCoors)
  ;
}

class BoardFocusedState extends BoardState {
  final List<List<ch.Piece>> board;
  final String focusedCoor;
  final Set<String> movableCoors;
  final bool isWhiteTurn;
  final bool inCheck;

  BoardFocusedState({
    this.board,
    this.focusedCoor,
    this.movableCoors,
    this.isWhiteTurn,
    this.inCheck,
  });

}
