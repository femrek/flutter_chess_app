import 'dart:convert';
import 'dart:io';

class ConvertException extends Error {
  final message;
  ConvertException(this.message);
}

abstract class ActionType {
  String toJson();
}

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

class SendConnectivityState extends HostSideActionType {
  final bool ableToConnect;

  SendConnectivityState({
    required this.ableToConnect,
  });

  factory SendConnectivityState.fromJson(String json) {
    Map map = jsonDecode(json);
    if (map[actionKey] == sendConnectivityStateId) {
      return SendConnectivityState(
        ableToConnect: map['ableToConnect'],
      );
    } else {
      throw ConvertException('$json is not a SendConnectivityState action');
    }
  }

  String toJson() {
    String json = jsonEncode({
      actionKey: sendConnectivityStateId,
      ableToConnectKey: ableToConnect,
    });
    return json;
  }

  @override
  String toString() {
    return toJson();
  }
}

class SendKick extends HostSideActionType {
  SendKick();

  factory SendKick.fromJson(String json) {
    Map map = jsonDecode(json);
    if (map[actionKey] == sendKickId){
      return SendKick();
    } else {
      throw ConvertException('$json is not a sendKick action');
    }
  }

  String toJson() {
    String json = jsonEncode({
      actionKey: sendKickId,
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
  final String? promotion;

  SendMove({
    required this.from,
    required this.to,
    this.promotion,
  });

  factory SendMove.fromJson(String json) {
    Map map = jsonDecode(json);
    if (map[actionKey] == sendMoveId) {
      return SendMove(
        from: map[moveFromKey],
        to: map[moveToKey],
        promotion: map[movePromotionKey]
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
      movePromotionKey: promotion,
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
const String sendConnectivityStateId = 'SendConnectivityState';
const String sendKickId = 'SendKick';
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
const String movePromotionKey = 'movePromotion';
const String ableToConnectKey = 'ableToConnect';

ActionType decodeRawData(String json) {
  Map dataMap = jsonDecode(json);
  final String actionId = dataMap[actionKey];
  switch(actionId) {
    case sendBoardId:
      return SendBoard.fromJson(json);
    case sendConnectivityStateId:
      return SendConnectivityState.fromJson(json);
    case sendKickId:
      return SendKick.fromJson(json);
    case checkConnectivityId:
      return CheckConnectivity.fromJson(json);
    case requestConnectionId:
      return RequestConnection.fromJson(json);
    case sendMoveId:
      return SendMove.fromJson(json);
    case requestBoardId:
      return RequestBoard.fromJson(json);
    case sendDisconnectSignalId:
      return SendDisconnectSignal.fromJson(json);
    default:
      throw 'undefined action type';
  }
}

void send(Socket socket, ActionType data) {
  socket.write(data.toJson());
  print('sending $data');
}
