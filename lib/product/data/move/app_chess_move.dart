import 'package:flutter/foundation.dart';
import 'package:localchess/product/data/square_coordinate.dart';

/// The chess move data.
@immutable
class AppChessMove {
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
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppChessMove &&
        other.from == from &&
        other.to == to &&
        other.hasPromotion == hasPromotion;
  }

  @override
  int get hashCode {
    return from.hashCode ^ to.hashCode ^ hasPromotion.hashCode;
  }
}
