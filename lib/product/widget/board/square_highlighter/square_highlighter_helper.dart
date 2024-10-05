import 'package:flutter/material.dart';
import 'package:localchess/product/widget/board/square_highlighter/square_highlighter.dart';

/// Provides the builder function, size and offset (to center the square and
/// the highlighter cross) of the highlighter cross overlay.
class SquareHighlighterHelper {
  /// Create an instance of [SquareHighlighterHelper] with size of the squares.
  SquareHighlighterHelper({
    required this.unitSize,
  }) {
    _size = _squareHighlighterSize(unitSize);
    _offsetValue = _squareHighlighterOffset(unitSize);
  }

  /// The ui size of a square in the game board
  final double unitSize;

  /// The ui size of the [SquareHighlighterCross] built by [overlayBuilder].
  double get size => _size;

  /// The calculated offset to center cross and the square.
  Offset get offset => Offset(
        offsetValue,
        offsetValue,
      );

  /// The same with [offset] but this is the dx and dy values of that offset.
  double get offsetValue => _offsetValue;

  /// Prepared builder function to create an overlay.
  Widget overlayBuilder(BuildContext context) {
    return SquareHighlighterCross(
      size: size,
    );
  }

  late final double _size;
  late final double _offsetValue;

  double _squareHighlighterSize(double unitSize) => unitSize * 3;
  double _squareHighlighterOffset(double unitSize) => -unitSize;
}
