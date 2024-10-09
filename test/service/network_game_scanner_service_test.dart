import 'package:flutter_test/flutter_test.dart';
import 'package:localchess/product/service/impl/network_game_scanner_service.dart';

import '../test_config/test_init.dart';

void main() async {
  await TestInit.initWithTestStorageImpl();

  late NetworkGameScannerService service;

  setUp(() {
    service = NetworkGameScannerService();
  });

  group('NetworkGameScannerService.findHostCountBySubmask', () {
    <String, int>{
      '255.255.255.255': 1,
      '255.255.255.0': 256,
      '255.255.0.0': 65536,
      '255.0.0.0': 16777216,
      '0.0.0.0': 4294967296,
      '255.255.255.254': 2,
      '255.255.255.252': 4,
      '255.255.255.248': 8,
      '255.255.255.192': 64,
      '255.255.192.0': 16384,
      '255.255.128.0': 32768,
    }.forEach((input, expected) {
      test('$input => $expected', () {
        final result = service.findHostCountBySubmask(input);
        expect(result, expected);
      });
    });
  });

  group('NetworkGameScannerService.convertIpAddressToNumber', () {
    <String, int>{
      '192.168.0.1': 3232235521,
      '255.255.255.255': 4294967295,
      '0.0.0.0': 0,
      '1.2.3.4': 16909060,
    }.forEach((input, expected) {
      test('$input => $expected', () {
        final result = service.convertIpAddressToNumber(input);
        expect(result, expected);
      });
    });
  });

  group('NetworkGameScannerService.convertNumberToIpAddress', () {
    <int, String>{
      3232235521: '192.168.0.1',
      4294967295: '255.255.255.255',
      0: '0.0.0.0',
      16909060: '1.2.3.4',
    }.forEach((input, expected) {
      test('$input => $expected', () {
        final result = service.convertNumberToIpAddress(input);
        expect(result, expected);
      });
    });
  });

  group('NetworkGameScannerService.findLengthBySubmask', () {
    <String, int>{
      '255.255.255.255': 32,
      '255.255.255.0': 24,
      '255.255.0.0': 16,
      '255.0.0.0': 8,
      '0.0.0.0': 0,
      '255.255.255.254': 31,
      '255.255.255.252': 30,
      '255.255.255.248': 29,
      '255.255.255.192': 26,
      '255.255.192.0': 18,
      '255.255.128.0': 17,
    }.forEach((input, expected) {
      test('$input => $expected', () {
        final result = service.findLengthBySubmask(input);
        expect(result, expected);
      });
    });
  });

  group('NetworkGameScannerService.findRange', () {
    <(int, int), List<String>>{
      (3232235521, 32): ['192.168.0.1'],
      (3232235521, 28): [
        '192.168.0.0',
        '192.168.0.1',
        '192.168.0.2',
        '192.168.0.3',
        '192.168.0.4',
        '192.168.0.5',
        '192.168.0.6',
        '192.168.0.7',
        '192.168.0.8',
        '192.168.0.9',
        '192.168.0.10',
        '192.168.0.11',
        '192.168.0.12',
        '192.168.0.13',
        '192.168.0.14',
        '192.168.0.15',
      ],
    }.forEach((input, expected) {
      test('$input => $expected', () {
        final result = service.findRange(input.$1, input.$2);
        expect(result, expected);
      });
    });
  });
}
