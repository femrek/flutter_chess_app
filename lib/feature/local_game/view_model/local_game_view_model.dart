import 'package:localchess/feature/local_game/view_model/local_game_state.dart';
import 'package:localchess/product/cache/model/local_game_save_cache_model.dart';
import 'package:localchess/product/data/move/app_chess_move.dart';
import 'package:localchess/product/data/square_coordinate.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/service/core/i_chess_service.dart';
import 'package:localchess/product/service/impl/chess_service.dart';
import 'package:localchess/product/state/base/base_cubit.dart';

/// The view model for the local game screen
class LocalGameViewModel extends BaseCubit<LocalGameState> {
  /// The view model for the local game screen
  LocalGameViewModel() : super(LocalGameInitialState());

  late IChessService _chessService;

  /// Initializes the view model
  Future<void> init(LocalGameSaveCacheModel save) async {
    G.logger.t('LocalGameViewModel.init: $save');

    _chessService = ChessService(save: save);
    final movablePiecesCoordinates =
        _chessService.moves().map((e) => e.from).toList();
    G.logger.d('movablePiecesCoordinates: $movablePiecesCoordinates');
    emit(LocalGameLoadedState(
      getPieceAt: _chessService.getPieceAt,
      movablePiecesCoordinates: movablePiecesCoordinates,
      checkStatus: _chessService.checkStatus,
    ));

    G.logger.t('LocalGameViewModel.init: Initialized');
  }

  /// Focuses on the piece at the given [coordinate]. Shows the possible moves
  /// for the piece.
  void focus(SquareCoordinate coordinate) {
    G.logger.t('LocalGameViewModel.focus: $coordinate');

    final state = this.state;
    if (state is! LocalGameLoadedState) throw Exception('Invalid state');

    // check if the coordinate is contained in movablePiecesCoordinates.
    if (!state.movablePiecesCoordinates.contains(coordinate)) {
      throw Exception(
        'Invalid coordinate when focusing. focus coordinate must be'
        ' contained in movablePiecesCoordinates',
      );
    }

    final moveMap = <SquareCoordinate, AppChessMove>{};
    _chessService.moves(from: coordinate).forEach((e) {
      if (e.from == e.to) return;
      if (e.from != coordinate) return;
      moveMap[e.to] = e;
    });

    // update the state.
    emit(LocalGameLoadedState(
      getPieceAt: _chessService.getPieceAt,
      movablePiecesCoordinates: [],
      checkStatus: _chessService.checkStatus,
      moves: moveMap,
      focusedCoordinate: coordinate,
    ));

    G.logger.t('LocalGameViewModel.focus: Focused on $coordinate. '
        'moves: $moveMap');
  }

  /// Removes the focus from the focused piece.
  void removeFocus() {
    G.logger.t('LocalGameViewModel.removeFocus');

    final state = this.state;
    if (state is! LocalGameLoadedState) throw Exception('Invalid state');

    // update the state.
    emit(LocalGameLoadedState(
      getPieceAt: _chessService.getPieceAt,
      movablePiecesCoordinates:
          _chessService.moves().map((e) => e.from).toList(),
      checkStatus: _chessService.checkStatus,
    ));

    G.logger.t('LocalGameViewModel.removeFocus: Removed focus');
  }

  /// Perform move according to [move]. if move has promotion [promotion] must
  /// not be null.
  Future<void> move({
    required AppChessMove move,
    String? promotion,
  }) async {
    G.logger.t('LocalGameViewModel.move: $move, promotion: $promotion');

    final state = this.state;
    if (state is! LocalGameLoadedState) throw Exception('Invalid state');
    if (!state.isFocused) throw Exception('No piece is focused');

    // perform the move.
    await _chessService.move(move: move, promotion: promotion);

    // update the state.
    emit(LocalGameLoadedState(
      getPieceAt: _chessService.getPieceAt,
      movablePiecesCoordinates:
          _chessService.moves().map((e) => e.from).toList(),
      checkStatus: _chessService.checkStatus,
    ));

    G.logger.t('LocalGameViewModel.move: Moved $move');
  }

  /// Undoes the last move.
  Future<void> undo() async {
    G.logger.t('LocalGameViewModel.undo');

    final state = this.state;
    if (state is! LocalGameLoadedState) throw Exception('Invalid state');

    // perform the undo.
    await _chessService.undo();

    // update the state.
    emit(LocalGameLoadedState(
      getPieceAt: _chessService.getPieceAt,
      movablePiecesCoordinates:
          _chessService.moves().map((e) => e.from).toList(),
      checkStatus: _chessService.checkStatus,
    ));

    G.logger.t('LocalGameViewModel.undo: Undone');
  }

  /// Redoes the last undone move.
  Future<void> redo() async {
    G.logger.t('LocalGameViewModel.redo');

    final state = this.state;
    if (state is! LocalGameLoadedState) throw Exception('Invalid state');

    // perform the redo.
    await _chessService.redo();

    // update the state.
    emit(LocalGameLoadedState(
      getPieceAt: _chessService.getPieceAt,
      movablePiecesCoordinates:
          _chessService.moves().map((e) => e.from).toList(),
      checkStatus: _chessService.checkStatus,
    ));

    G.logger.t('LocalGameViewModel.redo: Redone');
  }

  /// Resets the game.
  Future<void> reset() async {
    G.logger.t('LocalGameViewModel.reset');

    final state = this.state;
    if (state is! LocalGameLoadedState) throw Exception('Invalid state');

    // perform the reset.
    await _chessService.reset();

    // update the state.
    emit(LocalGameLoadedState(
      getPieceAt: _chessService.getPieceAt,
      movablePiecesCoordinates:
          _chessService.moves().map((e) => e.from).toList(),
      checkStatus: _chessService.checkStatus,
    ));

    G.logger.t('LocalGameViewModel.reset: Reset');
  }
}
