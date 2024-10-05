import 'package:flutter/material.dart';
import 'package:localchess/product/theme/app_color_scheme.dart';

/// The ui component for highlighting a square when want to mark a square as
/// the target of the drag. Used as overlay.
class SquareHighlighterCross extends StatelessWidget {
  /// Create a new instance of [SquareHighlighterCross].
  const SquareHighlighterCross({
    required this.size,
    super.key,
  });

  /// Width and height of the cross. e.g. 2 * square size
  final double size;

  double get _length => size / 4;
  double get _thickness => size / 12;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // top and bottom pieces
          Align(
            alignment: Alignment.topCenter,
            child: _CrossPiece(
              isHorizontal: false,
              length: _length,
              thickness: _thickness,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _CrossPiece(
              isHorizontal: false,
              length: _length,
              thickness: _thickness,
            ),
          ),

          // right and left pieces
          Align(
            alignment: Alignment.centerRight,
            child: _CrossPiece(
              isHorizontal: true,
              length: _length,
              thickness: _thickness,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: _CrossPiece(
              isHorizontal: true,
              length: _length,
              thickness: _thickness,
            ),
          ),
        ],
      ),
    );
  }
}

class _CrossPiece extends StatelessWidget {
  const _CrossPiece({
    required this.isHorizontal,
    required this.length,
    required this.thickness,
  });

  final bool isHorizontal;
  final double length;
  final double thickness;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isHorizontal ? length : thickness,
      height: isHorizontal ? thickness : length,
      decoration: BoxDecoration(
        color: AppColorScheme.highlighterCrossColor,
        borderRadius: BorderRadius.circular(thickness / 4),
      ),
    );
  }
}
