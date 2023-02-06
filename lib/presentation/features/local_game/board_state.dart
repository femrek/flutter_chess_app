import 'package:equatable/equatable.dart';
import 'package:chess/chess.dart' as ch;

abstract class BoardState extends Equatable {
  final String fen;

  BoardState({
    this.fen,
  });

  @override
  List<Object> get props => [fen];
}

class BoardInitialState extends BoardState {}

class BoardLoadedState extends BoardState {
  final List<List<ch.Piece>> board;
  final Set<String> movablePiecesCoors;
  final bool isWhiteTurn;
  final bool inCheck;
  final String lastMoveFrom;
  final String lastMoveTo;

  BoardLoadedState({
    this.board,
    this.movablePiecesCoors,
    this.isWhiteTurn,
    this.inCheck,
    this.lastMoveTo,
    this.lastMoveFrom,
    String fen,
  }) : super(fen: fen);
}

class BoardFocusedState extends BoardState {
  final List<List<ch.Piece>> board;
  final String focusedCoordinate;
  final Set<String> movableCoors;
  final bool isWhiteTurn;
  final bool inCheck;
  final String lastMoveFrom;
  final String lastMoveTo;

  BoardFocusedState({
    this.board,
    this.focusedCoordinate,
    this.movableCoors,
    this.isWhiteTurn,
    this.inCheck,
    this.lastMoveTo,
    this.lastMoveFrom,
    String fen,
  }) : super(fen: fen);
}
