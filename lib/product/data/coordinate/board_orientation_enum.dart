import 'package:localchess/product/data/player_color.dart';

/// Defined the orientation of the board
enum BoardOrientationEnum {
  /// The board is in portrait orientation
  portrait,

  /// The board is in portrait orientation but for black player.
  portraitUpsideDown,

  /// The board is in landscape orientation
  landscapeLeftBased,
  ;

  /// Returns the angle of the piece in radians
  int pieceRotateQuarters({required PlayerColor color}) {
    switch (this) {
      case BoardOrientationEnum.portrait:
        return 0;
      case BoardOrientationEnum.portraitUpsideDown:
        return 0;
      case BoardOrientationEnum.landscapeLeftBased:
        return color.when(black: -1, white: 1);
    }
  }

  /// Returns the value based on the orientation
  T when<T>({
    required T portrait,
    required T portraitUpsideDown,
    required T landscapeLeftBased,
  }) {
    switch (this) {
      case BoardOrientationEnum.portrait:
        return portrait;
      case BoardOrientationEnum.portraitUpsideDown:
        return portraitUpsideDown;
      case BoardOrientationEnum.landscapeLeftBased:
        return landscapeLeftBased;
    }
  }
}
