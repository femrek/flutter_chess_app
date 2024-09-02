import 'package:flutter/material.dart';
import 'package:localchess/product/data/coordinate/board_orientation_enum.dart';
import 'package:localchess/product/data/piece/app_piece.dart';
import 'package:localchess/product/theme/app_color_scheme.dart';

/// Create a piece image widget easily
extension AppPieceWidgetExtension on AppPiece {
  /// Create a piece image widget from the piece
  Widget asImage({BoardOrientationEnum? orientation}) {
    return Transform.rotate(
      angle: orientation == BoardOrientationEnum.landscapeLeftBased
          ? 3.1415926535 / 2 * (isDark ? -1 : 1)
          : 0,
      child: Transform.scale(
        scale: scale,
        child: image.svg(
          package: 'gen',
          colorFilter: ColorFilter.mode(
            isDark
                ? AppColorScheme.blackPieceColor
                : AppColorScheme.whitePieceColor,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
