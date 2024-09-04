import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localchess/feature/local_game/view/mixin/local_game_state_mixin.dart';
import 'package:localchess/feature/local_game/view/widget/local_game_header.dart';
import 'package:localchess/feature/local_game/view_model/local_game_state.dart';
import 'package:localchess/feature/local_game/view_model/local_game_view_model.dart';
import 'package:localchess/product/cache/model/local_game_save_cache_model.dart';
import 'package:localchess/product/data/coordinate/board_orientation_enum.dart';
import 'package:localchess/product/data/coordinate/square_coordinate.dart';
import 'package:localchess/product/data/piece/app_piece.dart';
import 'package:localchess/product/data/square_data.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/localization/locale_keys.g.dart';
import 'package:localchess/product/state/base/base_state.dart';
import 'package:localchess/product/theme/app_color_scheme.dart';
import 'package:localchess/product/widget/board/board_square_content.dart';
import 'package:localchess/product/widget/board/game_board_with_frame.dart';
import 'package:localchess/product/widget/captured_piece_indicator/captured_piece_indicator.dart';
import 'package:localchess/product/widget/captured_piece_indicator/horizontal_direction.dart';

/// Local Game Screen widget
@RoutePage()
class LocalGameScreen extends StatefulWidget {
  /// Local Game Screen widget constructor
  const LocalGameScreen({
    required this.save,
    super.key,
  });

  /// The selected save to play
  final LocalGameSaveCacheModel save;

  @override
  State<LocalGameScreen> createState() => _LocalGameScreenState();
}

class _LocalGameScreenState extends BaseState<LocalGameScreen>
    with LocalGameStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: G.localGameViewModel,
      child: Scaffold(
        body: Column(
          children: [
            // The board and the header. colored with the board background color
            // contains status bar, header and the game board.
            ColoredBox(
              color: AppColorScheme.boardBackgroundColor,
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    // the header
                    LocalGameHeader(
                      gameName: widget.save.localGameSave.name,
                      frontColor: AppColorScheme.boardCoordinateTextColor,
                      undoButtonBuilder: (context) {
                        return _UndoButtonBuilder(
                          frontColor: AppColorScheme.boardCoordinateTextColor,
                          onPressed: onUndoPressed,
                        );
                      },
                      redoButtonBuilder: (context) {
                        return _RedoButtonBuilder(
                          frontColor: AppColorScheme.boardCoordinateTextColor,
                          onPressed: onRedoPressed,
                        );
                      },
                      onRestartPressed: onRestartPressed,
                    ),

                    // The board
                    _Board(
                      onFocusTried: onFocusTried,
                      onMoveTried: onMoveTried,
                    ),
                  ],
                ),
              ),
            ),

            // the free space left from the board.
            // contains captured pieces, turn status and etc.
            const Expanded(
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    // white side captured pieces. black pieces here.
                    RotatedBox(
                      quarterTurns: 1,
                      child: _CapturedPieceIndicator(isCapturedByDark: false),
                    ),

                    Spacer(),

                    // black side captured pieces. white pieces here.
                    RotatedBox(
                      quarterTurns: 3,
                      child: _CapturedPieceIndicator(isCapturedByDark: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UndoButtonBuilder extends StatelessWidget {
  const _UndoButtonBuilder({
    required this.frontColor,
    required this.onPressed,
  });

  final Color frontColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<LocalGameViewModel, LocalGameState, bool>(
      selector: (state) {
        if (state is LocalGameLoadedState) {
          return state.canUndo;
        }
        return false;
      },
      builder: (context, canUndo) {
        return IconButton(
          tooltip: LocaleKeys.game_undo.tr(),
          onPressed: onPressed,
          icon: Icon(
            Icons.undo,
            color: frontColor.withOpacity(canUndo ? 1 : 0.5),
          ),
        );
      },
    );
  }
}

class _RedoButtonBuilder extends StatelessWidget {
  const _RedoButtonBuilder({
    required this.frontColor,
    required this.onPressed,
  });

  final Color frontColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<LocalGameViewModel, LocalGameState, bool>(
      selector: (state) {
        if (state is LocalGameLoadedState) {
          return state.canRedo;
        }
        return false;
      },
      builder: (context, canRedo) {
        return IconButton(
          tooltip: LocaleKeys.game_redo.tr(),
          onPressed: canRedo ? onPressed : null,
          icon: Icon(
            Icons.redo,
            color: frontColor.withOpacity(canRedo ? 1 : 0.5),
          ),
        );
      },
    );
  }
}

class _CapturedPieceIndicator extends StatelessWidget {
  const _CapturedPieceIndicator({
    required this.isCapturedByDark,
  });

  final bool isCapturedByDark;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<LocalGameViewModel, LocalGameState, List<AppPiece>>(
      selector: (state) {
        if (state is LocalGameLoadedState) {
          return state.capturedPieces
              .where((e) => e.isDark != isCapturedByDark)
              .toList();
        }
        return [];
      },
      builder: (context, pieces) {
        return CapturedPieceIndicator(
          pieces: pieces,
          pieceSize: MediaQuery.of(context).size.width / 8,
          direction: isCapturedByDark
              ? HorizontalDirection.rightToLeft
              : HorizontalDirection.leftToRight,
        );
      },
    );
  }
}

class _Board extends StatelessWidget {
  const _Board({
    required this.onFocusTried,
    required this.onMoveTried,
  });

  /// The function to call when the user taps on a square to focus on a piece
  /// or drag a piece.
  final void Function(SquareCoordinate) onFocusTried;

  /// The function to call when the user tries to move a piece.
  final Future<void> Function(SquareCoordinate) onMoveTried;

  @override
  Widget build(BuildContext context) {
    return GameBoardWithFrame.landscape(
      size: MediaQuery.of(context).size.width,
      squareBuilder: squareBuilder,
    );
  }

  Widget squareBuilder(BuildContext context, SquareCoordinate coordinate) {
    return InkWell(
      onTap: () {
        final state = context.read<LocalGameViewModel>().state;
        if (state is! LocalGameLoadedState) return;
        if (state.isFocused) {
          onMoveTried(coordinate);
        } else {
          onFocusTried(coordinate);
        }
      },
      child: DragTarget(
        onAcceptWithDetails: (details) {
          onMoveTried(coordinate);
        },
        builder: (context, a, b) {
          // use filling container with color property to allow the drag
          // target from taking the whole square.
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.transparent,
            child: BlocSelector<LocalGameViewModel, LocalGameState, SquareData>(
              selector: (state) {
                if (state is LocalGameLoadedState) {
                  return state.squareStates[coordinate] ??
                      const SquareData.withDefaultValues();
                }
                return const SquareData.withDefaultValues();
              },
              builder: (context, state) {
                return BoardSquareContent(
                  data: state,
                  onDragStarted: () => onFocusTried(coordinate),
                  orientation: BoardOrientationEnum.landscapeLeftBased,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
