import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/network/core/model/network_model.dart';
import 'package:localchess/product/network/core/model/sender_information.dart';
import 'package:localchess/product/storage/model/game_save_storage_model.dart';

/// A network model for communicating [GameSaveStorageModel] data.
class GameSaveNetworkModel implements NetworkModel {
  /// Creates a new [GameSaveNetworkModel]
  GameSaveNetworkModel({
    required this.gameSaveStorageModel,
  }) : _senderInformation = null;

  GameSaveNetworkModel._internal({
    required this.gameSaveStorageModel,
    required SenderInformation senderInformation,
  }) : _senderInformation = senderInformation;

  /// Creates an empty [GameSaveNetworkModel]
  GameSaveNetworkModel.empty()
      : gameSaveStorageModel = GameSaveStorageModel.empty(),
        _senderInformation = null;

  /// The [GameSaveStorageModel] data.
  final GameSaveStorageModel gameSaveStorageModel;

  final SenderInformation? _senderInformation;

  @override
  SenderInformation get senderInformation =>
      _senderInformation ?? G.deviceProperties.senderInformation;

  @override
  String get typeId => GameSaveNetworkModel.type;

  /// The type identifier for the [GameSaveNetworkModel]
  static const String type = 'GameSaveNetworkModel';

  @override
  NetworkModel fromJson(Map<String, dynamic> json) {
    // validate typeId
    final typeIdJson = json['typeId'];
    if (typeIdJson == null) {
      throw Exception('typeId is null');
    }
    if (typeIdJson is! String) {
      throw Exception('typeId is not a String');
    }
    if (typeIdJson != typeId) {
      throw Exception('typeId is not equal to typeId');
    }

    // validate senderInformation
    final senderInformationJson = json['senderInformation'];
    if (senderInformationJson == null) {
      throw Exception('senderInformation is null');
    }
    if (senderInformationJson is! Map) {
      throw Exception('senderInformation is not a Map');
    }
    if (senderInformationJson is! Map<String, dynamic>) {
      throw Exception('senderInformation is not a Map<String, dynamic>');
    }

    // validate save data
    final gameSaveCacheModelJson = json['gameSaveCacheModel'];
    if (gameSaveCacheModelJson == null) {
      throw Exception('gameSaveCacheModel is null');
    }
    if (gameSaveCacheModelJson is! Map) {
      throw Exception('gameSaveCacheModel is not a Map');
    }
    if (gameSaveCacheModelJson is! Map<String, dynamic>) {
      throw Exception('gameSaveCacheModel is not a Map<String, dynamic>');
    }

    return GameSaveNetworkModel._internal(
      gameSaveStorageModel:
          GameSaveStorageModel.fromJson(gameSaveCacheModelJson),
      senderInformation: senderInformation,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'senderInformation': senderInformation,
      'typeId': typeId,
      'gameSaveCacheModel': gameSaveStorageModel.toJson(),
    };
  }
}
