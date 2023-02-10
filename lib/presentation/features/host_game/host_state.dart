import 'package:chess/chess.dart' as ch;

class HostState {}

class HostInitialState extends HostState {}

class HostLoadedState extends HostState {
  final List<List<ch.Piece?>> board;
  final Set<String> movablePiecesCoors;
  final bool isWhiteTurn;
  final bool inCheck;
  final String? lastMoveFrom;
  final String? lastMoveTo;
  final String fen;
  final String? clientInformation;
  final String? focusedCoordinate;
  final Set<String> movableCoors;

  HostLoadedState({
    this.board = const [],
    this.movablePiecesCoors = const {},
    required this.isWhiteTurn,
    required this.inCheck,
    this.lastMoveFrom,
    this.lastMoveTo,
    required this.fen,
    this.clientInformation,
    this.focusedCoordinate,
    this.movableCoors = const {},
  }) : super();
}
