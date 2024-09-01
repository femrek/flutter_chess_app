import 'package:flutter_test/flutter_test.dart';
import 'package:localchess/product/data/square_coordinate.dart';

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
      // todo
    });
    // todo
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
}
