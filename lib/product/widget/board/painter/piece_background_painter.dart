import 'package:flutter/material.dart';
import 'package:localchess/product/theme/app_color_scheme.dart';

/// The painter for the background of an highlighted piece.
class PieceBackgroundPainter extends CustomPainter {
  const PieceBackgroundPainter._({
    required this.paintColor,
  });

  /// The color to paint the background.
  final Color paintColor;

  /// The instance for the background of the pieces that is focused.
  static const PieceBackgroundPainter focused = PieceBackgroundPainter._(
    paintColor: AppColorScheme.moveFromBackgroundColor,
  );

  /// The instance for the background of the pieces that can be captured.
  static const PieceBackgroundPainter attackableToThis =
      PieceBackgroundPainter._(
    paintColor: AppColorScheme.attackableToThisBackgroundColor,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final frameWidth = (w + h) / 24;
    const midPointDivider = 7;

    final fillingPaint = Paint()
      ..color = paintColor
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

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
