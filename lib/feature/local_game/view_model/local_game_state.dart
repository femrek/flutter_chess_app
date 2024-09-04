// ignore_for_file: public_member_api_docs

import 'package:localchess/product/data/chess_turn/app_chess_turn_status.dart';
import 'package:localchess/product/data/coordinate/square_coordinate.dart';
import 'package:localchess/product/data/piece/app_piece.dart';
import 'package:localchess/product/data/square_data.dart';

abstract class LocalGameState {}

class LocalGameInitialState extends LocalGameState {}

class LocalGameLoadedState extends LocalGameState {
  LocalGameLoadedState({
    required this.squareStates,
    required this.isFocused,
    required this.turnStatus,
    required this.capturedPieces,
  });

  final Map<SquareCoordinate, SquareData> squareStates;
  final bool isFocused;
  final AppChessTurnStatus turnStatus;
  final List<AppPiece> capturedPieces;
}
