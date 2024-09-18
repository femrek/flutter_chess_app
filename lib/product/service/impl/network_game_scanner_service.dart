import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:core/core.dart';
import 'package:localchess/product/constant/host_constant.dart';
import 'package:localchess/product/data/network_scan_result.dart';
import 'package:localchess/product/network/impl/socket_client_manager.dart';
import 'package:localchess/product/service/core/i_network_game_scanner_service.dart';

/// A service to scan the network for available games. Implements the
/// [INetworkGameScannerService] interface.
class NetworkGameScannerService implements INetworkGameScannerService {
  @override
  Stream<NetworkScanResult?> scan(String inet, String mask) {
    final baseAddress = convertIpAddressToNumber(inet);
    final length = findLengthBySubmask(mask);

    return Stream.fromFutures(
      findRange(baseAddress, length).map<Future<NetworkScanResult?>>((e) {
        return checkHost(AddressOnNetwork(
          address: InternetAddress(e),
          port: HostConstant.addressOnNetwork.port,
        ));
      }),
    );
  }

  @override
  Future<NetworkScanResult?> checkHost(
    AddressOnNetwork address, {
    Duration timeout = const Duration(seconds: 5),
    Duration tickRate = const Duration(milliseconds: 100),
  }) async {
    final result = runZonedGuarded(
          () async {
            try {
              SenderInformation? hostInformation;
              await SocketClientManager.scanRequest(
                address: address,
                onConnectedListener: (hostInfo) {
                  hostInformation = hostInfo;
                },
              );

              // wait until the host information is found;
              final maxTicks =
                  timeout.inMilliseconds ~/ tickRate.inMilliseconds;
              var tick = 0;
              await Future.doWhile(() async {
                await Future.delayed(tickRate, () {});

                // break the loop if the host information is found or the
                // timeout is reached.
                return (tick++ < maxTicks) && hostInformation == null;
              });

              return hostInformation == null
                  ? null
                  : NetworkScanResult(
                      hostInformation: hostInformation!,
                      address: address,
                    );
            } on SocketException catch (_) {
              return null;
            }
          },
          (e, s) {},
          zoneSpecification: ZoneSpecification(
            errorCallback: (self, parent, zone, error, stackTrace) {
              return null;
            },
          ),
        ) ??
        Future.value();

    return result;
  }

  @override
  int findHostCountBySubmask(String mask) {
    return pow(2, 32 - findLengthBySubmask(mask)).toInt();
  }

  /// make ip address a simple integer.
  /// 10.42.0.255 -> 170524927
  int convertIpAddressToNumber(String address) {
    num result = 0;
    var startIndex = 0;
    var latestDotIndex = 0;
    for (var i = 0; i < 4; i++) {
      latestDotIndex = address.indexOf('.', latestDotIndex + 1);
      if (latestDotIndex < 0) latestDotIndex = address.length;
      final partString = address.substring(startIndex, latestDotIndex);
      final part = int.parse(partString);
      result += part * pow(2, (3 - i) * 8);
      startIndex = latestDotIndex + 1;
    }
    return result.toInt();
  }

  /// convert ip address value in number format into string.
  /// 170524927 -> 10.42.0.255
  String convertNumberToIpAddress(num address) {
    final result = StringBuffer();
    for (var i = 0; i < 4; i++) {
      var part = (address.toInt() % pow(2, (4 - i) * 8).toInt()) -
          (address.toInt() % pow(2, (3 - i) * 8).toInt());
      part ~/= pow(2, (3 - i) * 8).toInt();
      result.write(part);
      if (i < 3) result.write('.');
    }
    return result.toString();
  }

  /// find the length of the submask. (e.g. 255.255.255.0 -> 24)
  int findLengthBySubmask(String submask) {
    final submaskAsInt = convertIpAddressToNumber(submask);
    var result = 0;
    for (var i = 0; i < 32; i++) {
      if (submaskAsInt % pow(2, 32 - i) == 0) break;
      result++;
    }
    return result;
  }

  /// find the range of ip addresses in the same subnet.
  List<String> findRange(int baseAddress, int length) {
    final result = <String>[];
    num subnetAddress = 0;
    for (var i = 31; i > 31 - length; i--) {
      subnetAddress += pow(2, i);
    }
    final firstAddress = subnetAddress.toInt() & baseAddress;
    final lastAddress =
        (subnetAddress.toInt() ^ convertIpAddressToNumber('255.255.255.255')) |
            baseAddress;
    for (var i = firstAddress; i <= lastAddress; i++) {
      result.add(convertNumberToIpAddress(i));
    }
    return result;
  }
}
