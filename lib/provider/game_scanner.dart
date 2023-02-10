import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:localchess/data/config.dart';
import 'package:localchess/data/model/address_and_port.dart';
import 'package:localchess/data/model/game_search_information.dart';
import 'package:localchess/provider/socket_communicator.dart';

class GameScanner {
  Map<AddressAndPort, Socket> requests = {};

  Future<List<GameSearchInformation>> scan(String baseAddress, int maskLength) async {
    List<GameSearchInformation> result = [];
    List<AddressAndPort> addresses = _findRange(
      _convertIpAddressToNumber(baseAddress),
      maskLength,
    ).map<AddressAndPort>((e) {
      return AddressAndPort(address: e, port: portsWithPriority[0]);
    }).toList();

    List<CheckStatus> results = await Future.wait(addresses.map<Future<CheckStatus>>((e) {
      return _checkIfOpen(e);
    }));

    for (int i = 0; i < results.length; i++) {
      if (results[i] != CheckStatus.portClosed) {
        result.add(GameSearchInformation(
          addressAndPort: addresses[i],
          ableToConnect: results[i] == CheckStatus.gameIsAvailable,
        ));
      }
    }
    return result;
  }

  /// make ip address a simple integer.
  /// 10.42.0.255 -> 170524927 
  num _convertIpAddressToNumber(String address) {
    num result = 0;
    int startIndex = 0;
    int latestDotIndex = 0;
    for (int i = 0; i < 4; i++) {
      latestDotIndex = address.indexOf('.', latestDotIndex + 1);
      if (latestDotIndex < 0) latestDotIndex = address.length;
      String partString = address.substring(startIndex, latestDotIndex);
      int part = int.parse(partString);
      result += part * pow(2, (3-i)*8);
      startIndex = latestDotIndex + 1;
    }
    return result;
  }

  /// convert ip address value in number format into string.
  /// 170524927 -> 10.42.0.255
  String _convertNumberToIpAddress(num address) {
    String result = '';
    for (int i = 0; i < 4; i++) {
      int part = (address.toInt() % pow(2, (4-i)*8).toInt()) - (address.toInt() % pow(2, (3-i)*8).toInt());
      part ~/= pow(2, (3-i)*8).toInt();
      result += part.toString();
      if (i < 3) result += '.';
    }
    return result;
  }

  List<String> _findRange(num baseAddress, int length) {
    List<String> result = [];
    num subnetAddress = 0;
    for (int i = 31; i > 31-length; i--) {
      subnetAddress += pow(2, i);
    }
    int firstAddress = subnetAddress.toInt() & baseAddress.toInt();
    int lastAddress = (subnetAddress.toInt() ^ _convertIpAddressToNumber('255.255.255.255').toInt()) | baseAddress.toInt();
    for (int i = firstAddress; i <= lastAddress; i++) {
      result.add(_convertNumberToIpAddress(i));
    }
    return result;
  }

  Future<CheckStatus> _checkIfOpen(AddressAndPort target) async {
    try {
      requests[target] = await Socket.connect(target.address, target.port);
      send(requests[target]!, CheckConnectivity());
      Uint8List dataAsByte = await requests[target]!.elementAt(0);
      String s = new String.fromCharCodes(dataAsByte);
      ActionType action = decodeRawData(s);
      send(requests[target]!, SendDisconnectSignal());
      requests[target]!.close();
      if (action is SendConnectivityState) {
        if (action.ableToConnect) {
          return CheckStatus.gameIsAvailable;
        } else {
          return CheckStatus.gameIsNotAbleToConnect;
        }
      } else {
        throw 'action is not defined';
      }
    } on SocketException {
      return CheckStatus.portClosed;
    }
  }

  static final GameScanner _instance = GameScanner._internal();
  GameScanner._internal();
  factory GameScanner() => _instance;
}

enum CheckStatus {
  portClosed,
  gameIsNotAbleToConnect,
  gameIsAvailable,
}
