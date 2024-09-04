import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:localchess/product/data/move/app_chess_move.dart';
import 'package:localchess/product/data/piece/app_piece.dart';

/// The data class to keep the status of a square. According to this data
/// the builder function may draw some widgets on the square.
@immutable
class SquareData extends Equatable {
  /// Creates a [SquareData] object.
  const SquareData({
    required this.canMove,
    required this.isThisCheck,
    required this.isLastMoveFromThis,
    required this.isLastMoveToThis,
    required this.isFocusedOnThis,
    required this.isSyncInProcess,
    this.moveToThis,
    this.captureToThis,
    this.piece,
  });

  /// Creates a [SquareData] object with default values.
  const SquareData.withDefaultValues({
    this.canMove = false,
    this.isThisCheck = false,
    this.isLastMoveFromThis = false,
    this.isLastMoveToThis = false,
    this.isFocusedOnThis = false,
    this.isSyncInProcess = false,
    this.moveToThis,
    this.captureToThis,
    this.piece,
  });

  /// The piece type on the square.
  final AppPiece? piece;

  /// Whether the piece has any move. Whether the piece able to been focused.
  final bool canMove;

  /// Whether the piece is a king and under attack.
  final bool isThisCheck;

  /// Whether the last move was from this square.
  final bool isLastMoveFromThis;

  /// Whether the last move was to this square.
  final bool isLastMoveToThis;

  /// Whether the square is in focused state.
  final bool isFocusedOnThis;

  /// Whether the square is in sync process. Use when the move update is being
  /// send to other device.
  final bool isSyncInProcess;

  /// When the focused piece can move to this square, this field keeps the data
  /// of the move.
  final AppChessMove? moveToThis;

  /// When the focused piece can capture to this square, this field keeps the
  /// data of the move.
  final AppChessMove? captureToThis;

  /// Whether the piece is movable to this square.
  bool get isMovableToThis => moveToThis != null;

  /// Whether the piece can be captured in this square.
  bool get canCaptured => captureToThis != null;

  @override
  List<Object?> get props => [
        piece,
        canMove,
        isThisCheck,
        isLastMoveFromThis,
        isLastMoveToThis,
        isFocusedOnThis,
        isSyncInProcess,
        moveToThis,
        captureToThis,
      ];
}
