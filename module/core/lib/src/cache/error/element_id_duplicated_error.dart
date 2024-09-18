/// Error type for when an element id is duplicated on `saveAll` or `updateAll`
/// operations.
class ElementIdDuplicatedError extends Error {
  /// Creates a new instance of [ElementIdDuplicatedError].
  ElementIdDuplicatedError(this.message);

  /// The error message.
  final String message;

  @override
  String toString() {
    return 'ElementIdDuplicatedError: $message';
  }
}
