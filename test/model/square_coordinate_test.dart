import 'package:flutter_test/flutter_test.dart';
import 'package:localchess/product/data/coordinate/board_orientation_enum.dart';
import 'package:localchess/product/data/coordinate/square_coordinate.dart';

void main() {
  group('create a coordinate object with default constructor', () {
    test('coordinate a1', () {
      const coordinateA1 = SquareCoordinate(0, 0);
      expect(coordinateA1.x, 0);
      expect(coordinateA1.y, 0);
      expect(coordinateA1.nameLowerCase, 'a1');
    });

    test('coordinate a8', () {
      const coordinateA8 = SquareCoordinate(0, 7);
      expect(coordinateA8.x, 0);
      expect(coordinateA8.y, 7);
      expect(coordinateA8.nameLowerCase, 'a8');
    });

    test('coordinate h1', () {
      const coordinateH1 = SquareCoordinate(7, 0);
      expect(coordinateH1.x, 7);
      expect(coordinateH1.y, 0);
      expect(coordinateH1.nameLowerCase, 'h1');
    });

    test('coordinate h8', () {
      const coordinateH8 = SquareCoordinate(7, 7);
      expect(coordinateH8.x, 7);
      expect(coordinateH8.y, 7);
      expect(coordinateH8.nameLowerCase, 'h8');
    });
  });

  group('create a coordinate object with fromName constructor', () {
    test('coordinate a1', () {
      final coordinateA1 = SquareCoordinate.fromName('a1');
      expect(coordinateA1.x, 0);
      expect(coordinateA1.y, 0);
      expect(coordinateA1.nameLowerCase, 'a1');
      expect(coordinateA1.nameUpperCase, 'A1');

      final coordinateA1UpperCase = SquareCoordinate.fromName('A1');
      expect(coordinateA1UpperCase.x, 0);
      expect(coordinateA1UpperCase.y, 0);
      expect(coordinateA1UpperCase.nameLowerCase, 'a1');
      expect(coordinateA1UpperCase.nameUpperCase, 'A1');
    });

    test('coordinate a8', () {
      final coordinateA8 = SquareCoordinate.fromName('a8');
      expect(coordinateA8.x, 0);
      expect(coordinateA8.y, 7);
      expect(coordinateA8.nameLowerCase, 'a8');
      expect(coordinateA8.nameUpperCase, 'A8');

      final coordinateA8UpperCase = SquareCoordinate.fromName('A8');
      expect(coordinateA8UpperCase.x, 0);
      expect(coordinateA8UpperCase.y, 7);
      expect(coordinateA8UpperCase.nameLowerCase, 'a8');
      expect(coordinateA8UpperCase.nameUpperCase, 'A8');
    });

    test('coordinate h1', () {
      final coordinateH1 = SquareCoordinate.fromName('h1');
      expect(coordinateH1.x, 7);
      expect(coordinateH1.y, 0);
      expect(coordinateH1.nameLowerCase, 'h1');
      expect(coordinateH1.nameUpperCase, 'H1');

      final coordinateH1UpperCase = SquareCoordinate.fromName('H1');
      expect(coordinateH1UpperCase.x, 7);
      expect(coordinateH1UpperCase.y, 0);
      expect(coordinateH1UpperCase.nameLowerCase, 'h1');
      expect(coordinateH1UpperCase.nameUpperCase, 'H1');
    });

    test('coordinate h8', () {
      final coordinateH8 = SquareCoordinate.fromName('h8');
      expect(coordinateH8.x, 7);
      expect(coordinateH8.y, 7);
      expect(coordinateH8.nameLowerCase, 'h8');
      expect(coordinateH8.nameUpperCase, 'H8');

      final coordinateH8UpperCase = SquareCoordinate.fromName('H8');
      expect(coordinateH8UpperCase.x, 7);
      expect(coordinateH8UpperCase.y, 7);
      expect(coordinateH8UpperCase.nameLowerCase, 'h8');
      expect(coordinateH8UpperCase.nameUpperCase, 'H8');
    });
  });

  group('create a coordinate object with fromIndexStartWithA8 constructor', () {
    test('coordinate a8', () {
      final coordinateA8 = SquareCoordinate.fromIndexStartWithA8(0);
      expect(coordinateA8.x, 0);
      expect(coordinateA8.y, 7);
      expect(coordinateA8.nameLowerCase, 'a8');
    });

    test('coordinate h8', () {
      final coordinateH8 = SquareCoordinate.fromIndexStartWithA8(7);
      expect(coordinateH8.x, 7);
      expect(coordinateH8.y, 7);
      expect(coordinateH8.nameLowerCase, 'h8');
    });

    test('coordinate a1', () {
      final coordinateA1 = SquareCoordinate.fromIndexStartWithA8(56);
      expect(coordinateA1.x, 0);
      expect(coordinateA1.y, 0);
      expect(coordinateA1.nameLowerCase, 'a1');
    });

    test('coordinate h1', () {
      final coordinateH1 = SquareCoordinate.fromIndexStartWithA8(63);
      expect(coordinateH1.x, 7);
      expect(coordinateH1.y, 0);
      expect(coordinateH1.nameLowerCase, 'h1');
    });
  });

  group('create a coordinate object with fromIndexStartWithA1 constructor', () {
    test('coordinate a1', () {
      final coordinateA1 = SquareCoordinate.fromIndexStartWithA1(0);
      expect(coordinateA1.x, 0);
      expect(coordinateA1.y, 0);
      expect(coordinateA1.nameLowerCase, 'a1');
    });

    test('coordinate a8', () {
      final coordinateA8 = SquareCoordinate.fromIndexStartWithA1(7);
      expect(coordinateA8.x, 0);
      expect(coordinateA8.y, 7);
      expect(coordinateA8.nameLowerCase, 'a8');
    });

    test('coordinate h1', () {
      final coordinateH1 = SquareCoordinate.fromIndexStartWithA1(56);
      expect(coordinateH1.x, 7);
      expect(coordinateH1.y, 0);
      expect(coordinateH1.nameLowerCase, 'h1');
    });

    test('coordinate h8', () {
      final coordinateH8 = SquareCoordinate.fromIndexStartWithA1(63);
      expect(coordinateH8.x, 7);
      expect(coordinateH8.y, 7);
      expect(coordinateH8.nameLowerCase, 'h8');
    });
  });

  group('create a coordinate object with fromIndexStartWithH1 constructor', () {
    test('coordinate h1', () {
      final coordinateA1 = SquareCoordinate.fromIndexStartWithH1(0);
      expect(coordinateA1.x, 7);
      expect(coordinateA1.y, 0);
      expect(coordinateA1.nameLowerCase, 'h1');
    });

    test('coordinate a1', () {
      final coordinateA8 = SquareCoordinate.fromIndexStartWithH1(7);
      expect(coordinateA8.x, 0);
      expect(coordinateA8.y, 0);
      expect(coordinateA8.nameLowerCase, 'a1');
    });

    test('coordinate h8', () {
      final coordinateH1 = SquareCoordinate.fromIndexStartWithH1(56);
      expect(coordinateH1.x, 7);
      expect(coordinateH1.y, 7);
      expect(coordinateH1.nameLowerCase, 'h8');
    });

    test('coordinate a8', () {
      final coordinateH8 = SquareCoordinate.fromIndexStartWithH1(63);
      expect(coordinateH8.x, 0);
      expect(coordinateH8.y, 7);
      expect(coordinateH8.nameLowerCase, 'a8');
    });
  });

  group(
    'create a coordinate object with fromIndex constructor in portrait mode',
    () {
      test('coordinate a8', () {
        final coordinateA8 = SquareCoordinate.fromIndex(
            index: 0, orientation: BoardOrientationEnum.portrait);
        expect(coordinateA8.x, 0);
        expect(coordinateA8.y, 7);
        expect(coordinateA8.nameLowerCase, 'a8');
      });

      test('coordinate h8', () {
        final coordinateH8 = SquareCoordinate.fromIndex(
            index: 7, orientation: BoardOrientationEnum.portrait);
        expect(coordinateH8.x, 7);
        expect(coordinateH8.y, 7);
        expect(coordinateH8.nameLowerCase, 'h8');
      });

      test('coordinate a1', () {
        final coordinateA1 = SquareCoordinate.fromIndex(
            index: 56, orientation: BoardOrientationEnum.portrait);
        expect(coordinateA1.x, 0);
        expect(coordinateA1.y, 0);
        expect(coordinateA1.nameLowerCase, 'a1');
      });

      test('coordinate h1', () {
        final coordinateH1 = SquareCoordinate.fromIndex(
            index: 63, orientation: BoardOrientationEnum.portrait);
        expect(coordinateH1.x, 7);
        expect(coordinateH1.y, 0);
        expect(coordinateH1.nameLowerCase, 'h1');
      });
    },
  );

  group(
      'create a coordinate object with fromIndex constructor '
      'in landscape mode', () {
    test('coordinate a1', () {
      final coordinateA1 = SquareCoordinate.fromIndex(
          index: 0, orientation: BoardOrientationEnum.landscapeLeftBased);
      expect(coordinateA1.x, 0);
      expect(coordinateA1.y, 0);
      expect(coordinateA1.nameLowerCase, 'a1');
    });

    test('coordinate a8', () {
      final coordinateA8 = SquareCoordinate.fromIndex(
          index: 7, orientation: BoardOrientationEnum.landscapeLeftBased);
      expect(coordinateA8.x, 0);
      expect(coordinateA8.y, 7);
      expect(coordinateA8.nameLowerCase, 'a8');
    });

    test('coordinate h1', () {
      final coordinateH1 = SquareCoordinate.fromIndex(
          index: 56, orientation: BoardOrientationEnum.landscapeLeftBased);
      expect(coordinateH1.x, 7);
      expect(coordinateH1.y, 0);
      expect(coordinateH1.nameLowerCase, 'h1');
    });

    test('coordinate h8', () {
      final coordinateH8 = SquareCoordinate.fromIndex(
          index: 63, orientation: BoardOrientationEnum.landscapeLeftBased);
      expect(coordinateH8.x, 7);
      expect(coordinateH8.y, 7);
      expect(coordinateH8.nameLowerCase, 'h8');
    });
  });
}
