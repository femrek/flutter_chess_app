/// Enum that represents the color of the pieces and the player. Also used to
/// represent the side of the board.
enum PlayerColor {
  /// Black pieces and player.
  black,

  /// White pieces and player.
  white,
  ;

  /// Returns the opposite color.
  PlayerColor get opposite {
    switch (this) {
      case PlayerColor.black:
        return PlayerColor.white;
      case PlayerColor.white:
        return PlayerColor.black;
    }
  }

  /// if this is [PlayerColor.black] return [black], if [PlayerColor.white]
  /// return [white]
  T when<T>({
    required T black,
    required T white,
  }) {
    switch (this) {
      case PlayerColor.black:
        return black;
      case PlayerColor.white:
        return white;
    }
  }

  /// if this is [PlayerColor.black] calls [black] and return the result, if
  /// this is [PlayerColor.white] calls [white] and return the result.
  T whenDo<T>({
    required T Function() black,
    required T Function() white,
  }) {
    switch (this) {
      case PlayerColor.black:
        return black();
      case PlayerColor.white:
        return white();
    }
  }
}
