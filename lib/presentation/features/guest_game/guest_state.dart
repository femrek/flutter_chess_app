import 'package:chess/chess.dart' as ch;

class GuestState {}

class GuestInitialState extends GuestState {}

class GuestLoadedState extends GuestState {
  final List<List<ch.Piece?>> board;
  final Set<String> movablePiecesCoors;
  final bool isWhiteTurn;
  final bool inCheck;
  final String? lastMoveFrom;
  final String? lastMoveTo;
  final String fen;
  final String? ghostCoordinate;
  final String? focusedCoordinate;
  final Set<String> movableCoors;

  GuestLoadedState({
    this.board = const [],
    this.movablePiecesCoors = const {},
    required this.isWhiteTurn,
    required this.inCheck,
    this.lastMoveFrom,
    this.lastMoveTo,
    required this.fen,
    this.ghostCoordinate,
    this.focusedCoordinate,
    this.movableCoors = const {},
  }) : super();
}

class GuestErrorState extends GuestState {
  final String errorMessage;

  GuestErrorState({
    required this.errorMessage,
  });
}
