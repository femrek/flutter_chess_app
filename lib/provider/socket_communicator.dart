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
    Map map = jsonDecode(json);
    if (map[actionKey] == sendBoardId) {
      return SendBoard(
        fen: map[fenKey],
        lastMoveFrom: map[lastMoveFromKey],
        lastMoveTo: map[lastMoveToKey],
      );
    } else {
      throw ConvertException('$json is not a SendBoard action');
    }
  }

  String toJson() {
    String json = jsonEncode({
      actionKey: sendBoardId,
      fenKey: fen,
      lastMoveFromKey: lastMoveFrom,
      lastMoveToKey: lastMoveTo,
    });
    return json;
  }

  @override
  String toString() {
    return toJson();
  }
}

abstract class ClientSideActionType extends ActionType {}

class CheckConnectivity extends ClientSideActionType {
  CheckConnectivity();

  factory CheckConnectivity.fromJson(String json) {
    Map map = jsonDecode(json);
    if (map[actionKey] == checkConnectivityId){
      return CheckConnectivity();
    } else {
      throw ConvertException('$json is not a checkConnectivity action');
    }
  }

  String toJson() {
    String json = jsonEncode({
      actionKey: checkConnectivityId,
    });
    return json;
  }

  @override
  String toString() {
    return toJson();
  }
}

class RequestConnection extends ClientSideActionType {
  RequestConnection();

  factory RequestConnection.fromJson(String json) {
    Map map = jsonDecode(json);
    if (map[actionKey] == requestConnectionId) {
      return RequestConnection();
    } else {
      throw ConvertException('$json is not a requestConnection action');
    }
  }

  String toJson() {
    String json = jsonEncode({
      actionKey: requestConnectionId,
    });
    return json;
  }

  @override
  String toString() {
    return toJson();
  }
}

class SendMove extends ClientSideActionType {
  final String from;
  final String to;

  SendMove({
    required this.from,
    required this.to,
  });

  factory SendMove.fromJson(String json) {
    Map map = jsonDecode(json);
    if (map[actionKey] == sendMoveId) {
      return SendMove(
        from: map[moveFromKey],
        to: map[moveToKey],
      );
    } else {
      throw ConvertException('$json is not a sendMove action');
    }
  }

  String toJson() {
    String json = jsonEncode({
      actionKey: sendMoveId,
      moveFromKey: from,
      moveToKey: to,
    });
    return json;
  }

  @override
  String toString() {
    return toJson();
  }
}

class RequestBoard extends ClientSideActionType {
  RequestBoard();

  factory RequestBoard.fromJson(String json) {
    Map map = jsonDecode(json);
    if (map[actionKey] == requestBoardId) {
      return RequestBoard();
    } else {
      throw ConvertException('$json is not a requestBoard action');
    }
  }

  String toJson() {
    String json = jsonEncode({
      actionKey: requestBoardId,
    });
    return json;
  }

  @override
  String toString() {
    return toJson();
  }
}

class SendDisconnectSignal extends ClientSideActionType {
  SendDisconnectSignal();

  factory SendDisconnectSignal.fromJson(String json) {
    Map map = jsonDecode(json);
    if (map[actionKey] == sendDisconnectSignalId) {
      return SendDisconnectSignal();
    } else {
      throw ConvertException('$json is not a sendDisconnectSignal action');
    }
  }

  String toJson() {
    String json = jsonEncode({
      actionKey: sendDisconnectSignalId,
    });
    return json;
  }
  
  @override
  String toString() {
    return toJson();
  } 
}

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

sendBoard(Socket socket, SendBoard data) {
  socket.write(data.toJson());
  print('sending $data');
}

checkConnectivity(Socket socket, CheckConnectivity data) async {
  socket.write(data.toJson());
  print('connectivity check');
}

requestConnection(Socket socket, RequestConnection data) async {
  socket.write(data.toJson());
  print('connection request');
}

sendMove(Socket socket, SendMove data) async {
  socket.write(data.toJson());
  print('sending $data');
}

requestBoard(Socket socket, RequestBoard data) async {
  socket.write(data.toJson());
  print('board requested');
}

sendDisconnectSignal(Socket socket, SendDisconnectSignal data) async {
  socket.write(data.toJson());
  print('sent disconnect signal');
}
