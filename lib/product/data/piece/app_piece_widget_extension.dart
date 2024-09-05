import 'package:flutter/material.dart';
import 'package:localchess/product/data/coordinate/board_orientation_enum.dart';
import 'package:localchess/product/data/piece/app_piece.dart';
import 'package:localchess/product/theme/app_color_scheme.dart';

/// Create a piece image widget easily
extension AppPieceWidgetExtension on AppPiece {
  /// Create a piece image widget from the piece
  Widget asImage({
    BoardOrientationEnum? orientation,
    bool isAchromatic = false,
  }) {
    final pieceColor = color.when(
        black: AppColorScheme.blackPieceColor,
        white: AppColorScheme.whitePieceColor);
    return RotatedBox(
      quarterTurns: orientation?.pieceRotateQuarters(color: color) ?? 0,
      child: Transform.scale(
        scale: scale,
        child: image.svg(
          package: 'gen',
          colorFilter: ColorFilter.mode(
            isAchromatic ? pieceColor.withOpacity(0.3) : pieceColor,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
