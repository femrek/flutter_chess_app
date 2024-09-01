import 'package:localchess/product/cache/model/local_game_save_cache_model.dart';
import 'package:localchess/product/data/app_piece.dart';
import 'package:localchess/product/data/chess_turn/app_chess_turn_status.dart';
import 'package:localchess/product/data/move/app_chess_move.dart';
import 'package:localchess/product/data/square_coordinate.dart';

/// The service interface for performing chess operations.
abstract interface class IChessService {
  /// The local game save for performing operations on it. The instance of the
  /// game.
  LocalGameSaveCacheModel get save;

  /// Gets the piece at the given [coordinate]. Returns `null` if no piece is
  /// found at the coordinate.
  AppPiece? getPieceAt(SquareCoordinate coordinate);

  /// Gets the current check status of the game.
  AppChessTurnStatus get checkStatus;

  /// Gets the list of moves that can be made by the piece at the given [from]
  /// coordinate. If [from] is `null`, returns the list of all possible moves.
  /// The list is empty if no moves are possible.
  Set<AppChessMove> moves({SquareCoordinate? from});

  /// Moves the piece according to the given [move]. If the move is a promotion
  /// move, the [promotion] parameter should be provided. Otherwise, it should
  /// be `null`. The promotion string must be one of 'q', 'r', 'b', or 'n'.
  Future<void> move({
    required AppChessMove move,
    String? promotion,
  });

  /// Checks if there is a move that can be undone.
  bool canUndo();

  /// Undoes the last move made.
  Future<void> undo();

  /// Checks if there is a move that can be redone.
  bool canRedo();

  /// Redoes the last undone move.
  Future<void> redo();

  /// Restart the game.
  Future<void> reset();
}
