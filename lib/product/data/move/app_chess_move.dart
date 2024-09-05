import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:localchess/product/data/coordinate/square_coordinate.dart';

/// The chess move data.
@immutable
class AppChessMove extends Equatable {
  /// Creates a [AppChessMove] with the given [from] and [to].
  const AppChessMove({
    required this.from,
    required this.to,
    required this.hasPromotion,
  });

  /// The starting square coordinate of the move.
  final SquareCoordinate from;

  /// The final square coordinate of the move.
  final SquareCoordinate to;

  /// The promotion piece if the move is a promotion move.
  final bool hasPromotion;

  @override
  String toString() {
    return 'AppChessMove(from: $from, to: $to, hasPromotion: $hasPromotion)';
  }

  @override
  List<Object?> get props => [from, to, hasPromotion];
}
