import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localchess/feature/local_game/view/mixin/local_game_state_mixin.dart';
import 'package:localchess/feature/local_game/view/widget/local_game_header.dart';
import 'package:localchess/feature/local_game/view_model/local_game_state.dart';
import 'package:localchess/feature/local_game/view_model/local_game_view_model.dart';
import 'package:localchess/product/cache/model/local_game_save_cache_model.dart';
import 'package:localchess/product/data/chess_turn/app_chess_turn_status.dart';
import 'package:localchess/product/data/chess_turn/chess_turn_localization.dart';
import 'package:localchess/product/data/coordinate/square_coordinate.dart';
import 'package:localchess/product/data/square_data.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/state/base/base_state.dart';
import 'package:localchess/product/theme/app_color_scheme.dart';
import 'package:localchess/product/widget/board/board_square_content.dart';
import 'package:localchess/product/widget/board/game_board_with_frame.dart';
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
            ColoredBox(
              color: AppColorScheme.boardBackgroundColor,
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    LocalGameHeader(
                      gameName: widget.save.localGameSave.name,
                      frontColor: AppColorScheme.boardCoordinateTextColor,
                    ),
                    _Board(
                      onFocusTried: onFocusTried,
                      onMoveTried: onMoveTried,
                    ),
                  ],
                ),
              ),
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
              return state.turnStatus;
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
                );
              },
            ),
          );
        },
      ),
    );
  }
}
