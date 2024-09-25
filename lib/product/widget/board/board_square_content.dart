import 'package:flutter/material.dart';
import 'package:localchess/product/data/coordinate/board_orientation_enum.dart';
import 'package:localchess/product/data/piece/app_piece_widget_extension.dart';
import 'package:localchess/product/data/square_data.dart';
import 'package:localchess/product/theme/app_color_scheme.dart';
import 'package:localchess/product/widget/board/painter/square_foreground_paint_type.dart';
import 'package:localchess/product/widget/board/painter/square_foreground_painter.dart';

/// The content of a square on the game board. According to the [data] it will
/// show the piece, highlight, or other visual elements. Dark and light squares
/// background color is not included in this widget.
class BoardSquareContent extends StatelessWidget {
  /// Create a new instance of [BoardSquareContent].
  const BoardSquareContent({
    required this.unitSize,
    required this.data,
    this.onDragStarted,
    this.orientation = BoardOrientationEnum.portrait,
    super.key,
  });

  /// The size of the square. (same width and height)
  final double unitSize;

  /// The data of the square.
  final SquareData data;

  /// The callback function when the drag started.
  final VoidCallback? onDragStarted;

  /// The orientation of the board.
  final BoardOrientationEnum orientation;

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

    // show the piece away from the center when dragging. When dragging the
    // piece could be hidden by the finger. So, show it a little bit away from
    // the center.
    final feedbackOffsetValue = unitSize * 0.8;
    final feedbackOffset = orientation.when(
      portrait: Offset(0, -feedbackOffsetValue),
      portraitUpsideDown: Offset(0, -feedbackOffsetValue),
      landscapeLeftBased: data.piece?.color.when(
        black: Offset(-feedbackOffsetValue, 0),
        white: Offset(feedbackOffsetValue, 0),
      ),
    );

    // show the finger pointer color when dragging the piece. The color will be
    // the same as the piece color.
    final fingerPointerColor = data.piece?.color.when(
          black: AppColorScheme.blackPieceColor,
          white: AppColorScheme.whitePieceColor,
        ) ??
        Colors.transparent;

    return Draggable(
      data: 0,
      onDragStarted: onDragStarted,
      maxSimultaneousDrags: data.canMove ? 1 : 0,
      dragAnchorStrategy: (_, context, offset) {
        // always hold the draggable from the center.
        return Offset(unitSize / 2, unitSize / 2);
      },
      childWhenDragging: CustomPaint(painter: painter),
      feedback: Stack(
        children: [
          Container(
            width: unitSize,
            height: unitSize,
            alignment: Alignment.center,
            child: Container(
              width: unitSize,
              height: unitSize,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    fingerPointerColor,
                    fingerPointerColor.withOpacity(0.5),
                    fingerPointerColor.withOpacity(0.2),
                  ],
                  tileMode: TileMode.decal,
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: feedbackOffset ?? Offset.zero,
            child: SizedBox(
              width: unitSize,
              height: unitSize,
              child: data.piece?.asImage(
                orientation: orientation,
                isAchromatic: data.isSyncInProcess,
              ),
            ),
          ),
        ],
      ),
      child: CustomPaint(
        painter: painter,
        child: SizedBox(
          width: unitSize,
          height: unitSize,
          child: data.piece?.asImage(
            orientation: orientation,
            isAchromatic: data.isSyncInProcess,
          ),
        ),
      ),
    );
  }
}
