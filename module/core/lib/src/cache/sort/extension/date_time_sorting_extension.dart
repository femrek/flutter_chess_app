extension DateTimeSortingExtension on DateTime {
  /// Compares two [DateTime] objects. returns -1 if this [DateTime] is before
  /// the other [DateTime], 1 if this [DateTime] is after the other [DateTime],
  /// and 0 if they are equal.
  int compare(DateTime other) {
    if (isBefore(other)) {
      return -1;
    } else if (isAfter(other)) {
      return 1;
    } else {
      return 0;
    }
  }
}
