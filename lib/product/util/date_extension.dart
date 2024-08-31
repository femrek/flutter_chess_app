/// Preforms operations over [DateTime] objects
extension DateExtension on DateTime {
  /// Creates a string to present the date and time.
  String get toVisualFormat {
    return '${_twoDigit(day)}.${_twoDigit(month)}.$year '
        '${_twoDigit(hour)}:${_twoDigit(minute)}';
  }
}

String _twoDigit(int n) {
  if (n < 10) return '0$n';
  return '$n';
}
