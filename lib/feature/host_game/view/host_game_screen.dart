import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localchess/feature/host_game/view/mixin/host_game_mixin.dart';
import 'package:localchess/feature/host_game/view_model/host_game_state.dart';
import 'package:localchess/feature/host_game/view_model/host_game_view_model.dart';
import 'package:localchess/product/cache/model/game_save_cache_model.dart';
import 'package:localchess/product/constant/padding/app_padding.dart';
import 'package:localchess/product/constant/padding/padding_widget_extension.dart';
import 'package:localchess/product/data/chess_turn/app_chess_turn_status.dart';
import 'package:localchess/product/data/coordinate/board_orientation_enum.dart';
import 'package:localchess/product/data/coordinate/square_coordinate.dart';
import 'package:localchess/product/data/piece/app_piece.dart';
import 'package:localchess/product/data/player_color/player_color.dart';
import 'package:localchess/product/data/square_data.dart';
import 'package:localchess/product/localization/locale_keys.g.dart';
import 'package:localchess/product/state/base/base_state.dart';
import 'package:localchess/product/theme/app_color_scheme.dart';
import 'package:localchess/product/widget/board/board_square_content.dart';
import 'package:localchess/product/widget/board/game_board_with_frame.dart';
import 'package:localchess/product/widget/header/game_screens_header.dart';
import 'package:localchess/product/widget/player_information_section/captured_piece_indicator/captured_piece_indicator.dart';
import 'package:localchess/product/widget/player_information_section/turn_indicator.dart';

/// Host Screen widget
@RoutePage()
class HostGameScreen extends StatefulWidget {
  /// Host Screen widget constructor
  const HostGameScreen({
    required this.save,
    required this.chosenColor,
    super.key,
  });

  /// The save data to play.
  final GameSaveCacheModel save;

  /// The color chosen by the host player.
  final PlayerColor chosenColor;

  @override
  State<HostGameScreen> createState() => _HostGameScreenState();
}

class _HostGameScreenState extends BaseState<HostGameScreen>
    with HostGameStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              // the box covers the header and the board.
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

                      // the board
                      _Board(
                        onFocusTried: onFocusTried,
                        onMoveTried: onMoveTried,
                        thePlayerColorOfThisDevice: widget.chosenColor,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // the player information section
              const AppPadding.screen(vertical: 0).toWidget(
                child: _TurnIndicator(side: widget.chosenColor),
              ),
              _CapturedPieceIndicator(playerColor: widget.chosenColor),

              const SizedBox(height: 8),

              // network information
              _NetworkManagementSection(),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _NetworkManagementSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<HostGameViewModel, HostGameState, HostGameNetworkState>(
      selector: (state) {
        if (state is HostGameLoadedState) {
          return state.networkState;
        }
        return const HostGameNetworkState.initial();
      },
      builder: (context, networkState) {
        return Column(
          children: [
            Text('connect to: ${networkState.runningHost}'
                ':${networkState.runningPort}'),
            Text('server running: ${networkState.isServerRunning}'),
            Text('clients: ${networkState.connectedClients}'),
          ],
        );
      },
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
    return BlocSelector<HostGameViewModel, HostGameState, bool>(
      selector: (state) {
        if (state is HostGameLoadedState) {
          return state.gameState.canUndo;
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
    return BlocSelector<HostGameViewModel, HostGameState, bool>(
      selector: (state) {
        if (state is HostGameLoadedState) {
          return state.gameState.canRedo;
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

class _TurnIndicator extends StatelessWidget {
  const _TurnIndicator({
    required this.side,
  });

  final PlayerColor side;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HostGameViewModel, HostGameState, AppChessTurnStatus?>(
      selector: (state) {
        if (state is HostGameLoadedState) {
          return state.gameState.turnStatus;
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
    return BlocSelector<HostGameViewModel, HostGameState, List<AppPiece>>(
      selector: (state) {
        if (state is HostGameLoadedState) {
          return state.gameState.capturedPieces
              .where((e) => playerColor != e.color)
              .toList();
        }
        return [];
      },
      builder: (context, pieces) {
        return CapturedPieceIndicator(
          pieces: pieces,
          pieceSize: MediaQuery.of(context).size.width / 8,
        );
      },
    );
  }
}

class _Board extends StatelessWidget {
  const _Board({
    required this.onFocusTried,
    required this.onMoveTried,
    required this.thePlayerColorOfThisDevice,
  });

  /// The function to call when the user taps on a square to focus on a piece
  /// or drag a piece.
  final void Function(SquareCoordinate) onFocusTried;

  /// The function to call when the user tries to move a piece.
  final Future<void> Function(SquareCoordinate) onMoveTried;

  final PlayerColor thePlayerColorOfThisDevice;

  @override
  Widget build(BuildContext context) {
    return GameBoardWithFrame(
      size: MediaQuery.of(context).size.width,
      squareBuilder: squareBuilder,
      orientation: thePlayerColorOfThisDevice.when(
        black: BoardOrientationEnum.portraitUpsideDown,
        white: BoardOrientationEnum.portrait,
      ),
    );
  }

  Widget squareBuilder(BuildContext context, SquareCoordinate coordinate) {
    return InkWell(
      onTap: () {
        final state = context.read<HostGameViewModel>().state;
        if (state is! HostGameLoadedState) return;
        if (state.gameState.isFocused) {
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
            child: BlocSelector<HostGameViewModel, HostGameState, SquareData>(
              selector: (state) {
                if (state is HostGameLoadedState) {
                  return state.gameState.squareStates[coordinate] ??
                      const SquareData.withDefaultValues();
                }
                return const SquareData.withDefaultValues();
              },
              builder: (context, state) {
                return BoardSquareContent(
                  data: state,
                  onDragStarted: () => onFocusTried(coordinate),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
