import 'package:equatable/equatable.dart';
import 'package:chess/chess.dart' as ch;

class GuestState extends Equatable {
  @override
  List<Object> get props => []; 
}

class GuestInitialState extends GuestState {}

class GuestLoadedState extends GuestState {
  final List<List<ch.Piece>> board;
  final Set<String> movablePiecesCoors;
  final bool isWhiteTurn;
  final bool inCheck;
  final String history;

  GuestLoadedState({
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
}

class GuestFocusedState extends GuestState {
  final List<List<ch.Piece>> board;
  final String focusedCoor;
  final Set<String> movableCoors;
  final bool isWhiteTurn;
  final bool inCheck;
  final String history;

  GuestFocusedState({
    this.board,
    this.focusedCoor,
    this.movableCoors,
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
    ..addAll(movableCoors.toList())
    ..add(inCheck)
    ..add(isWhiteTurn)
    ..add(history)
  ;
}
