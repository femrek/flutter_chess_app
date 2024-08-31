import 'package:flutter/material.dart';
import 'package:localchess/product/state/base/base_state.dart';
import 'package:localchess/product/theme/app_color_scheme.dart';
import 'package:localchess/product/widget/board/board_square.dart';
import 'package:localchess/product/widget/board/game_board.dart';

/// The widget that shows the game board. The board has a frame and coordinate
/// indicators
class GameBoardWithFrame extends StatefulWidget {
  /// The widget that shows the game board constructor
  const GameBoardWithFrame({
    required this.size,
    required this.squareBuilder,
    super.key,
  });

  /// The ui size of the game board
  final double size;

  /// The chess object to get board state from
  final BoardSquareBuilder squareBuilder;

  @override
  State<GameBoardWithFrame> createState() => _GameBoardWithFrameState();
}

class _GameBoardWithFrameState extends BaseState<GameBoardWithFrame> {
  double get unitSize => widget.size / 9;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColorScheme.boardBackgroundColor,
      child: Container(
        width: widget.size,
        height: widget.size,
        alignment: Alignment.center,
        child: Column(
          children: [
            _CoordinatorLine(
              unitSize: unitSize,
              side: _CoordinateLineSide.top,
            ),
            Row(
              children: [
                _CoordinatorLine(
                  unitSize: unitSize,
                  side: _CoordinateLineSide.left,
                ),
                Container(
                  width: unitSize * 8,
                  height: unitSize * 8,
                  color: Colors.teal,
                  child: GameBoard(
                    unitSize: unitSize,
                    squareBuilder: widget.squareBuilder,
                  ),
                ),
                _CoordinatorLine(
                  unitSize: unitSize,
                  side: _CoordinateLineSide.right,
                ),
              ],
            ),
            _CoordinatorLine(
              unitSize: unitSize,
              side: _CoordinateLineSide.bottom,
            ),
          ],
        ),
      ),
    );
  }
}

class _CoordinatorLine extends StatelessWidget {
  const _CoordinatorLine({
    required this.unitSize,
    required this.side,
  });

  final double unitSize;
  final _CoordinateLineSide side;

  String getCharByIndex(int index) {
    if (side.isNumeric) {
      return '${7 - index + 1}';
    }

    return String.fromCharCode('A'.codeUnitAt(0) + index);
  }

  @override
  Widget build(BuildContext context) {
    return _layoutWidget(
      context,
      [
        SizedBox(width: unitSize / 2),
        for (var i = 0; i < 8; i++)
          Container(
            width: unitSize * side.cellSizeMultiplier.width,
            height: unitSize * side.cellSizeMultiplier.height,
            alignment: Alignment.center,
            child: Text(
              getCharByIndex(i),
              textScaler: TextScaler.noScaling,
              style: _textStyle,
            ),
          ),
        SizedBox(width: unitSize / 2),
      ],
    );
  }

  Widget _layoutWidget(BuildContext context, List<Widget> children) {
    if (side.isVertical) return Column(children: children);
    return Row(children: children);
  }

  TextStyle get _textStyle => TextStyle(
        color: AppColorScheme.boardCoordinateTextColor,
        fontSize: unitSize * 0.37,
        height: 1,
      );
}

enum _CoordinateLineSide {
  left(cellSizeMultiplier: Size(0.5, 1), isNumeric: true, isVertical: true),
  right(cellSizeMultiplier: Size(0.5, 1), isNumeric: true, isVertical: true),
  top(cellSizeMultiplier: Size(1, 0.5), isNumeric: false, isVertical: false),
  bottom(cellSizeMultiplier: Size(1, 0.5), isNumeric: false, isVertical: false),
  ;

  const _CoordinateLineSide({
    required this.cellSizeMultiplier,
    required this.isNumeric,
    required this.isVertical,
  });

  final Size cellSizeMultiplier;
  final bool isNumeric;
  final bool isVertical;
}
