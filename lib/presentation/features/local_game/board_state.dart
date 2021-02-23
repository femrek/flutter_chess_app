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
  final String fen;

  BoardLoadedState({
    this.board,
    this.movablePiecesCoors,
    this.isWhiteTurn,
    this.inCheck,
    this.fen
  }):super();

  @override
  List<Object> get props => [fen];
}

class BoardFocusedState extends BoardState {
  final List<List<ch.Piece>> board;
  final String focusedCoor;
  final Set<String> movableCoors;
  final bool isWhiteTurn;
  final bool inCheck;
  final String fen;

  BoardFocusedState({
    this.board,
    this.focusedCoor,
    this.movableCoors,
    this.isWhiteTurn,
    this.inCheck,
    this.fen
  });

  @override
  List<Object> get props => [fen];

}
