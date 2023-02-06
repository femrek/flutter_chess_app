import 'package:equatable/equatable.dart';
import 'package:chess/chess.dart' as ch;

class HostState extends Equatable {
  @override
  List<Object> get props => [];
}

class HostInitialState extends HostState {}

class HostLoadedState extends HostState {
  final List<List<ch.Piece?>> board;
  final Set<String> movablePiecesCoors;
  final bool isWhiteTurn;
  final bool inCheck;
  final String? lastMoveFrom;
  final String? lastMoveTo;
  final String fen;

  HostLoadedState({
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

class HostFocusedState extends HostState {
  final List<List<ch.Piece?>> board;
  final String focusedCoordinate;
  final Set<String> movableCoors;
  final bool isWhiteTurn;
  final bool inCheck;
  final String? lastMoveFrom;
  final String? lastMoveTo;
  final String fen;

  HostFocusedState({
    this.board = const [],
    required this.focusedCoordinate,
    this.movableCoors = const {},
    required this.isWhiteTurn,
    required this.inCheck,
    this.lastMoveFrom,
    this.lastMoveTo,
    required this.fen,
  });

  @override
  List<Object> get props => [fen];
}