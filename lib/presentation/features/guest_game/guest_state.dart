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
  final String lastMoveFrom;
  final String lastMoveTo;
  final String fen;

  GuestLoadedState({
    this.board,
    this.movablePiecesCoors,
    this.isWhiteTurn,
    this.inCheck,
    this.lastMoveFrom,
    this.lastMoveTo,
    this.fen,
  }) : super();

  @override
  List<Object> get props => [fen];
}

class GuestFocusedState extends GuestState {
  final List<List<ch.Piece>> board;
  final String focusedCoordinate;
  final Set<String> movableCoors;
  final bool isWhiteTurn;
  final bool inCheck;
  final String lastMoveFrom;
  final String lastMoveTo;
  final String fen;

  GuestFocusedState({
    this.board,
    this.focusedCoordinate,
    this.movableCoors,
    this.isWhiteTurn,
    this.inCheck,
    this.lastMoveFrom,
    this.lastMoveTo,
    this.fen,
  }) : super();

  @override
  List<Object> get props => [fen];
}
