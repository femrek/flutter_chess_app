import 'package:localchess/feature/local_game/view_model/local_game_state.dart';
import 'package:localchess/product/cache/model/game_save_cache_model.dart';
import 'package:localchess/product/data/coordinate/square_coordinate.dart';
import 'package:localchess/product/data/move/app_chess_move.dart';
import 'package:localchess/product/data/square_data.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/service/core/i_chess_service.dart';
import 'package:localchess/product/service/impl/chess_service.dart';
import 'package:localchess/product/state/base/base_cubit.dart';

/// The view model for the local game screen
class LocalGameViewModel extends BaseCubit<LocalGameState> {
  /// The view model for the local game screen
  LocalGameViewModel() : super(const LocalGameInitialState());

  late IChessService _chessService;

  final _squareStates = <SquareCoordinate, SquareData>{
    for (var e in SquareCoordinate.boardSquares)
      e: const SquareData.withDefaultValues(),
  };

  void _emitNormal() {
    G.logger.t('LocalGameViewModel._emitStateCompletely');

    final movablePiecesCoordinates =
        _chessService.moves().map((e) => e.from).toList();
    final turnStatus = _chessService.turnStatus;

    for (final coordinate in _squareStates.keys) {
      final piece = _chessService.getPieceAt(coordinate);

      _squareStates[coordinate] = SquareData(
        piece: piece,
        canMove: movablePiecesCoordinates.contains(coordinate),
        isThisCheck: piece != null && turnStatus.isCheckOn(piece),
        isLastMoveFromThis: coordinate == _chessService.lastMoveFrom,
        isLastMoveToThis: coordinate == _chessService.lastMoveTo,
        isFocusedOnThis: false,
        isSyncInProcess: false,
      );
    }

    final capturedPieces = _chessService.capturedPieces;

    emit(LocalGameLoadedState(
      squareStates: _squareStates,
      isFocused: false,
      turnStatus: turnStatus,
      capturedPieces: capturedPieces,
      canUndo: _chessService.canUndo(),
      canRedo: _chessService.canRedo(),
    ));

    G.logger.t('LocalGameViewModel._emitStateCompletely: Completely emitted');
  }

  void _emitFocus(SquareCoordinate focusedCoordinate) {
    G.logger.t('LocalGameViewModel._emitStateWhenFocus: $focusedCoordinate');

    final turnStatus = _chessService.turnStatus;
    {
      final piece = _chessService.getPieceAt(focusedCoordinate);
      _squareStates[focusedCoordinate] = SquareData(
        piece: piece,
        canMove: false,
        isThisCheck: piece != null && turnStatus.isCheckOn(piece),
        isLastMoveFromThis: false,
        isLastMoveToThis: false,
        isFocusedOnThis: true,
        isSyncInProcess: false,
      );
    }

    for (final move in _chessService.moves(from: focusedCoordinate)) {
      final piece = _chessService.getPieceAt(move.to);

      _squareStates[move.to] = SquareData(
        piece: _chessService.getPieceAt(move.to),
        canMove: false,
        isThisCheck: false,
        isLastMoveFromThis: _chessService.lastMoveFrom == move.to,
        isLastMoveToThis: _chessService.lastMoveTo == move.to,
        isFocusedOnThis: false,
        isSyncInProcess: false,
        moveToThis: piece == null ? move : null,
        captureToThis: piece != null ? move : null,
      );
    }

    emit(LocalGameLoadedState(
      squareStates: _squareStates,
      isFocused: true,
      turnStatus: turnStatus,
      capturedPieces: (state as LocalGameLoadedState).capturedPieces,
      canUndo: _chessService.canUndo(),
      canRedo: _chessService.canRedo(),
    ));

    G.logger.t('LocalGameViewModel._emitStateWhenFocus:'
        ' Focused on $focusedCoordinate');
  }

  /// Initializes the view model
  Future<void> init(GameSaveCacheModel save) async {
    G.logger.t('LocalGameViewModel.init: $save');

    _chessService = ChessService(save: save);

    // emit
    _emitNormal();

    G.logger.t('LocalGameViewModel.init: Initialized');
  }

  /// Focuses on the piece at the given [coordinate]. Shows the possible moves
  /// for the piece.
  void focus(SquareCoordinate coordinate) {
    G.logger.t('LocalGameViewModel.focus: $coordinate');

    final state = this.state;
    if (state is! LocalGameLoadedState) throw Exception('Invalid state');

    final squareState = state.squareStates[coordinate];

    // check if the square could not be found.
    if (squareState == null) {
      throw Exception(
        'Invalid move. No square state found for $coordinate',
      );
    }

    // check if the coordinate is contained in movablePiecesCoordinates.
    if (!squareState.canMove) {
      throw Exception(
        'Invalid coordinate when focusing. focus coordinate must be able to '
        'move',
      );
    }

    // emit
    _emitFocus(coordinate);

    G.logger.t('LocalGameViewModel.focus: Focused on $coordinate.');
  }

  /// Removes the focus from the focused piece.
  void removeFocus() {
    G.logger.t('LocalGameViewModel.removeFocus');

    final state = this.state;
    if (state is! LocalGameLoadedState) throw Exception('Invalid state');

    // emit
    _emitNormal();

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

    // perform the move.
    await _chessService.move(move: move, promotion: promotion);

    // emit
    _emitNormal();

    G.logger.t('LocalGameViewModel.move: Moved $move');
  }

  /// Undoes the last move.
  Future<void> undo() async {
    G.logger.t('LocalGameViewModel.undo');

    final state = this.state;
    if (state is! LocalGameLoadedState) throw Exception('Invalid state');

    if (!_chessService.canUndo()) return;

    // perform the undo.
    await _chessService.undo();

    // emit
    _emitNormal();

    G.logger.t('LocalGameViewModel.undo: Undone');
  }

  /// Redoes the last undone move.
  Future<void> redo() async {
    G.logger.t('LocalGameViewModel.redo');

    final state = this.state;
    if (state is! LocalGameLoadedState) throw Exception('Invalid state');

    if (!_chessService.canRedo()) return;

    // perform the redo.
    await _chessService.redo();

    // emit
    _emitNormal();

    G.logger.t('LocalGameViewModel.redo: Redone');
  }

  /// Resets the game.
  Future<void> reset() async {
    G.logger.t('LocalGameViewModel.reset');

    final state = this.state;
    if (state is! LocalGameLoadedState) throw Exception('Invalid state');

    // perform the reset.
    await _chessService.reset();

    // emit
    _emitNormal();

    G.logger.t('LocalGameViewModel.reset: Reset');
  }
}
