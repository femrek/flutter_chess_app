/// Error thrown when trying to update an element that does not exist in the
/// cache when `update` or `updateAll` operations.
class ElementDoesNotExistWhenUpdateError extends Error {
  /// Creates a new instance of [ElementDoesNotExistWhenUpdateError].
  ElementDoesNotExistWhenUpdateError(this.message);

  /// The error message.
  final String message;

  @override
  String toString() {
    return 'ElementDoesExistWhenUpdateError: $message';
  }
}
