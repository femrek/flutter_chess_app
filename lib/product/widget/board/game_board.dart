import 'package:flutter/material.dart';
import 'package:localchess/product/model/square_coordinate.dart';
import 'package:localchess/product/widget/board/board_square.dart';

/// The widget that shows the game board only. coordinate indicators are not
/// included
class GameBoard extends StatelessWidget {
  /// The widget that shows the game board only constructor
  const GameBoard({
    required this.unitSize,
    required this.squareBuilder,
    super.key,
  });

  /// The size of a square
  final double unitSize;

  /// The builder function to build piece on the square
  final BoardSquareBuilder squareBuilder;

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
          coordinate: SquareCoordinate.fromIndexStartWithA8(index),
          builder: squareBuilder,
        );
      },
    );
  }
}
