import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localchess/feature/local_game/view/mixin/local_game_state_mixin.dart';
import 'package:localchess/feature/local_game/view_model/local_game_state.dart';
import 'package:localchess/feature/local_game/view_model/local_game_view_model.dart';
import 'package:localchess/product/cache/model/local_game_save_cache_model.dart';
import 'package:localchess/product/data/square_coordinate.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/service/core/i_chess_service.dart';
import 'package:localchess/product/state/base/base_state.dart';
import 'package:localchess/product/theme/app_color_scheme.dart';
import 'package:localchess/product/widget/board/game_board_with_frame.dart';

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
            _Board(),
          ],
        ),
      ),
    );
  }
}

class _Board extends StatelessWidget {
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
    return BlocSelector<LocalGameViewModel, LocalGameState, IChessService?>(
      selector: (state) {
        if (state is! LocalGameLoadedState) return null;
        return state.chessService;
      },
      builder: (context, chess) {
        if (chess == null) return const SizedBox.shrink();

        final piece = chess.getPieceAt(coordinate);
        if (piece == null) return const SizedBox.shrink();

        return Draggable(
          data: coordinate,
          feedback: Transform.rotate(
            angle: 90 * 3.1415926535 / 180,
            child: piece.asImage,
          ),
          child: ColoredBox(
            color: Colors.transparent,
            child: piece.asImage,
          ),
        );
      },
    );
  }
}
