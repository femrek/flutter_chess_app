// ignore_for_file: constant_identifier_names

abstract final class TestChessFenConstants {
  static const String initialFen =
      'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';

  static const String readyToPromotionMoveFen_b7Move =
      '4k3/1P6/8/8/8/8/8/4K3 w - - 0 1';

  static const String readyToPromotionMoveFen_b7CaptureA8 =
      'r3k3/1P6/8/8/8/8/8/4K3 w - - 0 1';

  static const String blackKingIsUnderAttackFen =
      'rnbqkbnr/ppp2ppp/4Q3/3pp3/4P3/8/PPPP1PPP/RNB1KBNR b KQkq - 0 1';

  static const String checkmateFen_blackLost =
      'r1bqkbnr/p1pp1Qpp/2n5/1p2p3/2B1P3/8/PPPP1PPP/RNB1K1NR b KQkq - 0 1';

  // https://support.chess.com/en/articles/8557490-what-is-stalemate
  static const String stalemateFen = 'K7/8/8/8/8/8/5Q2/7k b - - 0 1';

  // https://www.chess.com/terms/draw-chess
  static const String preDrawFen =
      '8/1k6/3p4/p1pPp2p/P1P1P1pP/6P1/5K2/8 w - - 0 1';
}
