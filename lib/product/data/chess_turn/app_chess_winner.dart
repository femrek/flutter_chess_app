/// The enum for determining the winner of the game.
enum AppChessWinner {
  /// When the winner is black.
  black(gameOver: true),

  /// When the winner is white.
  white(gameOver: true),

  /// When nobody wins.
  draw(gameOver: true),

  /// When game is still ongoing.
  none(gameOver: false),
  ;

  const AppChessWinner({required this.gameOver});

  /// Whether the game is over.
  final bool gameOver;
}
