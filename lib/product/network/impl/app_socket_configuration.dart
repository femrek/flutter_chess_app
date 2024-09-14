import 'dart:convert';

import 'package:core/core.dart';
import 'package:localchess/product/network/model/disconnect_network_model.dart';
import 'package:localchess/product/network/model/game_introduce_network_model.dart';
import 'package:localchess/product/network/model/game_network_model.dart';
import 'package:localchess/product/network/model/game_save_network_model.dart';
import 'package:localchess/product/network/model/introduce_network_model.dart';
import 'package:localchess/product/network/model/move_network_model.dart';

/// App Configuration for the socket.
final class AppSocketConfiguration implements ISocketConfiguration {
  final Map<Object, NetworkModel> _typeIdToModel = {
    GameSaveNetworkModel.type: GameSaveNetworkModel.empty(),
    IntroduceNetworkModel.type: const IntroduceNetworkModel.empty(),
    DisconnectNetworkModel.type: const DisconnectNetworkModel.empty(),
    GameIntroduceNetworkModel.type: const GameIntroduceNetworkModel.empty(),
    GameNetworkModel.type: const GameNetworkModel.empty(),
    MoveNetworkModel.type: const MoveNetworkModel.empty(),
  };

  @override
  List<NetworkModel> get models => _typeIdToModel.values.toList();

  @override
  NetworkModel sampleModelById(Object typeId) {
    final model = _typeIdToModel[typeId];

    if (model == null) {
      throw Exception('Model not found for type id: "$typeId". '
          'Available type ids: ${_typeIdToModel.keys}');
    }

    return model;
  }

  @override
  NetworkModel modelFromJsonString(String jsonString) {
    final json = jsonDecode(jsonString);

    // validate json
    if (json is! Map<String, dynamic>) {
      throw Exception('json is not a Map<String, dynamic>');
    }

    // validate typeId
    final typeIdJson = json['typeId'];
    if (typeIdJson == null) {
      throw Exception('typeId is null');
    }
    if (typeIdJson is! Object) {
      throw Exception('typeId is not an Object');
    }

    // get the model from the configuration
    final baseModel = sampleModelById(typeIdJson);
    return baseModel.fromJson(json);
  }

  @override
  String jsonStringFromModel(NetworkModel model) {
    return jsonEncode(model.toJson());
  }

  @override
  String get delimiter => '\t';
}
