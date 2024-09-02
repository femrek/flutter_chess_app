/// Enum for the type of paint to be used for the foreground of a square.
enum SquareForegroundPaintType {
  /// Paint the square with a specific color to indicate that the piece is
  /// focused.
  focusedPiece,

  /// Paint the square with a specific color to indicate that the piece can be
  /// captured.
  capturePiece,

  /// Paint the square with a specific color to indicate that the piece can be
  /// moved to this square.
  movableToThis,

  /// Paint the square with a specific color to indicate that the piece is
  /// marked as the king in check.
  checkPiece,
}
