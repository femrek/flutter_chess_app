import 'package:easy_localization/easy_localization.dart';
import 'package:localchess/product/data/chess_turn/app_chess_turn_status.dart';
import 'package:localchess/product/localization/locale_keys.g.dart';

/// extension for [AppChessTurnStatus] to generate localized text for the status
/// of the chess turn.
extension ChessTurnLocalization on AppChessTurnStatus {
  /// Returns the localized text for the chess turn status.
  String get localized {
    switch (this) {
      case AppChessTurnStatus.white:
        return LocaleKeys.game_chessTurn_white.tr();
      case AppChessTurnStatus.black:
        return LocaleKeys.game_chessTurn_black.tr();
      case AppChessTurnStatus.blackKingCheck:
        return LocaleKeys.game_chessTurn_blackKingCheck.tr();
      case AppChessTurnStatus.whiteKingCheck:
        return LocaleKeys.game_chessTurn_whiteKingCheck.tr();
      case AppChessTurnStatus.blackKingCheckmate:
        return LocaleKeys.game_chessTurn_blackKingCheckmate.tr();
      case AppChessTurnStatus.whiteKingCheckmate:
        return LocaleKeys.game_chessTurn_whiteKingCheckmate.tr();
      case AppChessTurnStatus.draw:
        return LocaleKeys.game_chessTurn_draw.tr();
      case AppChessTurnStatus.stalemate:
        return LocaleKeys.game_chessTurn_stalemate.tr();
    }
  }
}
