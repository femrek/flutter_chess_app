import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:localchess/product/data/piece/app_piece.dart';
import 'package:localchess/product/data/piece/app_piece_widget_extension.dart';
import 'package:localchess/product/widget/captured_piece_indicator/horizontal_direction.dart';

/// A widget that shows the captured pieces
class CapturedPieceIndicator extends StatelessWidget {
  /// Creates a [CapturedPieceIndicator] widget
  const CapturedPieceIndicator({
    required this.pieces,
    this.pieceSize = 20,
    this.backgroundColor = Colors.transparent,
    this.direction = HorizontalDirection.leftToRight,
    super.key,
  });

  /// The list of pieces to show
  final List<AppPiece> pieces;

  /// The background color of the widget
  final Color backgroundColor;

  /// The size of the pieces
  final double pieceSize;

  /// Pieces are shown from left to right or right to left.
  final HorizontalDirection direction;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      height: pieceSize,
      child: LayoutBuilder(
        builder: (context, layoutConstraints) {
          final containerWidth =
              math.min(pieceSize, layoutConstraints.maxWidth / pieces.length);

          return Align(
            alignment: direction == HorizontalDirection.leftToRight
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: _pieceWidgets(context, containerWidth),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _pieceWidgets(BuildContext context, double containerWidth) {
    if (direction == HorizontalDirection.leftToRight) {
      return pieces.reversed
          .map<Widget>((e) => _pieceBuilder(e, containerWidth))
          .toList();
    }
    return pieces.map<Widget>((e) => _pieceBuilder(e, containerWidth)).toList();
  }

  Widget _pieceBuilder(AppPiece piece, double containerWidth) {
    return SizedBox(
      width: containerWidth,
      height: pieceSize,
      child: OverflowBox(
        maxWidth: pieceSize,
        maxHeight: pieceSize,
        child: piece.asImage(),
      ),
    );
  }
}
