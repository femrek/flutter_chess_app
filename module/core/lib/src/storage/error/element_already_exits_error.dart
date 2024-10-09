/// Error thrown when saving an element already exists in the cache when `save`
/// or `saveAll` operations.
class ElementAlreadyExitsError extends Error {
  /// Creates a new instance of [ElementAlreadyExitsError].
  ElementAlreadyExitsError(this.message);

  /// Error message
  final String message;

  @override
  String toString() {
    return 'ElementAlreadyExitsError: $message';
  }
}
