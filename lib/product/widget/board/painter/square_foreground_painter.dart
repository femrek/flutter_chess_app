import 'package:flutter/material.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/theme/app_color_scheme.dart';
import 'package:localchess/product/widget/board/painter/square_foreground_paint_type.dart';

/// The painter for the background of an highlighted piece or a marked square.
class SquareForegroundPainter extends CustomPainter {
  /// Create a new instance of [SquareForegroundPainter].
  const SquareForegroundPainter({
    required this.paintTypes,
  });

  /// The type of paint to be used for the foreground of a square.
  final List<SquareForegroundPaintType> paintTypes;

  void _paintHighlight(Color color, Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final frameWidth = (w + h) / 24;
    const midPointDivider = 7;

    final fillingPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final topLeftPath = Path()
      ..moveTo(0, 0)
      ..lineTo(w / 2, 0)
      ..lineTo(w / 2, frameWidth)
      ..lineTo(w / midPointDivider, h / midPointDivider)
      ..lineTo(frameWidth, h / 2)
      ..lineTo(0, h / 2)
      ..close();

    final topRightPath = Path()
      ..moveTo(w, 0)
      ..lineTo(w / 2, 0)
      ..lineTo(w / 2, frameWidth)
      ..lineTo(w - w / midPointDivider, h / midPointDivider)
      ..lineTo(w - frameWidth, h / 2)
      ..lineTo(w, h / 2)
      ..close();

    final bottomRightPath = Path()
      ..moveTo(w, h)
      ..lineTo(w / 2, h)
      ..lineTo(w / 2, h - frameWidth)
      ..lineTo(w - w / midPointDivider, h - h / midPointDivider)
      ..lineTo(w - frameWidth, h / 2)
      ..lineTo(w, h / 2)
      ..close();

    final bottomLeftPath = Path()
      ..moveTo(0, h)
      ..lineTo(w / 2, h)
      ..lineTo(w / 2, h - frameWidth)
      ..lineTo(w / midPointDivider, h - h / midPointDivider)
      ..lineTo(frameWidth, h / 2)
      ..lineTo(0, h / 2)
      ..close();

    canvas
      ..drawPath(topLeftPath, fillingPaint)
      ..drawPath(topRightPath, fillingPaint)
      ..drawPath(bottomRightPath, fillingPaint)
      ..drawPath(bottomLeftPath, fillingPaint);
  }

  void _paintDot(Color color, Canvas canvas, Size size) {
    final s = (size.width + size.height) / 2;
    final circleRadius = s * 0.22;
    final mid = Offset(size.width / 2, size.height / 2);

    final fillingPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(mid, circleRadius, fillingPaint);
  }

  void _fillSquare(Color color, Canvas canvas, Size size) {
    final fillingPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      fillingPaint,
    );
  }

  void _performPaint(
    SquareForegroundPaintType paintType,
    Canvas canvas,
    Size size,
  ) {
    switch (paintType) {
      case SquareForegroundPaintType.focusedPiece:
        _paintHighlight(
          AppColorScheme.moveFromBackgroundColor,
          canvas,
          size,
        );
        return;
      case SquareForegroundPaintType.capturePiece:
        _paintHighlight(
          AppColorScheme.attackableToThisBackgroundColor,
          canvas,
          size,
        );
        return;
      case SquareForegroundPaintType.movableToThis:
        _paintDot(
          AppColorScheme.moveDotsColor,
          canvas,
          size,
        );
        return;
      case SquareForegroundPaintType.checkPiece:
        _fillSquare(
          AppColorScheme.inCheckBackgroundColor,
          canvas,
          size,
        );
    }
  }

  SquareForegroundPainter copy() {
    return SquareForegroundPainter(paintTypes: paintTypes);
  }

  @override
  void paint(Canvas canvas, Size size) {
    G.logger.t('PieceBackgroundPainter.paint: start: $paintTypes');

    for (final paintType in paintTypes) {
      _performPaint(paintType, canvas, size);
    }

    G.logger.t('PieceBackgroundPainter.paint: end: $paintTypes');
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is SquareForegroundPainter) {
      return paintTypes != oldDelegate.paintTypes;
    }
    return true;
  }
}
