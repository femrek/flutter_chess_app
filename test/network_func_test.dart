import 'package:flutter_test/flutter_test.dart';
import 'package:localchess/provider/game_scanner.dart';

void main() {
  group('network functions', () {
    test('', () {
      expect(GameScanner().findLengthBySubmask('255.255.255.0'), equals(24));
      expect(GameScanner().findLengthBySubmask('255.255.0.0'), equals(16));
      expect(GameScanner().findLengthBySubmask('255.0.0.0'), equals(8));
      expect(GameScanner().findLengthBySubmask('0.0.0.0'), equals(0));
    });
  });
}
