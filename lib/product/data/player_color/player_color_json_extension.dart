import 'package:localchess/product/data/player_color/player_color.dart';

/// A JSON extension for [PlayerColor]
extension PlayerColorJsonExtensionToJson on PlayerColor {
  /// Converts the [PlayerColor] to a [String].
  String get toJson {
    switch (this) {
      case PlayerColor.white:
        return 'white';
      case PlayerColor.black:
        return 'black';
    }
  }
}

/// A JSON parse extension for [PlayerColor]
extension PlayerColorJsonExtensionFromJson on String {
  /// Converts the [String] to a [PlayerColor].
  PlayerColor get toPlayerColor {
    switch (this) {
      case 'white':
        return PlayerColor.white;
      case 'black':
        return PlayerColor.black;
      default:
        throw Exception('Unknown PlayerColor: $this');
    }
  }

  /// Returns `true` if the [String] can be parsed to a [PlayerColor].
  bool get canParseToPlayerColor {
    switch (this) {
      case 'white':
      case 'black':
        return true;
      default:
        return false;
    }
  }
}
