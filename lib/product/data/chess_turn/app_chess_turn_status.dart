import 'package:localchess/product/data/chess_turn/app_chess_winner.dart';
import 'package:localchess/product/data/piece/app_piece.dart';
import 'package:localchess/product/data/player_color/player_color.dart';

/// AppCheckmateStatus enum
enum AppChessTurnStatus {
  /// When the game is still ongoing. back turn.
  black(
    winnerEnum: AppChessWinner.none,
    turn: PlayerColor.black,
  ),

  /// When the game is still ongoing. white turn.
  white(
    winnerEnum: AppChessWinner.none,
    turn: PlayerColor.white,
  ),

  /// When black king is in check.
  blackKingCheck(
    winnerEnum: AppChessWinner.none,
    turn: PlayerColor.black,
  ),

  /// When white king is in check.
  whiteKingCheck(
    winnerEnum: AppChessWinner.none,
    turn: PlayerColor.white,
  ),

  /// When black king is checkmated.
  blackKingCheckmate(
    winnerEnum: AppChessWinner.white,
  ),

  /// When white king is checkmated.
  whiteKingCheckmate(
    winnerEnum: AppChessWinner.black,
  ),

  /// When the game is drawn.
  draw(
    winnerEnum: AppChessWinner.draw,
  ),

  /// When the game is stalemated.
  stalemate(
    winnerEnum: AppChessWinner.draw,
  ),
  ;

  const AppChessTurnStatus({
    required this.winnerEnum,
    this.turn,
  });

  /// The winner of the game.
  final AppChessWinner winnerEnum;

  /// Whether the turn is dark.
  final PlayerColor? turn;

  /// Whether the [piece] is in check.
  bool isCheckOn(AppPiece piece) {
    if (piece == AppPiece.kingB) {
      return this == AppChessTurnStatus.blackKingCheck;
    } else if (piece == AppPiece.kingW) {
      return this == AppChessTurnStatus.whiteKingCheck;
    }
    return false;
  }

  /// Whether the game is over.
  bool get isGameOver => winnerEnum.gameOver;
}
