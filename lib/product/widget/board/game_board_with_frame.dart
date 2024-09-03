import 'package:flutter/material.dart';
import 'package:localchess/product/data/coordinate/board_orientation_enum.dart';
import 'package:localchess/product/state/base/base_state.dart';
import 'package:localchess/product/theme/app_color_scheme.dart';
import 'package:localchess/product/widget/board/board_square.dart';
import 'package:localchess/product/widget/board/game_board.dart';

/// The widget that shows the game board. The board has a frame and coordinate
/// indicators
class GameBoardWithFrame extends StatefulWidget {
  /// The widget that shows the game board constructor
  const GameBoardWithFrame._internal({
    required this.size,
    required this.squareBuilder,
    required this.orientation,
  });

  /// Creates the game board with frame in landscape mode
  factory GameBoardWithFrame.portrait({
    required double size,
    required BoardSquareBuilder squareBuilder,
  }) {
    return GameBoardWithFrame._internal(
      size: size,
      squareBuilder: squareBuilder,
      orientation: BoardOrientationEnum.portrait,
    );
  }

  /// Creates the game board with frame in portrait mode
  factory GameBoardWithFrame.landscape({
    required double size,
    required BoardSquareBuilder squareBuilder,
  }) {
    return GameBoardWithFrame._internal(
      size: size,
      squareBuilder: squareBuilder,
      orientation: BoardOrientationEnum.landscapeLeftBased,
    );
  }

  /// The ui size of the game board
  final double size;

  /// The chess object to get board state from
  final BoardSquareBuilder squareBuilder;

  /// Creates the game board with frame in landscape mode
  final BoardOrientationEnum orientation;

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
              side: widget.orientation == BoardOrientationEnum.portrait
                  ? _CoordinateLineSide.topP
                  : _CoordinateLineSide.topL,
            ),
            Row(
              children: [
                _CoordinatorLine(
                  unitSize: unitSize,
                  side: widget.orientation == BoardOrientationEnum.portrait
                      ? _CoordinateLineSide.leftP
                      : _CoordinateLineSide.leftL,
                ),
                Container(
                  width: unitSize * 8,
                  height: unitSize * 8,
                  color: Colors.teal,
                  child: GameBoard(
                    unitSize: unitSize,
                    squareBuilder: widget.squareBuilder,
                    orientation: widget.orientation,
                  ),
                ),
                _CoordinatorLine(
                    unitSize: unitSize,
                    side: widget.orientation == BoardOrientationEnum.portrait
                        ? _CoordinateLineSide.rightP
                        : _CoordinateLineSide.rightL),
              ],
            ),
            _CoordinatorLine(
                unitSize: unitSize,
                side: widget.orientation == BoardOrientationEnum.portrait
                    ? _CoordinateLineSide.bottomP
                    : _CoordinateLineSide.bottomL),
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
      if (side.reverse) {
        return '${7 - index + 1}';
      }
      return '${index + 1}';
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
            child: Transform.rotate(
              angle: side.angel,
              child: Text(
                getCharByIndex(i),
                textScaler: TextScaler.noScaling,
                style: _textStyle,
              ),
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
  // portrait
  leftP(
    cellSizeMultiplier: Size(0.5, 1),
    isNumeric: true,
    isVertical: true,
    angel: 0,
    reverse: true,
  ),
  rightP(
    cellSizeMultiplier: Size(0.5, 1),
    isNumeric: true,
    isVertical: true,
    angel: 0,
    reverse: true,
  ),
  topP(
    cellSizeMultiplier: Size(1, 0.5),
    isNumeric: false,
    isVertical: false,
    angel: 0,
    reverse: false,
  ),
  bottomP(
    cellSizeMultiplier: Size(1, 0.5),
    isNumeric: false,
    isVertical: false,
    angel: 0,
    reverse: false,
  ),

  // landscape
  leftL(
    cellSizeMultiplier: Size(0.5, 1),
    isNumeric: false,
    isVertical: true,
    angel: 90 * 3.1415926535 / 180,
    reverse: false,
  ),
  rightL(
    cellSizeMultiplier: Size(0.5, 1),
    isNumeric: false,
    isVertical: true,
    angel: -90 * 3.1415926535 / 180,
    reverse: false,
  ),
  topL(
    cellSizeMultiplier: Size(1, 0.5),
    isNumeric: true,
    isVertical: false,
    angel: 90 * 3.1415926535 / 180,
    reverse: false,
  ),
  bottomL(
    cellSizeMultiplier: Size(1, 0.5),
    isNumeric: true,
    isVertical: false,
    angel: -90 * 3.1415926535 / 180,
    reverse: false,
  ),
  ;

  const _CoordinateLineSide({
    required this.cellSizeMultiplier,
    required this.isNumeric,
    required this.isVertical,
    required this.angel,
    required this.reverse,
  });

  final Size cellSizeMultiplier;
  final bool isNumeric;
  final bool isVertical;
  final double angel;
  final bool reverse;
}