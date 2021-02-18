import 'package:equatable/equatable.dart';
import 'package:chess/chess.dart' as ch;

class LocalHostState extends Equatable {
  @override
  List<Object> get props => [];
}

class LocalHostInitialState extends LocalHostState {}

class LocalHostLoadedState extends LocalHostState {
  final List<List<ch.Piece>> board;
  final Set<String> movablePiecesCoors;
  final bool isWhiteTurn;
  final bool inCheck;
  final String history;

  LocalHostLoadedState({
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

class LocalHostFocusedState extends LocalHostState {
  final List<List<ch.Piece>> board;
  final String focusedCoor;
  final Set<String> movableCoors;
  final bool isWhiteTurn;
  final bool inCheck;
  final String history;

  LocalHostFocusedState({
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