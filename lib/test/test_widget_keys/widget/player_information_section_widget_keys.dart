// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

enum PlayerInformationSectionWidgetKeys {
  playerTurn,
  gameStatus,
  ;

  ValueKey<String> get key {
    switch (this) {
      case PlayerInformationSectionWidgetKeys.playerTurn:
        return const ValueKey<String>(
          'PlayerInformationSectionWidgetKeys.playersTurn',
        );
      case PlayerInformationSectionWidgetKeys.gameStatus:
        return const ValueKey<String>(
          'PlayerInformationSectionWidgetKeys.gameStatus',
        );
    }
  }
}
