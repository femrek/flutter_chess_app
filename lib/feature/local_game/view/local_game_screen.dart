import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localchess/feature/local_game/view/mixin/local_game_state_mixin.dart';
import 'package:localchess/feature/local_game/view_model/local_game_state.dart';
import 'package:localchess/feature/local_game/view_model/local_game_view_model.dart';
import 'package:localchess/product/cache/model/local_game_save_cache_model.dart';
import 'package:localchess/product/data/chess_turn/app_chess_turn_status.dart';
import 'package:localchess/product/data/chess_turn/chess_turn_localization.dart';
import 'package:localchess/product/data/square_coordinate.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/state/base/base_state.dart';
import 'package:localchess/product/theme/app_color_scheme.dart';
import 'package:localchess/product/widget/board/game_board_with_frame.dart';
import 'package:localchess/product/widget/board/painter/piece_background_painter.dart';
import 'package:localchess/product/widget/button/app_button/app_button.dart';

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
            _Board(
              onFocusTried: onFocusTried,
              onMoveTried: onMoveTried,
            ),
            if (kDebugMode) _DebugButtons(),
          ],
        ),
      ),
    );
  }
}

class _DebugButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocSelector<LocalGameViewModel, LocalGameState, AppChessTurnStatus?>(
          selector: (state) {
            if (state is LocalGameLoadedState) {
              return state.checkStatus;
            }
            return null;
          },
          builder: (context, status) {
            return Text(status?.localized ?? 'Unknown');
          },
        ),
        AppButton(
          onPressed: () {
            context.read<LocalGameViewModel>().undo();
          },
          child: const Text('Undo'),
        ),
        AppButton(
          onPressed: () {
            context.read<LocalGameViewModel>().redo();
          },
          child: const Text('Redo'),
        ),
        AppButton(
          onPressed: () {
            context.read<LocalGameViewModel>().reset();
          },
          child: const Text('Reset'),
        ),
      ],
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
    return ColoredBox(
      color: AppColorScheme.boardBackgroundColor,
      child: SafeArea(
        bottom: false,
        child: GameBoardWithFrame(
          size: MediaQuery.of(context).size.width,
          squareBuilder: squareBuilder,
        ),
      ),
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
      child: DragTarget<SquareCoordinate>(
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
            child: BlocBuilder<LocalGameViewModel, LocalGameState>(
              builder: (context, state) {
                // Do not show anything if the state is not loaded.
                if (state is! LocalGameLoadedState) {
                  return const SizedBox.shrink();
                }

                // get piece in this tile if it exists.
                final piece = state.getPieceAt(coordinate);

                if (state.isFocused && state.focusedCoordinate != coordinate) {
                  final moves = state.moves;

                  // log error and show nothing if moves is null.
                  if (moves == null) {
                    G.logger.e('moves is null when focused');
                    return const SizedBox.shrink();
                  }

                  // check if can be moved to this coordinate.
                  if (moves.containsKey(coordinate)) {
                    // show the move dot if the piece is null.
                    if (piece == null) {
                      return Container(
                        margin: const EdgeInsets.all(14),
                        decoration: const BoxDecoration(
                          color: AppColorScheme.moveDotsColor,
                          shape: BoxShape.circle,
                        ),
                      );
                    }

                    // this piece can be captured.
                    return CustomPaint(
                      painter: PieceBackgroundPainter.attackableToThis,
                      child: piece.asImage,
                    );
                  }
                }

                if (piece == null) return const SizedBox.shrink();

                final movable =
                    state.movablePiecesCoordinates.contains(coordinate);

                return Draggable<SquareCoordinate>(
                  data: coordinate,
                  onDragStarted: () {
                    onFocusTried(coordinate);
                  },
                  maxSimultaneousDrags: movable ? 1 : 0,
                  childWhenDragging: const SizedBox.shrink(),
                  feedback: piece.asImage,
                  child: coordinate == state.focusedCoordinate
                      ? CustomPaint(
                          painter: PieceBackgroundPainter.focused,
                          child: piece.asImage,
                        )
                      : ColoredBox(
                          color: state.checkStatus.isCheckOn(piece)
                              ? Colors.red
                              : Colors.transparent,
                          child: piece.asImage,
                        ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
