import 'package:flutter/material.dart';
import 'package:mychess/data/model/last_move_model.dart';

/// param lastMove: last move coord. like a1/a5
String fenAndLastMoveToBundleString(String fen, String lastMove) {
  return (fen + '#' + lastMove);
}

LastMoveModel getLastMoveFromBundleString(String bundleString) {
  final int sharpIndex = bundleString.indexOf('#');
  final int moveDividerIndex = bundleString.indexOf('/', sharpIndex);
  return LastMoveModel(
    from: bundleString.substring(sharpIndex + 1, moveDividerIndex),
    to: bundleString.substring(moveDividerIndex + 1)
  );
}

String getFenFromBundleString(String bundleString) {
  return bundleString.substring(0, bundleString.indexOf('#'));
}

const double PI = 3.1415926535;
const double ninetyDegree = PI / 2;

final Color lastMoveEffect = Colors.blue.withOpacity(0.5);