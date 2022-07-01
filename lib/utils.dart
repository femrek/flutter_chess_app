import 'package:flutter/material.dart';
import 'package:localchess/data/model/last_move_model.dart';

/// param fen: board state in fen format.
/// param lastMove: last move coordinate. Like "a1/a5".
/// return: bundle string like "fen#a1/a5". Bundle string is the data type sent
/// from the host to the client.
String fenAndLastMoveToBundleString(String fen, String lastMove) {
  return (fen + '#' + lastMove);
}

/// param bundleString: Bundle string is the data type sent
/// from the host to the client. Like "fen#a1/a5".
/// return: last move in the bundleString as lastMoveModel object.
LastMoveModel getLastMoveFromBundleString(String bundleString) {
  final int sharpIndex = bundleString.indexOf('#');
  final int moveDividerIndex = bundleString.indexOf('/', sharpIndex);
  return LastMoveModel(
    from: bundleString.substring(sharpIndex + 1, moveDividerIndex),
    to: bundleString.substring(moveDividerIndex + 1)
  );
}

/// param bundleString: Bundle string is the data type sent
/// from the host to the client. Like "fen#a1/a5".
/// return: board state in fen format in the bundleString.
String getFenFromBundleString(String bundleString) {
  return bundleString.substring(0, bundleString.indexOf('#'));
}

const Map<String, String> pieceCodeToAssetName = {
  'p': 'pawn',
  'q': 'queen',
  'r': 'rok',
  'b': 'bishop',
  'n': 'knight',
  'k': 'king',
};


class GlowsRemovedBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }

  static final GlowsRemovedBehavior _instance = GlowsRemovedBehavior._internal();
  GlowsRemovedBehavior._internal();
  factory GlowsRemovedBehavior() => _instance;
}

const double PI = 3.1415926535;
const double ninetyDegree = PI / 2;
