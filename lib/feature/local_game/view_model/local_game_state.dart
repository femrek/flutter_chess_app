// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:localchess/product/data/chess_turn/app_chess_turn_status.dart';
import 'package:localchess/product/data/coordinate/square_coordinate.dart';
import 'package:localchess/product/data/move/app_chess_move.dart';
import 'package:localchess/product/data/piece/app_piece.dart';

abstract class LocalGameState {}

class LocalGameInitialState extends LocalGameState {}

class LocalGameLoadedState extends LocalGameState {
  LocalGameLoadedState({
    required this.squareStates,
    required this.isFocused,
    required this.turnStatus,
  });

  final Map<SquareCoordinate, SquareData> squareStates;
  final bool isFocused;
  final AppChessTurnStatus turnStatus;
}

@immutable
class SquareData extends Equatable {
  const SquareData({
    required this.canMove,
    required this.isThisCheck,
    required this.isLastMoveFromThis,
    required this.isLastMoveToThis,
    required this.isFocusedOnThis,
    this.moveToThis,
    this.captureToThis,
    this.piece,
  });

  factory SquareData.empty() {
    return const SquareData(
      canMove: false,
      isThisCheck: false,
      isLastMoveFromThis: false,
      isLastMoveToThis: false,
      isFocusedOnThis: false,
    );
  }

  final AppPiece? piece;
  final bool canMove;
  final bool isThisCheck;
  final bool isLastMoveFromThis;
  final bool isLastMoveToThis;
  final bool isFocusedOnThis;
  final AppChessMove? moveToThis;
  final AppChessMove? captureToThis;

  bool get isMovableToThis => moveToThis != null;
  bool get canCaptured => captureToThis != null;

  @override
  List<Object?> get props => [
        piece,
        canMove,
        isThisCheck,
        isLastMoveFromThis,
        isLastMoveToThis,
        isFocusedOnThis,
        moveToThis,
        captureToThis,
      ];
}
