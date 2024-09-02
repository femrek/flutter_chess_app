import 'package:flutter/material.dart';
import 'package:localchess/product/data/coordinate/board_orientation_enum.dart';
import 'package:localchess/product/data/coordinate/square_coordinate.dart';
import 'package:localchess/product/widget/board/board_square.dart';

/// The widget that shows the game board only. coordinate indicators are not
/// included
class GameBoard extends StatelessWidget {
  /// The widget that shows the game board only constructor
  const GameBoard({
    required this.unitSize,
    required this.squareBuilder,
    required this.orientation,
    super.key,
  });

  /// The size of a square
  final double unitSize;

  /// The builder function to build piece on the square
  final BoardSquareBuilder squareBuilder;

  /// The orientation of the board
  final BoardOrientationEnum orientation;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
      ),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 64,
      itemBuilder: (context, index) {
        return BoardSquare(
          unitSize: unitSize,
          coordinate: orientation == BoardOrientationEnum.portrait
              ? SquareCoordinate.fromIndexStartWithA8(index)
              : SquareCoordinate.fromIndexStartWithA1(index),
          builder: squareBuilder,
        );
      },
    );
  }
}
