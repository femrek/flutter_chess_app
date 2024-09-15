import 'package:chess/chess.dart' as ch;
import 'package:localchess/product/data/chess_turn/app_chess_turn_status.dart';
import 'package:localchess/product/data/coordinate/square_coordinate.dart';
import 'package:localchess/product/data/move/app_chess_move.dart';
import 'package:localchess/product/data/piece/app_piece.dart';
import 'package:localchess/product/data/player_color/player_color.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/network/model/game_network_model.dart';
import 'package:localchess/product/service/core/i_chess_service.dart';

/// An implementation of [IChessService] that is used by the guest player.
/// filters the moves based on the guest player's color.
/// Can be created by [GameNetworkModel]
class GuestChessService implements IChessService {
  /// Creates a [GuestChessService] with the given [guestColor].
  GuestChessService({
    required this.snapshot,
    required this.guestColor,
    required this.canPlay,
  }) {
    _chess = ch.Chess.fromFEN(snapshot.gameFen);
    _lastMoveFrom = SquareCoordinate.fromNameOrNull(snapshot.lastMoveFrom);
    _lastMoveTo = SquareCoordinate.fromNameOrNull(snapshot.lastMoveTo);
  }

  /// The color of the guest player.
  final PlayerColor guestColor;

  /// The snapshot of the game.
  final GameNetworkModel snapshot;

  /// Whether the guest player can play the game.
  final bool canPlay;

  late final ch.Chess _chess;
  SquareCoordinate? _lastMoveFrom;
  SquareCoordinate? _lastMoveTo;

  @override
  bool canUndo() => false;

  @override
  bool canRedo() => false;

  @override
  Future<void> undo() => throw Exception('Undo is not allowed for guest');

  @override
  Future<void> redo() => throw Exception('Redo is not allowed for guest');

  @override
  Future<void> reset() => throw Exception('Reset is not allowed for guest');

  @override
  String get currentFen => _chess.fen;

  @override
  List<AppPiece> get capturedPieces => snapshot.capturedPieces;

  @override
  SquareCoordinate? get lastMoveFrom => _lastMoveFrom;

  @override
  SquareCoordinate? get lastMoveTo => _lastMoveTo;

  @override
  AppChessTurnStatus get turnStatus => _checkStatus();

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
  Set<AppChessMove> moves({SquareCoordinate? from}) {
    G.logger.t('GuestChessService.moves: from: $from');

    if (!canPlay) {
      G.logger.t('GuestChessService.moves: Guest cannot play, no moves');
      return {};
    }

    if (_chess.game_over) {
      G.logger.t('GuestChessService.moves: Game is over, no moves');
      return {};
    }

    final rawMoves = _chess.generate_moves();

    final moves = <AppChessMove>{};

    for (final move in rawMoves) {
      // check if the move is from the given square
      if (from == null || move.fromAlgebraic == from.nameLowerCase) {
        // check if the piece is of the guest player
        final piece = getPieceAt(SquareCoordinate.fromName(move.fromAlgebraic));
        if (piece?.color == guestColor) {
          moves.add(AppChessMove(
            from: SquareCoordinate.fromName(move.fromAlgebraic),
            to: SquareCoordinate.fromName(move.toAlgebraic),
            hasPromotion: move.promotion != null,
          ));
        }
      }
    }

    G.logger.t('GuestChessService.moves: $moves');

    return moves;
  }

  @override
  Future<void> move({
    required AppChessMove move,
    String? promotion,
  }) async {
    G.logger.t('GuestChessService.move: $move, promotion: $promotion');

    assert(move.from != move.to, 'Invalid move, same square');
    assert(
      move.hasPromotion == (promotion != null),
      'Missing promotion, the move requires a promotion',
    );

    // get the move coordinate names.
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

    _lastMoveFrom = move.from;
    _lastMoveTo = move.to;

    G.logger.t('GuestChessService.move: Moved to $move, promotion: $promotion');
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
}
