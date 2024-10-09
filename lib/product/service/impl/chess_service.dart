import 'package:chess/chess.dart' as ch;
import 'package:gen/gen.dart';
import 'package:localchess/product/data/chess_turn/app_chess_turn_status.dart';
import 'package:localchess/product/data/coordinate/square_coordinate.dart';
import 'package:localchess/product/data/move/app_chess_move.dart';
import 'package:localchess/product/data/piece/app_piece.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/service/core/i_chess_service.dart';
import 'package:localchess/product/storage/model/game_save_storage_model.dart';

/// The service for performing chess operations. [IChessService] implementation
/// with [ch.Chess] as the chess engine.
class ChessService implements IChessService {
  /// Creates the chess service. [save] is the local game save for the current
  /// game. The service performs operations on this save.
  ChessService({
    required GameSaveStorageModel save,
    this.keepSaveUpdated = true,
  }) : _save = save {
    try {
      final currentFEN = save.gameSave.currentStateFen;
      _chess = ch.Chess.fromFEN(currentFEN);
    } on StateError catch (e) {
      G.logger.e('currentState seems to be null. Error: $e');
      _chess = ch.Chess();
    }
  }

  /// The flag to keep the save updated with the game state. If true, the save
  /// will be updated after each move, reset, undo, etc. operation.
  final bool keepSaveUpdated;

  GameSaveStorageModel _save;

  late ch.Chess _chess;

  final List<BoardStatusAndLastMove> _undoHistory = [];

  /// Updates the save with the new save. also updates the [_save] field.
  Future<void> _updateSave(GameSave newSave) async {
    if (!keepSaveUpdated) return;

    // check and update if game over status is changed.
    late final GameSave newSaveResult;
    if (_chess.game_over != newSave.isGameOver) {
      newSaveResult = newSave.copyWith(isGameOver: _chess.game_over);
    } else {
      newSaveResult = newSave;
    }

    // update the save in the cache.
    _save = G.appStorage.gameSaveOperator.update(
      GameSaveStorageModel(
        id: _save.id,
        gameSave: newSaveResult,
      ),
    );
  }

  @override
  String get currentFen => _save.gameSave.currentStateFen;

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
  SquareCoordinate? get lastMoveFrom {
    G.logger.t('ChessService.lastMoveFrom');

    final result = SquareCoordinate.fromNameOrNull(
        _save.gameSave.currentState?.lastMoveFrom);

    G.logger.t('ChessService.lastMoveFrom: $result');

    return result;
  }

  @override
  SquareCoordinate? get lastMoveTo {
    G.logger.t('ChessService.lastMoveTo');

    final result = SquareCoordinate.fromNameOrNull(
        _save.gameSave.currentState?.lastMoveTo);

    G.logger.t('ChessService.lastMoveTo: $result');

    return result;
  }

  @override
  AppChessTurnStatus get turnStatus {
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
  List<AppPiece> get capturedPieces {
    final capturedPieces = _save.gameSave.history
        .map<AppPiece?>((e) {
          final name = e.capturedPiece;
          if (name == null) return null;
          return AppPiece.fromNameCaseSensitive(name);
        })
        .whereType<AppPiece>()
        .toList();

    return capturedPieces;
  }

  @override
  Set<AppChessMove> moves({SquareCoordinate? from}) {
    G.logger.t('ChessService.moves: from: $from');

    if (_chess.game_over) {
      G.logger.t('ChessService.moves: Game is over, no moves');
      return {};
    }

    final rawMoves = _chess.generate_moves();

    final moves = <AppChessMove>{};

    for (final move in rawMoves) {
      if (from == null || move.fromAlgebraic == from.nameLowerCase) {
        moves.add(AppChessMove(
          from: SquareCoordinate.fromName(move.fromAlgebraic),
          to: SquareCoordinate.fromName(move.toAlgebraic),
          hasPromotion: move.promotion != null,
        ));
      }
    }

    G.logger.t('ChessService.moves: $moves');

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

    // get the move coordinate names.
    final from = move.from.nameLowerCase;
    final to = move.to.nameLowerCase;

    // find the captured piece if exists.
    late final String? capturedPiece;
    {
      final piece = _chess.get(to);
      if (piece != null) {
        if (piece.color == ch.Color.BLACK) {
          capturedPiece = piece.type.toLowerCase();
        } else {
          capturedPiece = piece.type.toUpperCase();
        }
      } else {
        capturedPiece = null;
      }
    }

    final moveResult = _chess.move({
      'from': from,
      'to': to,
      'promotion': promotion,
    });

    if (!moveResult) {
      throw Exception('Invalid move. move: $move, promotion: $promotion');
    }

    _undoHistory.clear();

    await _updateSave(_save.gameSave.addHistory(
      BoardStatusAndLastMove(
        fen: _chess.fen,
        lastMoveFrom: from,
        lastMoveTo: to,
        capturedPiece: capturedPiece,
      ),
    ));

    G.logger.t('ChessService.move: Moved to $move, promotion: $promotion, '
        'captured: $capturedPiece');
  }

  @override
  bool canUndo() {
    return _save.gameSave.history.isNotEmpty;
  }

  @override
  Future<void> undo() async {
    G.logger.t('ChessService.undo');

    // get history and validate
    final history = _save.gameSave.history;
    if (history.isEmpty) throw Exception('No history to undo');

    // get and validate last status
    final undoState = _save.gameSave.currentState;
    if (undoState == null) {
      G.logger.e('currentState is null when undoing and history is not empty');
      return;
    }

    // undo and save state
    final newSave = _save.gameSave.popHistory();
    _chess = ch.Chess.fromFEN(newSave.currentStateFen);
    await _updateSave(newSave);

    // add move to undo history
    _undoHistory.add(undoState);

    G.logger.t('ChessService.undo: Undone');
  }

  @override
  bool canRedo() {
    G.logger.t('ChessService.canRedo');
    final result = _undoHistory.isNotEmpty;
    G.logger.t('ChessService.canRedo: $_undoHistory');
    return result;
  }

  @override
  Future<void> redo() async {
    G.logger.t('ChessService.redo');

    if (_undoHistory.isEmpty) throw Exception('No history to redo');

    // pop redo state
    final redoState = _undoHistory.removeLast();

    // redo and save state
    final newSave = _save.gameSave.addHistory(redoState);
    _chess = ch.Chess.fromFEN(newSave.currentStateFen);
    await _updateSave(newSave);

    G.logger.t('ChessService.redo: Redone');
  }

  @override
  Future<void> reset() async {
    G.logger.t('ChessService.reset');

    // clear undo history
    _undoHistory.clear();

    // reset and save state
    final newSave = _save.gameSave.copyWith(history: []);
    _chess.load(newSave.currentStateFen);
    await _updateSave(newSave);

    G.logger.t('ChessService.reset: Reset');
  }
}
