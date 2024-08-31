import 'package:flutter/material.dart';
import 'package:localchess/product/model/square_coordinate.dart';
import 'package:localchess/product/theme/app_color_scheme.dart';

/// The builder function to build piece on the square
typedef BoardSquareBuilder = Widget Function(
  BuildContext context,
  SquareCoordinate coordinate,
);

/// The widget that shows a square on the game board
class BoardSquare extends StatelessWidget {
  /// The widget that shows a square on the game board constructor
  const BoardSquare({
    required this.unitSize,
    required this.coordinate,
    required this.builder,
    super.key,
  });

  /// The size of the square
  final double unitSize;

  /// The coordinate of the square
  final SquareCoordinate coordinate;

  /// The builder function to build piece on the square
  final BoardSquareBuilder builder;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: unitSize * 0.8,
      height: unitSize * 0.8,
      color: coordinate.isDark
          ? AppColorScheme.darkTileColor
          : AppColorScheme.lightTileColor,
      alignment: Alignment.center,
      child: builder(context, coordinate),
    );
  }
}
