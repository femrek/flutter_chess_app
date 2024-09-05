import 'package:localchess/product/data/player_color.dart';

///
enum BoardOrientationEnum {
  /// The board is in portrait orientation
  portrait,

  /// The board is in landscape orientation
  landscapeLeftBased,
  ;

  /// Returns the angle of the piece in radians
  int pieceRotateQuarters({required PlayerColor color}) {
    switch (this) {
      case BoardOrientationEnum.portrait:
        return 0;
      case BoardOrientationEnum.landscapeLeftBased:
        return color.when(black: -1, white: 1);
    }
  }
}
