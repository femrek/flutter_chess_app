import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localchess/feature/local_game/view/mixin/local_game_state_mixin.dart';
import 'package:localchess/feature/local_game/view_model/local_game_state.dart';
import 'package:localchess/feature/local_game/view_model/local_game_view_model.dart';
import 'package:localchess/product/constant/padding/padding_widget_extension.dart';
import 'package:localchess/product/data/chess_turn/app_chess_turn_status.dart';
import 'package:localchess/product/data/coordinate/board_orientation_enum.dart';
import 'package:localchess/product/data/coordinate/square_coordinate.dart';
import 'package:localchess/product/data/piece/app_piece.dart';
import 'package:localchess/product/data/player_color/player_color.dart';
import 'package:localchess/product/data/square_data.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/localization/locale_keys.g.dart';
import 'package:localchess/product/state/base/base_state.dart';
import 'package:localchess/product/storage/model/game_save_storage_model.dart';
import 'package:localchess/product/theme/app_color_scheme.dart';
import 'package:localchess/product/widget/board/board_square_content.dart';
import 'package:localchess/product/widget/board/game_board_with_frame.dart';
import 'package:localchess/product/widget/board/square_highlighter/square_highlighter_function_types.dart';
import 'package:localchess/product/widget/board/square_highlighter/square_highlighter_helper.dart';
import 'package:localchess/product/widget/board/square_highlighter/square_highlighter_implementor_mixin.dart';
import 'package:localchess/product/widget/header/game_screens_header.dart';
import 'package:localchess/product/widget/player_information_section/captured_piece_indicator/captured_piece_indicator.dart';
import 'package:localchess/product/widget/player_information_section/captured_piece_indicator/horizontal_direction.dart';
import 'package:localchess/product/widget/player_information_section/turn_indicator.dart';

/// Local Game Screen widget
@RoutePage()
class LocalGameScreen extends StatefulWidget {
  /// Local Game Screen widget constructor
  const LocalGameScreen({
    required this.save,
    super.key,
  });

  /// The selected save to play
  final GameSaveStorageModel save;

  @override
  State<LocalGameScreen> createState() => _LocalGameScreenState();
}

class _LocalGameScreenState extends BaseState<LocalGameScreen>
    with SquareHighlighterImplementorMixin, LocalGameStateMixin {
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
                    GameScreensHeader(
                      gameName: widget.save.gameSave.name,
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
                      onDragEnter: onSquareDragEnter,
                      onDragLeave: onSquareDragLeave,
                    ),
                  ],
                ),
              ),
            ),

            // the free space left from the board.
            // contains captured pieces, turn status and etc.
            const Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // white side information section
                  Expanded(
                    child: SafeArea(
                      top: false,
                      child: _InfoSection(color: PlayerColor.white),
                    ),
                  ),

                  // divider
                  VerticalDivider(),

                  // black side information section
                  Expanded(
                    child: SafeArea(
                      top: false,
                      child: _InfoSection(color: PlayerColor.black),
                    ),
                  ),
                ],
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
            color: frontColor.withValues(alpha: canUndo ? 255 : 128),
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
            color: frontColor.withValues(alpha: canRedo ? 255 : 128),
          ),
        );
      },
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({
    required this.color,
  });

  final PlayerColor color;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: color.when(black: 3, white: 1),
      child: const EdgeInsets.symmetric(horizontal: 8).toWidget(
        child: Column(
          // align the children to board side. currently useless because the
          // content fills the whole space.
          crossAxisAlignment: color.when(
            black: CrossAxisAlignment.end,
            white: CrossAxisAlignment.start,
          ),

          children: [
            // turn status
            _TurnIndicator(side: color),

            const Spacer(),

            // black side captured pieces. white pieces here.
            _CapturedPieceIndicator(
              playerColor: color,
            ),
          ],
        ),
      ),
    );
  }
}

class _TurnIndicator extends StatelessWidget {
  const _TurnIndicator({
    required this.side,
  });

  final PlayerColor side;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<LocalGameViewModel, LocalGameState,
        AppChessTurnStatus?>(
      selector: (state) {
        if (state is LocalGameLoadedState) {
          return state.turnStatus;
        }
        return null;
      },
      builder: (context, status) {
        if (status == null) return const SizedBox.shrink();
        return TurnIndicator(
          status: status,
          side: side,
          textColor: Theme.of(context).colorScheme.onSurface,
        );
      },
    );
  }
}

class _CapturedPieceIndicator extends StatelessWidget {
  const _CapturedPieceIndicator({
    required this.playerColor,
  });

  final PlayerColor playerColor;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<LocalGameViewModel, LocalGameState, List<AppPiece>>(
      selector: (state) {
        if (state is LocalGameLoadedState) {
          return state.capturedPieces
              .where((e) => playerColor != e.color)
              .toList();
        }
        return [];
      },
      builder: (context, pieces) {
        return CapturedPieceIndicator(
            pieces: pieces,
            pieceSize: MediaQuery.of(context).size.width / 8,
            direction: playerColor.when(
                black: HorizontalDirection.rightToLeft,
                white: HorizontalDirection.leftToRight));
      },
    );
  }
}

class _Board extends StatelessWidget {
  const _Board({
    required this.onFocusTried,
    required this.onMoveTried,
    required this.onDragEnter,
    required this.onDragLeave,
  });

  /// The function to call when the user taps on a square to focus on a piece
  /// or drag a piece.
  final void Function(SquareCoordinate) onFocusTried;

  /// The function to call when the user tries to move a piece.
  final Future<void> Function(SquareCoordinate) onMoveTried;

  /// The function to call when the user drags a piece over a square.
  final OnDragEnter onDragEnter;

  /// The function to call when the user drags a piece out of a square.
  final OnDragLeave onDragLeave;

  @override
  Widget build(BuildContext context) {
    return GameBoardWithFrame.landscape(
      size: MediaQuery.of(context).size.width,
      squareBuilder: squareBuilder,
    );
  }

  Widget squareBuilder(
    BuildContext context,
    SquareCoordinate coordinate,
    double unitSize,
  ) {
    final squareHighlighterHelper = SquareHighlighterHelper(unitSize: unitSize);
    final squareKey = GlobalKey();
    return InkWell(
      key: squareKey,
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
        onLeave: (_) {
          onDragLeave(context, coordinate, squareKey);
        },
        onMove: (_) {
          onDragEnter(
            context,
            coordinate,
            squareHighlighterHelper.overlayBuilder,
            squareKey,
            squareHighlighterHelper.offset,
          );
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
                  unitSize: unitSize,
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
