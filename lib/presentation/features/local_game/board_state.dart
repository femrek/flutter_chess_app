import 'package:chess/chess.dart' as ch;

abstract class BoardState {
  final String? fen;

  BoardState({
    this.fen,
  });
}

class BoardInitialState extends BoardState {}

class BoardLoadedState extends BoardState {
  final List<List<ch.Piece?>> board;
  final Set<String> movablePiecesCoors;
  final bool isWhiteTurn;
  final bool inCheck;
  final String? lastMoveFrom;
  final String? lastMoveTo;

  BoardLoadedState({
    this.board = const [],
    this.movablePiecesCoors = const {},
    required this.isWhiteTurn,
    required this.inCheck,
    this.lastMoveTo,
    this.lastMoveFrom,
    String? fen,
  }) : super(fen: fen);
}

class BoardFocusedState extends BoardState {
  final List<List<ch.Piece?>> board;
  final String focusedCoordinate;
  final Set<String> movableCoors;
  final bool isWhiteTurn;
  final bool inCheck;
  final String? lastMoveFrom;
  final String? lastMoveTo;

  BoardFocusedState({
    this.board = const [],
    required this.focusedCoordinate,
    this.movableCoors = const {},
    required this.isWhiteTurn,
    required this.inCheck,
    this.lastMoveTo,
    this.lastMoveFrom,
    String? fen,
  }) : super(fen: fen);
}
