import 'package:localchess/product/cache/model/local_game_save_cache_model.dart';
import 'package:localchess/product/data/app_piece.dart';
import 'package:localchess/product/data/square_coordinate.dart';

/// The service interface for performing chess operations.
abstract interface class IChessService {
  /// The local game save for performing operations on it. The instance of the
  /// game.
  LocalGameSaveCacheModel get save;

  /// Gets the piece at the given [coordinate]. Returns `null` if no piece is
  /// found at the coordinate.
  AppPiece? getPieceAt(SquareCoordinate coordinate);
}
