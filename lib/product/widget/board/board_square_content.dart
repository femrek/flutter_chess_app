import 'package:flutter/material.dart';
import 'package:localchess/feature/local_game/view_model/local_game_state.dart';
import 'package:localchess/product/data/coordinate/board_orientation_enum.dart';
import 'package:localchess/product/data/piece/app_piece_widget_extension.dart';
import 'package:localchess/product/widget/board/painter/square_foreground_paint_type.dart';
import 'package:localchess/product/widget/board/painter/square_foreground_painter.dart';

/// The content of a square on the game board. According to the [data] it will
/// show the piece, highlight, or other visual elements. Dark and light squares
/// background color is not included in this widget.
class BoardSquareContent extends StatelessWidget {
  /// Create a new instance of [BoardSquareContent].
  const BoardSquareContent({
    required this.data,
    required this.onDragStarted,
    super.key,
  });

  /// The data of the square.
  final SquareData data;

  /// The callback function when the drag started.
  final VoidCallback onDragStarted;

  @override
  Widget build(BuildContext context) {
    final painter = SquareForegroundPainter(paintTypes: [
      if (data.isThisCheck) SquareForegroundPaintType.checkPiece,
      if (data.isLastMoveFromThis) SquareForegroundPaintType.movedFrom,
      if (data.isLastMoveToThis) SquareForegroundPaintType.movedTo,
      if (data.isFocusedOnThis) SquareForegroundPaintType.focusedPiece,
      if (data.isMovableToThis) SquareForegroundPaintType.movableToThis,
      if (data.canCaptured) SquareForegroundPaintType.capturePiece,
    ]);

    return Draggable(
      data: 0,
      onDragStarted: onDragStarted,
      childWhenDragging: CustomPaint(
        painter: painter,
      ),
      maxSimultaneousDrags: data.canMove ? 1 : 0,
      feedback: data.piece?.asImage(
            orientation: BoardOrientationEnum.landscapeLeftBased,
          ) ??
          const SizedBox.shrink(),
      child: CustomPaint(
        painter: painter,
        child: data.piece?.asImage(
              orientation: BoardOrientationEnum.landscapeLeftBased,
            ) ??
            const SizedBox.shrink(),
      ),
    );
  }
}
