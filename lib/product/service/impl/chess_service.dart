import 'package:chess/chess.dart' as ch;
import 'package:localchess/product/cache/model/local_game_save_cache_model.dart';
import 'package:localchess/product/data/chess_turn/app_chess_turn_status.dart';
import 'package:localchess/product/data/coordinate/square_coordinate.dart';
import 'package:localchess/product/data/move/app_chess_move.dart';
import 'package:localchess/product/data/piece/app_piece.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/service/core/i_chess_service.dart';

/// The service for performing chess operations. [IChessService] implementation
/// with [ch.Chess] as the chess engine.
class ChessService implements IChessService {
  /// Creates the chess service. [save] is the local game save for the current
  /// game. The service performs operations on this save.
  ChessService({
    required LocalGameSaveCacheModel save,
  }) : _save = save {
    try {
      final currentFEN = save.localGameSave.currentState;
      _chess = ch.Chess.fromFEN(currentFEN);
    } on StateError catch (e) {
      G.logger.e('currentState seems to be null. Error: $e');
      _chess = ch.Chess();
    }
  }

  @override
  LocalGameSaveCacheModel get save => _save;

  LocalGameSaveCacheModel _save;

  late ch.Chess _chess;

  final List<String> _undoHistory = [];

  /// Updates the save with the new save. also updates the [_save] field.
  Future<void> _updateSave(LocalGameSaveCacheModel newSave) async {
    _save = await G.appCache.localGameSaveOperator.update(
      LocalGameSaveCacheModel(
        localGameSave: newSave.localGameSave,
      ),
    );
  }

  @override
  AppPiece? getPieceAt(SquareCoordinate coordinate) {
    final piece = _chess.get(coordinate.nameLowerCase);

    if (piece == null) return null;

    return AppPiece.fromName(
      name: piece.type.name,
      isDark: piece.color == ch.Color.BLACK,
    );
  }

  @override
  AppChessTurnStatus get checkStatus {
    G.logger.t('ChessService.checkStatus');
    final status = _checkStatus();
    G.logger.t('ChessService.checkStatus: $status');

    return status;
  }

  AppChessTurnStatus _checkStatus() {
    if (_chess.game_over) {
      // checkmate
      if (_chess.in_checkmate) {
        if (_chess.turn == ch.Color.BLACK) {
          return AppChessTurnStatus.blackKingCheckmate;
        }
        return AppChessTurnStatus.whiteKingCheckmate;
      }

      // stalemate
      if (_chess.in_stalemate) {
        return AppChessTurnStatus.stalemate;
      }

      // draw
      if (_chess.in_draw) {
        return AppChessTurnStatus.draw;
      }
    }

    // check
    if (_chess.in_check) {
      if (_chess.turn == ch.Color.BLACK) {
        return AppChessTurnStatus.blackKingCheck;
      }
      return AppChessTurnStatus.whiteKingCheck;
    }

    // ongoing
    if (_chess.turn == ch.Color.BLACK) {
      return AppChessTurnStatus.black;
    }
    return AppChessTurnStatus.white;
  }

  @override
  Set<AppChessMove> moves({SquareCoordinate? from}) {
    final rawMoves = _chess.generate_moves();

    final moves = <AppChessMove>{};

    for (final move in rawMoves) {
      moves.add(AppChessMove(
        from: SquareCoordinate.fromName(move.fromAlgebraic),
        to: SquareCoordinate.fromName(move.toAlgebraic),
        hasPromotion: move.promotion != null,
      ));
    }

    return moves;
  }

  @override
  Future<void> move({
    required AppChessMove move,
    String? promotion,
  }) async {
    G.logger.t('ChessService.move: $move, promotion: $promotion');

    assert(move.from != move.to, 'Invalid move, same square');
    assert(
      move.hasPromotion == (promotion != null),
      'Missing promotion, the move requires a promotion',
    );

    final from = move.from.nameLowerCase;
    final to = move.to.nameLowerCase;

    final moveResult = _chess.move({
      'from': from,
      'to': to,
      'promotion': promotion,
    });

    if (!moveResult) {
      throw Exception('Invalid move. move: $move, promotion: $promotion');
    }

    _undoHistory.clear();

    await _updateSave(LocalGameSaveCacheModel(
      localGameSave: save.localGameSave.addHistory(_chess.fen),
    ));

    G.logger.t('ChessService.move: Moved to $move');
  }

  @override
  bool canUndo() {
    return save.localGameSave.history.length > 1;
  }

  @override
  Future<void> undo() async {
    G.logger.t('ChessService.undo');

    final history = save.localGameSave.history;
    if (history.isEmpty) {
      G.logger.w('No history to undo');
      return;
    }
    if (history.length < 2) {
      G.logger.w('Cannot undo the initial state');
      return;
    }

    final undoState = _chess.fen;
    await _updateSave(LocalGameSaveCacheModel(
      localGameSave: save.localGameSave.popHistory(),
    ));
    _undoHistory.add(undoState);

    _chess = ch.Chess.fromFEN(save.localGameSave.currentState);

    G.logger.t('ChessService.undo: Undone');
  }

  @override
  bool canRedo() {
    return _undoHistory.isNotEmpty;
  }

  @override
  Future<void> redo() async {
    G.logger.t('ChessService.redo');

    if (_undoHistory.isEmpty) {
      G.logger.w('No history to redo');
      return;
    }

    final redoState = _undoHistory.removeLast();
    await _updateSave(LocalGameSaveCacheModel(
      localGameSave: save.localGameSave.addHistory(redoState),
    ));
    _chess = ch.Chess.fromFEN(save.localGameSave.currentState);

    G.logger.t('ChessService.redo: Redone');
  }

  @override
  Future<void> reset() async {
    G.logger.t('ChessService.reset');

    _undoHistory.clear();

    await _updateSave(LocalGameSaveCacheModel(
      localGameSave: save.localGameSave.copyWith(
        history: [ch.Chess.DEFAULT_POSITION],
      ),
    ));

    _chess.load(save.localGameSave.currentState);

    G.logger.t('ChessService.reset: Reset');
  }
}
