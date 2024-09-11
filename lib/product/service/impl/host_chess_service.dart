import 'package:localchess/product/data/coordinate/square_coordinate.dart';
import 'package:localchess/product/data/move/app_chess_move.dart';
import 'package:localchess/product/data/player_color.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/service/impl/chess_service.dart';

/// Another implementation of [ChessService] that is used by the host player.
/// filters the moves based on the host player's color.
class HostChessService extends ChessService {
  /// Creates a [HostChessService] with the given [hostColor].
  HostChessService({
    required super.save,
    required this.hostColor,
  });

  /// The color of the host player.
  final PlayerColor hostColor;

  @override
  Set<AppChessMove> moves({
    SquareCoordinate? from,
  }) {
    G.logger.t('HostChessService.moves: from: $from');

    final allMoves = super.moves(from: from);
    final moves = allMoves.where((e) {
      return getPieceAt(e.from)?.color == hostColor;
    }).toSet();

    G.logger.t('HostChessService.moves: $moves');
    return moves;
  }
}
