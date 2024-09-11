import 'package:localchess/feature/host_game/view_model/host_game_state.dart';
import 'package:localchess/product/cache/model/game_save_cache_model.dart';
import 'package:localchess/product/data/coordinate/square_coordinate.dart';
import 'package:localchess/product/data/move/app_chess_move.dart';
import 'package:localchess/product/data/player_color.dart';
import 'package:localchess/product/data/square_data.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/service/core/i_chess_service.dart';
import 'package:localchess/product/service/impl/host_chess_service.dart';
import 'package:localchess/product/state/base/base_cubit.dart';

/// The view model for the host game screen
class HostGameViewModel extends BaseCubit<HostGameState> {
  /// Create the instance of [HostGameViewModel]
  HostGameViewModel() : super(const HostGameInitialState());

  final _squareStates = <SquareCoordinate, SquareData>{
    for (var e in SquareCoordinate.boardSquares)
      e: const SquareData.withDefaultValues(),
  };

  late IChessService _chessService;

  void _emitNormal() {
    G.logger.t('HostGameViewModel._emitState');

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

    emit(HostGameLoadedState(
      squareStates: _squareStates,
      isFocused: false,
      turnStatus: turnStatus,
      capturedPieces: capturedPieces,
      canUndo: _chessService.canUndo(),
      canRedo: _chessService.canRedo(),
    ));

    G.logger.t('HostGameViewModel._emitState: Completely emitted');
  }

  void _emitFocus(SquareCoordinate focusedCoordinate) {
    G.logger.t('HostGameViewModel._emitFocus: $focusedCoordinate');

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

    emit(HostGameLoadedState(
      squareStates: _squareStates,
      isFocused: true,
      turnStatus: turnStatus,
      capturedPieces: (state as HostGameLoadedState).capturedPieces,
      canUndo: _chessService.canUndo(),
      canRedo: _chessService.canRedo(),
    ));

    G.logger.t('HostGameViewModel._emitFocus: Focused on $focusedCoordinate');
  }

  /// Load the game state with the given [save] and [color]
  Future<void> init(GameSaveCacheModel save, PlayerColor color) async {
    _chessService = HostChessService(save: save, hostColor: color);
    _emitNormal();
  }

  /// Focuses on the piece at the given [coordinate]. Shows the possible moves
  /// for the piece.
  void focus(SquareCoordinate coordinate) {
    G.logger.t('HostGameViewModel.focus: $coordinate');

    final state = this.state;
    if (state is! HostGameLoadedState) throw Exception('Invalid state');

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

    G.logger.t('HostGameViewModel.focus: Focused on $coordinate.');
  }

  /// Removes the focus from the focused piece.
  void removeFocus() {
    G.logger.t('HostGameViewModel.removeFocus');

    final state = this.state;
    if (state is! HostGameLoadedState) throw Exception('Invalid state');

    // emit
    _emitNormal();

    G.logger.t('HostGameViewModel.removeFocus: Removed focus');
  }

  /// Perform move according to [move]. if move has promotion [promotion] must
  /// not be null.
  Future<void> move({
    required AppChessMove move,
    String? promotion,
  }) async {
    G.logger.t('HostGameViewModel.move: $move, promotion: $promotion');

    final state = this.state;
    if (state is! HostGameLoadedState) throw Exception('Invalid state');

    // perform the move.
    await _chessService.move(move: move, promotion: promotion);

    // emit
    _emitNormal();

    G.logger.t('HostGameViewModel.move: Moved $move');
  }

  /// Undoes the last move.
  Future<void> undo() async {
    G.logger.t('HostGameViewModel.undo');

    final state = this.state;
    if (state is! HostGameLoadedState) throw Exception('Invalid state');

    if (!_chessService.canUndo()) return;

    // perform the undo.
    await _chessService.undo();

    // emit
    _emitNormal();

    G.logger.t('HostGameViewModel.undo: Undone');
  }

  /// Redoes the last undone move.
  Future<void> redo() async {
    G.logger.t('HostGameViewModel.redo');

    final state = this.state;
    if (state is! HostGameLoadedState) throw Exception('Invalid state');

    if (!_chessService.canRedo()) return;

    // perform the redo.
    await _chessService.redo();

    // emit
    _emitNormal();

    G.logger.t('HostGameViewModel.redo: Redone');
  }

  /// Resets the game.
  Future<void> reset() async {
    G.logger.t('HostGameViewModel.reset');

    final state = this.state;
    if (state is! HostGameLoadedState) throw Exception('Invalid state');

    // perform the reset.
    await _chessService.reset();

    // emit
    _emitNormal();

    G.logger.t('HostGameViewModel.reset: Reset');
  }
}
