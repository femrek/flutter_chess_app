// ignore_for_file: public_member_api_docs

import 'package:localchess/product/data/app_piece.dart';
import 'package:localchess/product/data/chess_turn/app_chess_turn_status.dart';
import 'package:localchess/product/data/move/app_chess_move.dart';
import 'package:localchess/product/data/square_coordinate.dart';

abstract class LocalGameState {}

class LocalGameInitialState extends LocalGameState {}

class LocalGameLoadedState extends LocalGameState {
  LocalGameLoadedState({
    required this.getPieceAt,
    required this.movablePiecesCoordinates,
    required this.checkStatus,
    this.moves,
    this.focusedCoordinate,
  });

  final AppPiece? Function(SquareCoordinate) getPieceAt;

  final List<SquareCoordinate> movablePiecesCoordinates;

  final Map<SquareCoordinate, AppChessMove>? moves;

  final SquareCoordinate? focusedCoordinate;

  final AppChessTurnStatus checkStatus;

  bool get isFocused => focusedCoordinate != null;
}
