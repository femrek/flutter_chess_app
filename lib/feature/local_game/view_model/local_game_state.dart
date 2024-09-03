// ignore_for_file: public_member_api_docs

import 'package:localchess/product/data/chess_turn/app_chess_turn_status.dart';
import 'package:localchess/product/data/coordinate/square_coordinate.dart';
import 'package:localchess/product/data/move/app_chess_move.dart';
import 'package:localchess/product/data/piece/app_piece.dart';

abstract class LocalGameState {}

class LocalGameInitialState extends LocalGameState {}

class LocalGameLoadedState extends LocalGameState {
  LocalGameLoadedState({
    required this.getPieceAt,
    required this.movablePiecesCoordinates,
    required this.checkStatus,
    this.moves,
    this.focusedCoordinate,
    this.lastMoveFrom,
    this.lastMoveTo,
  });

  final AppPiece? Function(SquareCoordinate) getPieceAt;

  final List<SquareCoordinate> movablePiecesCoordinates;

  final Map<SquareCoordinate, AppChessMove>? moves;

  final SquareCoordinate? focusedCoordinate;

  final AppChessTurnStatus checkStatus;

  final SquareCoordinate? lastMoveFrom;

  final SquareCoordinate? lastMoveTo;

  bool get isFocused => focusedCoordinate != null;

  /// return true the focus on the given [coordinate].
  bool isFocusedOn(SquareCoordinate coordinate) {
    return focusedCoordinate == coordinate;
  }

  /// return true if the [piece] is in check.
  bool isCheckOn(AppPiece? piece) {
    if (piece == null) return false;
    return checkStatus.isCheckOn(piece);
  }

  /// return true if the piece in the [focusedCoordinate] is movable to
  /// [coordinate].
  bool isMovableTo(SquareCoordinate coordinate) {
    if (focusedCoordinate == null) return false;
    return moves?[coordinate] != null;
  }

  /// return true if the piece in the [coordinate] has a move in current state.
  bool isMovableFrom(SquareCoordinate coordinate) {
    return movablePiecesCoordinates.contains(coordinate);
  }

  /// return true if the [coordinate] is the last move from.
  bool isLastMoveFrom(SquareCoordinate coordinate) {
    return lastMoveFrom == coordinate;
  }

  /// return true if the [coordinate] is the last move to.
  bool isLastMoveTo(SquareCoordinate coordinate) {
    return lastMoveTo == coordinate;
  }
}
