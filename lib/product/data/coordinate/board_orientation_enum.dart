import 'package:localchess/product/data/player_color.dart';

///
enum BoardOrientationEnum {
  /// The board is in portrait orientation
  portrait,

  /// The board is in landscape orientation
  landscapeLeftBased,
  ;

  /// Returns the angle of the piece in radians
  double pieceAngle({required PlayerColor color}) {
    switch (this) {
      case BoardOrientationEnum.portrait:
        return 0;
      case BoardOrientationEnum.landscapeLeftBased:
        return 3.1415926535 / 2 * color.when(black: -1, white: 1);
    }
  }
}
