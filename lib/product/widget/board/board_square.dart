import 'package:flutter/material.dart';
import 'package:localchess/product/data/coordinate/square_coordinate.dart';
import 'package:localchess/product/theme/app_color_scheme.dart';

/// The builder function to build piece on the square
typedef BoardSquareBuilder = Widget Function(
  BuildContext context,
  SquareCoordinate coordinate,
  double unitSize,
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
      color: coordinate.isDark
          ? AppColorScheme.darkTileColor
          : AppColorScheme.lightTileColor,
      alignment: Alignment.center,
      child: builder(context, coordinate, unitSize),
    );
  }
}
