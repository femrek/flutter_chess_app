import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localchess/feature/guest_game/view/mixin/guest_game_state_mixin.dart';
import 'package:localchess/feature/guest_game/view_model/guest_game_state.dart';
import 'package:localchess/feature/guest_game/view_model/guest_game_view_model.dart';
import 'package:localchess/product/constant/padding/app_padding.dart';
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
import 'package:localchess/product/theme/app_color_scheme.dart';
import 'package:localchess/product/widget/board/board_square_content.dart';
import 'package:localchess/product/widget/board/game_board_with_frame.dart';
import 'package:localchess/product/widget/button/app_button/app_button.dart';
import 'package:localchess/product/widget/header/game_screens_header.dart';
import 'package:localchess/product/widget/player_information_section/captured_piece_indicator/captured_piece_indicator.dart';
import 'package:localchess/product/widget/player_information_section/turn_indicator.dart';

/// Guest Game Screen widget
@RoutePage()
class GuestGameScreen extends StatefulWidget {
  /// Guest Game Screen widget constructor
  const GuestGameScreen({
    required this.hostAddress,
    super.key,
  });

  /// The host address to connect to the game.
  final AddressOnNetwork hostAddress;

  @override
  State<GuestGameScreen> createState() => _GuestGameScreenState();
}

class _GuestGameScreenState extends BaseState<GuestGameScreen>
    with GuestGameStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: G.guestGameViewModel,
      child: Scaffold(
        body: BlocBuilder<GuestGameViewModel, GuestGameState>(
          buildWhen: (previous, current) {
            return previous.runtimeType != current.runtimeType;
          },
          builder: (context, state) {
            if (state is GuestGameNoHostErrorState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: double.infinity),
                  const AppPadding.screen().toWidget(
                    child: Text(
                      LocaleKeys.screen_guestGame_noHostError,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                    ).tr(),
                  ),
                  AppButton(
                    onPressed: () {
                      context.router.maybePop();
                    },
                    child: const Text(LocaleKeys.screen_guestGame_back).tr(),
                  ),
                ],
              );
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ColoredBox(
                  color: AppColorScheme.boardBackgroundColor,
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      children: [
                        _Header(),
                        _Board(
                          onFocusTried: onFocusTried,
                          onMoveTried: onMoveTried,
                        ),
                      ],
                    ),
                  ),
                ),

                // information about the game status. (turn, captured pieces)
                const AppPadding.screen(vertical: 0)
                    .toWidget(child: _InfoSection()),

                const Spacer(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<GuestGameViewModel, GuestGameState, String?>(
      selector: (state) {
        final hostName = state.serverInformation?.deviceName ?? '';
        final gameName = state.gameMetadata?.gameName ?? '';
        return '$hostName - $gameName';
      },
      builder: (context, gameName) {
        if (gameName == null) return const SizedBox.shrink();

        return GameScreensHeader(
          gameName: gameName,
          frontColor: AppColorScheme.boardCoordinateTextColor,
          undoButtonBuilder: (_) => const SizedBox.shrink(),
          redoButtonBuilder: (_) => const SizedBox.shrink(),
          onRestartPressed: () {},
          showRestartButton: false,
        );
      },
    );
  }
}

class _InfoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<GuestGameViewModel, GuestGameState, PlayerColor?>(
      selector: (state) {
        return state.gameMetadata?.playerColor;
      },
      builder: (context, playerColor) {
        if (playerColor == null) return const SizedBox.shrink();

        return Column(
          children: [
            _CapturedPieceIndicator(playerColor: playerColor),
            _TurnIndicator(side: playerColor),
          ],
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
    return BlocSelector<GuestGameViewModel, GuestGameState, bool>(
      selector: (state) {
        return state.isAllowedToGame;
      },
      builder: (context, allowed) {
        if (!allowed) return const SizedBox.shrink();

        return BlocSelector<GuestGameViewModel, GuestGameState,
            AppChessTurnStatus?>(
          selector: (state) {
            return state.gameState?.turnStatus;
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
    return BlocSelector<GuestGameViewModel, GuestGameState, bool>(
      selector: (state) {
        return state.isAllowedToGame;
      },
      builder: (context, allowed) {
        if (!allowed) {
          return const AppPadding(top: 8).toWidget(
            child: const Text(
              LocaleKeys.screen_guestGame_youAreNotAllowed,
            ).tr(),
          );
        }

        return BlocSelector<GuestGameViewModel, GuestGameState,
            List<AppPiece>?>(
          selector: (state) {
            return state.gameState?.capturedPieces
                .where((e) => playerColor != e.color)
                .toList();
          },
          builder: (context, pieces) {
            if (pieces == null) return const SizedBox.shrink();

            return CapturedPieceIndicator(
              pieces: pieces,
              pieceSize: MediaQuery.of(context).size.width / 8,
            );
          },
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
    return BlocSelector<GuestGameViewModel, GuestGameState, PlayerColor?>(
      selector: (state) {
        return state.gameMetadata?.playerColor;
      },
      builder: (context, color) {
        if (color == null) return const SizedBox.shrink();

        return GameBoardWithFrame(
          size: MediaQuery.of(context).size.width,
          squareBuilder: squareBuilder,
          orientation: color.when(
            black: BoardOrientationEnum.portraitUpsideDown,
            white: BoardOrientationEnum.portrait,
          ),
        );
      },
    );
  }

  Widget squareBuilder(
    BuildContext context,
    SquareCoordinate coordinate,
    double unitSize,
  ) {
    return InkWell(
      onTap: () {
        final state = context.read<GuestGameViewModel>().state;
        final isFocused = state.gameState?.isFocused;
        if (isFocused == null) return;

        if (isFocused) {
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
            child: BlocSelector<GuestGameViewModel, GuestGameState, SquareData>(
              selector: (state) {
                return state.gameState?.squareStates[coordinate] ??
                    const SquareData.withDefaultValues();
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
