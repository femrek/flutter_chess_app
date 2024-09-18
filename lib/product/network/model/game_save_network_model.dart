import 'package:core/core.dart';
import 'package:localchess/product/cache/model/game_save_cache_model.dart';
import 'package:localchess/product/dependency_injection/get.dart';

/// A network model for communicating [GameSaveCacheModel] data.
class GameSaveNetworkModel implements NetworkModel {
  /// Creates a new [GameSaveNetworkModel]
  GameSaveNetworkModel({
    required this.gameSaveCacheModel,
  }) : _senderInformation = null;

  GameSaveNetworkModel._internal({
    required this.gameSaveCacheModel,
    required SenderInformation senderInformation,
  }) : _senderInformation = senderInformation;

  /// Creates an empty [GameSaveNetworkModel]
  GameSaveNetworkModel.empty()
      : gameSaveCacheModel = GameSaveCacheModel.empty(),
        _senderInformation = null;

  /// The [GameSaveCacheModel] data.
  final GameSaveCacheModel gameSaveCacheModel;

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
      gameSaveCacheModel: GameSaveCacheModel.fromJson(gameSaveCacheModelJson),
      senderInformation: senderInformation,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'senderInformation': senderInformation,
      'typeId': typeId,
      'gameSaveCacheModel': gameSaveCacheModel.toJson(),
    };
  }
}
