import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:localchess/product/constant/radius/app_radius_constant.dart';
import 'package:localchess/product/data/chess_turn/app_chess_turn_status.dart';
import 'package:localchess/product/data/chess_turn/app_chess_winner.dart';
import 'package:localchess/product/data/chess_turn/chess_turn_localization.dart';
import 'package:localchess/product/data/player_color.dart';
import 'package:localchess/product/localization/locale_keys.g.dart';

/// A widget that displays the current turn status.
class TurnIndicator extends StatelessWidget {
  /// Creates a [TurnIndicator] widget
  const TurnIndicator({
    required this.status,
    required this.side,
    required this.textColor,
    super.key,
  });

  /// The current turn status of the game
  final AppChessTurnStatus status;

  /// The side of the player to see the status
  final PlayerColor side;

  /// Color of texts if the text has no background color. (or background color
  /// is `transparent`)
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final turnColor = status.turn;

    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          // Show the player's turn
          _PlayersTurn(
            height: 48,
            textColor: textColor,
            turnColor: turnColor,
            side: side,
          ),

          const SizedBox(height: 8),

          // Show the game status
          _GameStatus(
            height: 48,
            textColor: textColor,
            status: status,
            turn: turnColor == side || turnColor == null,
          )
        ],
      ),
    );
  }
}

class _PlayersTurn extends StatelessWidget {
  const _PlayersTurn({
    required this.height,
    required this.textColor,
    required this.side,
    this.turnColor,
  });

  final double height;
  final Color textColor;
  final PlayerColor side;
  final PlayerColor? turnColor;

  @override
  Widget build(BuildContext context) {
    if (turnColor != null) {
      final isPlayersTurn = turnColor == side;
      final text = isPlayersTurn
          ? LocaleKeys.game_chessTurn_yourTurn.tr()
          : LocaleKeys.game_chessTurn_opponentTurn.tr();
      return Tooltip(
        message: text,
        child: Container(
          height: height,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: isPlayersTurn
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.onSurface,
              width: isPlayersTurn ? 2 : 0,
            ),
            color: isPlayersTurn
                ? Theme.of(context).colorScheme.secondary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(
                AppRadiusConstant.turnIndicatorBoxCornerRadius),
          ),
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isPlayersTurn
                      ? Theme.of(context).colorScheme.onSecondary
                      : textColor,
                ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

class _GameStatus extends StatelessWidget {
  const _GameStatus({
    required this.height,
    required this.textColor,
    required this.status,
    required this.turn,
  });

  final double height;
  final Color textColor;
  final AppChessTurnStatus status;
  final bool turn;

  static final _colorDraw = Colors.orange.shade700;
  static final _colorEnd = Colors.red.shade900;

  @override
  Widget build(BuildContext context) {
    if (_show) {
      return Tooltip(
        message: status.localized,
        child: Container(
          height: height,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: _borderColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(
                AppRadiusConstant.turnIndicatorBoxCornerRadius),
            color: _fillColor,
          ),
          child: Text(
            status.localized,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: _fillColor == Colors.transparent
                    ? textColor
                    : Colors.white),
          ),
        ),
      );
    }

    return SizedBox(height: height);
  }

  Color get _fillColor {
    switch (status.winnerEnum) {
      case AppChessWinner.black:
      case AppChessWinner.white:
        return _colorEnd;

      case AppChessWinner.draw:
        return _colorDraw;

      case AppChessWinner.none:
        return Colors.transparent;
    }
  }

  Color get _borderColor {
    switch (status) {
      case AppChessTurnStatus.white:
      case AppChessTurnStatus.black:
        return Colors.transparent;

      case AppChessTurnStatus.blackKingCheck:
      case AppChessTurnStatus.whiteKingCheck:
      case AppChessTurnStatus.blackKingCheckmate:
      case AppChessTurnStatus.whiteKingCheckmate:
        return _colorEnd;

      case AppChessTurnStatus.draw:
      case AppChessTurnStatus.stalemate:
        return _colorDraw;
    }
  }

  bool get _show {
    switch (status) {
      case AppChessTurnStatus.white:
      case AppChessTurnStatus.black:
        return false;

      case AppChessTurnStatus.blackKingCheck:
      case AppChessTurnStatus.whiteKingCheck:
      case AppChessTurnStatus.blackKingCheckmate:
      case AppChessTurnStatus.whiteKingCheckmate:
      case AppChessTurnStatus.draw:
      case AppChessTurnStatus.stalemate:
        return turn;
    }
  }
}
