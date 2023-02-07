import 'dart:convert';
import 'dart:io';

class ConvertException extends Error {
  final message;
  ConvertException(this.message);
}

abstract class ActionType {}

abstract class HostSideActionType extends ActionType {}
class SendBoard extends HostSideActionType {
  final String fen;
  final String lastMoveFrom;
  final String lastMoveTo;

  SendBoard({
    required this.fen,
    required this.lastMoveFrom,
    required this.lastMoveTo,
  });

  factory SendBoard.fromJson(String json) {
    Map mapData = jsonDecode(json);
    if (mapData[actionKey] == sendBoardId) {
      return SendBoard(
        fen: mapData[fenKey],
        lastMoveFrom: mapData[lastMoveFromKey],
        lastMoveTo: mapData[lastMoveToKey],
      );
    } else {
      throw ConvertException('$json is not a SendBoard action');
    }
  }

  String toJson() {
    String dataJson = jsonEncode({
      actionKey: sendBoardId,
      fenKey: fen,
      lastMoveFromKey: lastMoveFrom,
      lastMoveToKey: lastMoveTo,
    });
    return dataJson;
  }
}

abstract class ClientSideActionType extends ActionType {}
class CheckConnectivity extends ClientSideActionType {}
class RequestConnection extends ClientSideActionType {}
class SendMove extends ClientSideActionType {
  final String from;
  final String to;

  SendMove({
    required this.from,
    required this.to,
  });

  factory SendMove.fromJson(String json) {
    Map mapData = jsonDecode(json);
    if (mapData[actionKey] == sendMoveId) {
      return SendMove(
        from: mapData[moveFromKey],
        to: mapData[moveToKey],
      );
    } else {
      throw ConvertException('$json is not a sendMove action');
    }
  }

  String toJson() {
    String dataJson = jsonEncode({
      actionKey: sendMoveId,
      moveFromKey: from,
      moveToKey: to,
    });
    return dataJson;
  }
}
class RequestBoard extends ClientSideActionType {
  RequestBoard();

  factory RequestBoard.fromJson(String json) {
    Map mapData = jsonDecode(json);
    if (mapData[actionKey] == requestBoardId) {
      return RequestBoard();
    } else {
      throw ConvertException('$json is not a sendMove action');
    }
  }

  String toJson() {
    String dataJson = jsonEncode({
      actionKey: RequestBoard,
    });
    return dataJson;
  }
}
class SendDisconnectSignal extends ClientSideActionType {}

const String sendBoardId = 'SendBoard';
const String checkConnectivityId = 'CheckConnectivity';
const String requestConnectionId = 'RequestConnection';
const String sendMoveId = 'SendMove';
const String requestBoardId = 'RequestBoard';
const String sendDisconnectSignalId = 'SendDisconnectSignal';

const String actionKey = 'action';
const String lastMoveFromKey = 'lastMoveFrom';
const String lastMoveToKey = 'lastMoveTo';
const String fenKey = 'fen';
const String moveFromKey = 'moveFrom';
const String moveToKey = 'moveTo';

ActionType decodeRawData(String dataJson) {
  Map dataMap = jsonDecode(dataJson);
  final String actionId = dataMap[actionKey];
  switch(actionId) {
    case sendBoardId:
      return SendBoard.fromJson(dataJson);
    case checkConnectivityId:
      return CheckConnectivity();
    case requestConnectionId:
      return RequestConnection();
    case sendMoveId:
      return SendMove.fromJson(dataJson);
    case requestBoardId:
      return RequestBoard.fromJson(dataJson);
    case sendDisconnectSignalId:
      return SendDisconnectSignal();
    default:
      throw 'undefined action type';
  }
}

sendBoard(Socket socket, String fen, String? lastMoveFrom, String? lastMoveTo) {
  String dataJson = jsonEncode({
    actionKey: sendBoardId,
    fenKey: fen,
    lastMoveFromKey: lastMoveFrom,
    lastMoveToKey: lastMoveTo,
  });
  socket.write(dataJson);
  print('sending $dataJson');
}

checkConnectivity() async {

}

requestConnection() async {

}

sendMove(Socket socket, String moveFrom, String moveTo) async {
  String dataJson = jsonEncode({
    actionKey: sendMoveId,
    moveFromKey: moveFrom,
    moveToKey: moveTo,
  });
  socket.write(dataJson);
  print('sending $dataJson');
}

requestBoard(Socket socket) async {
  String dataJson = jsonEncode({
    actionKey: requestBoardId,
  });
  socket.write(dataJson);
  print('board requested');
}

sendDisconnectSignal() async {

}
