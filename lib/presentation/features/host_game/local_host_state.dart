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
  final String lastMoveFrom;
  final String lastMoveTo;
  final String fen;

  LocalHostLoadedState({
    this.board,
    this.movablePiecesCoors,
    this.isWhiteTurn,
    this.inCheck,
    this.lastMoveFrom,
    this.lastMoveTo,
    this.fen,
  }):super();

  @override
  List<Object> get props => [fen];
}

class LocalHostFocusedState extends LocalHostState {
  final List<List<ch.Piece>> board;
  final String focusedCoor;
  final Set<String> movableCoors;
  final bool isWhiteTurn;
  final bool inCheck;
  final String lastMoveFrom;
  final String lastMoveTo;
  final String fen;

  LocalHostFocusedState({
    this.board,
    this.focusedCoor,
    this.movableCoors,
    this.isWhiteTurn,
    this.inCheck,
    this.lastMoveFrom,
    this.lastMoveTo,
    this.fen,
  });

  @override
  List<Object> get props => [fen];
}