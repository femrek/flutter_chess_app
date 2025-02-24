import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localchess/feature/host_game/view/mixin/host_game_mixin.dart';
import 'package:localchess/feature/host_game/view/widget/host_game_guest_entry.dart';
import 'package:localchess/feature/host_game/view_model/host_game_state.dart';
import 'package:localchess/feature/host_game/view_model/host_game_view_model.dart';
import 'package:localchess/product/constant/padding/app_padding.dart';
import 'package:localchess/product/constant/padding/app_padding_constant.dart';
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
  final GameSaveStorageModel save;

  /// The color chosen by the host player.
  final PlayerColor chosenColor;

  @override
  State<HostGameScreen> createState() => _HostGameScreenState();
}

class _HostGameScreenState extends BaseState<HostGameScreen>
    with SquareHighlighterImplementorMixin, HostGameStateMixin {
  @override
  Widget build(BuildContext context) {
    final verticalPadding = MediaQuery.of(context).padding.top +
        MediaQuery.of(context).padding.bottom;

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
                        verticalPadding: verticalPadding,
                        onDragEnter: onSquareDragEnter,
                        onDragLeave: onSquareDragLeave,
                      ),
                    ],
                  ),
                ),
              ),

              // the player information section
              _CapturedPieceIndicator(playerColor: widget.chosenColor),
              const AppPadding.screen(vertical: 0).toWidget(
                child: _TurnIndicator(side: widget.chosenColor),
              ),

              const SizedBox(height: 8),

              // network information
              Expanded(
                child: _NetworkManagementSection(
                  onAllowPressed: onAllowGuestPressed,
                  onMakeSpecPressed: onMakeSpecPressed,
                  onKickPressed: onKickGuestPressed,
                  onNetworkPropertiesPressed: onNetworkPropertiesPressed,
                  onConnectedClientsMorePressed: onConnectedClientsMorePressed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NetworkManagementSection extends StatelessWidget {
  const _NetworkManagementSection({
    required this.onAllowPressed,
    required this.onMakeSpecPressed,
    required this.onKickPressed,
    required this.onNetworkPropertiesPressed,
    required this.onConnectedClientsMorePressed,
  });

  final void Function(HostGameClientState) onAllowPressed;
  final void Function() onMakeSpecPressed;
  final void Function(HostGameClientState) onKickPressed;
  final VoidCallback onNetworkPropertiesPressed;
  final void Function(WidgetBuilder) onConnectedClientsMorePressed;

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
        // get the previewing client bottom of the screen. If there is no
        // previewing client, it means no guest is connected.
        final previewingClient = networkState.allowedClient ??
            networkState.connectedClients.firstOrNull;

        return Row(
          children: [
            const SizedBox(width: AppPaddingConstant.screenHorizontal),

            // icon button for show server address
            IconButton(
              onPressed: onNetworkPropertiesPressed,
              tooltip: LocaleKeys.screen_hostGame_tooltipHostInfo.tr(),
              icon: const Icon(Icons.settings_ethernet),
            ),

            // current player preview or no guest text
            if (previewingClient != null)
              Expanded(
                child: HostGameGuestEntry(
                  client: previewingClient,
                  onPlayWithGuestPressed: () {
                    onAllowPressed(previewingClient);
                  },
                  onMakeSpecPressed: onMakeSpecPressed,
                  onKickGuestPressed: () {
                    onKickPressed(previewingClient);
                  },
                ),
              )
            else
              const Text(
                LocaleKeys.screen_hostGame_noGuest,
              ).tr(),

            // icon button for open connected clients bottom sheet
            if (networkState.connectedClients.isNotEmpty)
              IconButton(
                onPressed: () =>
                    onConnectedClientsMorePressed(_bottomSheetBuilder),
                tooltip: LocaleKeys.screen_hostGame_tooltipConnectedGuests.tr(),
                icon: const Icon(Icons.more_horiz),
              ),
            const SizedBox(width: AppPaddingConstant.screenHorizontal),
          ],
        );
      },
    );
  }

  Widget _bottomSheetBuilder(BuildContext context) {
    return BlocProvider.value(
      value: G.hostGameViewModel,
      child:
          BlocSelector<HostGameViewModel, HostGameState, HostGameNetworkState>(
        selector: (state) {
          if (state is HostGameLoadedState) {
            return state.networkState;
          }
          return const HostGameNetworkState.initial();
        },
        builder: (context, state) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                constraints: const BoxConstraints(minHeight: 300),
                child: ListView.builder(
                  padding: const AppPadding.scrollable(),
                  shrinkWrap: true,
                  itemCount: state.connectedClients.length,
                  itemBuilder: (context, index) {
                    final client = state.connectedClients[index];
                    return HostGameGuestEntry(
                      client: client,
                      onPlayWithGuestPressed: () => onAllowPressed(client),
                      onMakeSpecPressed: onMakeSpecPressed,
                      onKickGuestPressed: () => onKickPressed(client),
                    );
                  },
                ),
              );
            },
          );
        },
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
            color: frontColor.withValues(alpha: canRedo ? 255 : 128),
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
    required this.verticalPadding,
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

  final PlayerColor thePlayerColorOfThisDevice;

  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    return GameBoardWithFrame(
      size: _getBoardSize(context),
      squareBuilder: squareBuilder,
      orientation: thePlayerColorOfThisDevice.when(
        black: BoardOrientationEnum.portraitUpsideDown,
        white: BoardOrientationEnum.portrait,
      ),
    );
  }

  double _getBoardSize(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final remainingH = h -
        // header height
        kToolbarHeight -
        // board height (default)
        w -
        // device padding
        verticalPadding;
    final requiredH = TurnIndicator.height +
        // captured piece indicator height
        w / 9 +
        // spacer height
        8 +
        // network management section height (predicted)
        76;
    final diff = requiredH - remainingH;

    late double multiplier;
    {
      if (diff < 0) {
        multiplier = 1;
      } else {
        multiplier = (w - diff) / w;
      }
    }

    G.logger.d('HostGameScreen: _Board: '
        ' h: $h, w: $w, remainingH: $remainingH, '
        'requiredH: $requiredH, diff: $diff, '
        'multiplier: $multiplier');

    return w * multiplier;
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
                  unitSize: unitSize,
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
