import 'package:chess/chess.dart' as ch;
import 'package:localchess/product/cache/model/local_game_save_cache_model.dart';
import 'package:localchess/product/data/app_piece.dart';
import 'package:localchess/product/data/square_coordinate.dart';
import 'package:localchess/product/service/core/i_chess_service.dart';

/// The service for performing chess operations. [IChessService] implementation
/// with [ch.Chess] as the chess engine.
class ChessService implements IChessService {
  /// Creates the chess service. [save] is the local game save for the current
  /// game. The service performs operations on this save.
  ChessService({
    required this.save,
  }) {
    final currentFEN = save.localGameSave.currentState;
    if (currentFEN == null) {
      _chess = ch.Chess();
      return;
    }
    _chess = ch.Chess.fromFEN(currentFEN);
  }

  @override
  final LocalGameSaveCacheModel save;

  late final ch.Chess _chess;

  @override
  AppPiece? getPieceAt(SquareCoordinate coordinate) {
    final piece = _chess.get(coordinate.nameLowerCase);

    if (piece == null) return null;

    return AppPiece.fromName(
      name: piece.type.name,
      isDark: piece.color == ch.Color.BLACK,
    );
  }
}
