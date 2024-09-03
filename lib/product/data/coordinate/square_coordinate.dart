import 'package:flutter/foundation.dart';
import 'package:localchess/product/data/coordinate/board_orientation_enum.dart';

/// Represents a coordinate of a square on the board.
@immutable
class SquareCoordinate {
  /// Creates a square coordinate.
  const SquareCoordinate(this.x, this.y);

  /// Creates a square coordinate from a name. e.g. A1, H8
  factory SquareCoordinate.fromName(String name) {
    // ensure the name is 2 characters long
    assert(name.length == 2, 'Invalid square name. It must be 2 characters');

    // ensure the first character is a letter
    final isLowerCase = name[0].codeUnitAt(0) >= 'a'.codeUnitAt(0) &&
        name[0].codeUnitAt(0) <= 'h'.codeUnitAt(0);
    final isUpperCase = name[0].codeUnitAt(0) >= 'A'.codeUnitAt(0) &&
        name[0].codeUnitAt(0) <= 'H'.codeUnitAt(0);
    assert(
      isLowerCase || isUpperCase,
      'Invalid colum. It must be between A and H or a and h',
    );

    // ensure the second character is a number between 1 and 8
    assert(
      int.tryParse(name[1]) != null,
      'Invalid row. It must be a number and between 1 and 8',
    );
    assert(
      int.parse(name[1]) >= 1 && int.parse(name[1]) <= 8,
      'Invalid row. It must be between 1 and 8',
    );

    // create the coordinate
    late int column;
    if (isLowerCase) {
      column = name.codeUnitAt(0) - 'a'.codeUnitAt(0);
    } else if (isUpperCase) {
      column = name.codeUnitAt(0) - 'A'.codeUnitAt(0);
    } else {
      throw Exception('Invalid column name when creating SquareCoordinate');
    }

    final row = int.parse(name[1]) - 1;

    return SquareCoordinate(column, row);
  }

  /// Creates a square coordinate from an index. valid distance is between
  /// 0 and 63. Use if the top left square of gridview is A8. (portrait board
  /// uses this notation.)
  factory SquareCoordinate.fromIndexStartWithA8(int index) {
    assert(
      index >= 0 && index < 64,
      'Invalid index. It must be between 0 and 63',
    );

    final column = index % 8;
    final row = 7 - index ~/ 8;
    return SquareCoordinate(column, row);
  }

  /// Creates a square coordinate from an index. valid distance is between
  /// 0 and 63. Use if the top left square of gridview is A1. (landscape board
  /// uses this notation.)
  factory SquareCoordinate.fromIndexStartWithA1(int index) {
    assert(
      index >= 0 && index < 64,
      'Invalid index. It must be between 0 and 63',
    );

    final column = index ~/ 8;
    final row = index % 8;
    return SquareCoordinate(column, row);
  }

  /// Creates a square coordinate from an index. valid distance is between
  /// 0 and 63. Use if the top left square of gridview is A8 or A1 depending on
  /// the orientation.
  factory SquareCoordinate.fromIndex({
    required int index,
    required BoardOrientationEnum orientation,
  }) {
    switch (orientation) {
      case BoardOrientationEnum.portrait:
        return SquareCoordinate.fromIndexStartWithA8(index);
      case BoardOrientationEnum.landscapeLeftBased:
        return SquareCoordinate.fromIndexStartWithA1(index);
    }
  }

  /// Calls [SquareCoordinate.fromName] if [name] is not null, otherwise returns
  /// null.
  static SquareCoordinate? fromNameOrNull(String? name) {
    if (name == null) return null;
    return SquareCoordinate.fromName(name);
  }

  /// The column of the square. 0 is the leftmost column, 7 is the rightmost
  /// column.
  final int x;

  /// The row of the square. 0 is the top row, 7 is the bottom row.
  final int y;

  /// The name of the square. e.g. A1, H8
  String get nameUpperCase =>
      String.fromCharCode('A'.codeUnitAt(0) + x) + (y + 1).toString();

  /// The name of the square in lowercase. e.g. a1, h8
  String get nameLowerCase =>
      String.fromCharCode('a'.codeUnitAt(0) + x) + (y + 1).toString();

  /// The square in this coordinate should be dark
  bool get isDark => (y + x).isEven;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SquareCoordinate &&
          runtimeType == other.runtimeType &&
          y == other.y &&
          x == other.x;

  @override
  int get hashCode => y.hashCode ^ x.hashCode;

  @override
  String toString() {
    return 'SquareCoordinate{y: $y, x: $x, name: $nameUpperCase}';
  }
}
