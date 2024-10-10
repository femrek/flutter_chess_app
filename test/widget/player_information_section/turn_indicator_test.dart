import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localchess/product/data/chess_turn/app_chess_turn_status.dart';
import 'package:localchess/product/data/player_color/player_color.dart';
import 'package:localchess/product/localization/locale_keys.g.dart';
import 'package:localchess/product/widget/player_information_section/turn_indicator.dart';
import 'package:localchess/test/test_widget_keys/widget/player_information_section_widget_keys.dart';

void main() async {
  group('Turn Indicator is created successfully', () {
    const <(AppChessTurnStatus status, PlayerColor side),
        (String? turnIndicatorText, String? gameStatusText)>{
      // white turn
      (AppChessTurnStatus.white, PlayerColor.white): (
        LocaleKeys.game_chessTurn_yourTurn,
        null,
      ),
      (AppChessTurnStatus.white, PlayerColor.black): (
        LocaleKeys.game_chessTurn_opponentTurn,
        null,
      ),

      // black turn
      (AppChessTurnStatus.black, PlayerColor.white): (
        LocaleKeys.game_chessTurn_opponentTurn,
        null,
      ),
      (AppChessTurnStatus.black, PlayerColor.black): (
        LocaleKeys.game_chessTurn_yourTurn,
        null,
      ),

      // white king check
      (AppChessTurnStatus.whiteKingCheck, PlayerColor.white): (
        LocaleKeys.game_chessTurn_yourTurn,
        LocaleKeys.game_chessTurn_whiteKingCheck,
      ),
      (AppChessTurnStatus.whiteKingCheck, PlayerColor.black): (
        LocaleKeys.game_chessTurn_opponentTurn,
        null,
      ),

      // black king check
      (AppChessTurnStatus.blackKingCheck, PlayerColor.white): (
        LocaleKeys.game_chessTurn_opponentTurn,
        null,
      ),
      (AppChessTurnStatus.blackKingCheck, PlayerColor.black): (
        LocaleKeys.game_chessTurn_yourTurn,
        LocaleKeys.game_chessTurn_blackKingCheck,
      ),

      // white king checkmate
      (AppChessTurnStatus.whiteKingCheckmate, PlayerColor.white): (
        null,
        LocaleKeys.game_chessTurn_whiteKingCheckmate,
      ),
      (AppChessTurnStatus.whiteKingCheckmate, PlayerColor.black): (
        null,
        LocaleKeys.game_chessTurn_whiteKingCheckmate,
      ),

      // black king checkmate
      (AppChessTurnStatus.blackKingCheckmate, PlayerColor.white): (
        null,
        LocaleKeys.game_chessTurn_blackKingCheckmate,
      ),
      (AppChessTurnStatus.blackKingCheckmate, PlayerColor.black): (
        null,
        LocaleKeys.game_chessTurn_blackKingCheckmate,
      ),

      // draw
      (AppChessTurnStatus.draw, PlayerColor.white): (
        null,
        LocaleKeys.game_chessTurn_draw,
      ),
      (AppChessTurnStatus.draw, PlayerColor.black): (
        null,
        LocaleKeys.game_chessTurn_draw,
      ),

      // stalemate
      (AppChessTurnStatus.stalemate, PlayerColor.white): (
        null,
        LocaleKeys.game_chessTurn_stalemate,
      ),
      (AppChessTurnStatus.stalemate, PlayerColor.black): (
        null,
        LocaleKeys.game_chessTurn_stalemate,
      ),
    }.forEach((input, expectations) {
      final iStatus = input.$1;
      final iSide = input.$2;

      final eTurnIndicatorText = expectations.$1;
      final eGameStatusText = expectations.$2;

      testWidgets('$input => $expectations', (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: TurnIndicator(
            status: iStatus,
            side: iSide,
            textColor: Colors.transparent,
          ),
        ));

        if (eTurnIndicatorText != null) {
          expect(
            find.byKey(PlayerInformationSectionWidgetKeys.playerTurn.key),
            findsOneWidget,
          );
          expect(
            find.text(eTurnIndicatorText),
            findsOneWidget,
          );
        } else {
          expect(
            find.byKey(PlayerInformationSectionWidgetKeys.playerTurn.key),
            findsNothing,
          );
        }

        if (eGameStatusText != null) {
          expect(
            find.byKey(PlayerInformationSectionWidgetKeys.gameStatus.key),
            findsOneWidget,
          );
          expect(
            find.text(eGameStatusText),
            findsOneWidget,
          );
        } else {
          expect(
            find.byKey(PlayerInformationSectionWidgetKeys.gameStatus.key),
            findsNothing,
          );
        }
      });
    });
  });
}
