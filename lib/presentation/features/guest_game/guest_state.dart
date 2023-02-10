import 'package:equatable/equatable.dart';
import 'package:chess/chess.dart' as ch;

class GuestState extends Equatable {
  @override
  List<Object> get props => []; 
}

class GuestInitialState extends GuestState {}

class GuestLoadedState extends GuestState {
  final List<List<ch.Piece?>> board;
  final Set<String> movablePiecesCoors;
  final bool isWhiteTurn;
  final bool inCheck;
  final String? lastMoveFrom;
  final String? lastMoveTo;
  final String fen;

  GuestLoadedState({
    this.board = const [],
    this.movablePiecesCoors = const {},
    required this.isWhiteTurn,
    required this.inCheck,
    this.lastMoveFrom,
    this.lastMoveTo,
    required this.fen,
  }) : super();

  @override
  List<Object> get props => [fen];
}

class GuestFocusedState extends GuestState {
  final List<List<ch.Piece?>> board;
  final String focusedCoordinate;
  final Set<String> movableCoors;
  final bool isWhiteTurn;
  final bool inCheck;
  final String? lastMoveFrom;
  final String? lastMoveTo;
  final String fen;

  GuestFocusedState({
    this.board = const [],
    required this.focusedCoordinate,
    this.movableCoors = const {},
    required this.isWhiteTurn,
    required this.inCheck,
    this.lastMoveFrom,
    this.lastMoveTo,
    required this.fen,
  }) : super();

  @override
  List<Object> get props => [fen];
}

class GuestErrorState extends GuestState {
  final String errorMessage;

  GuestErrorState({
    required this.errorMessage,
  });

  @override
  List<Object> get props => [errorMessage];
}
