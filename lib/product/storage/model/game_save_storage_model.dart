import 'package:core/core.dart';
import 'package:gen/gen.dart';
import 'package:localchess/product/dependency_injection/get.dart';

/// A cache model for [GameSave]
final class GameSaveStorageModel implements StorageModel {
  /// Creates a new [GameSaveStorageModel]
  GameSaveStorageModel({
    required this.id,
    required this.gameSave,
  }) : creationError = null;

  GameSaveStorageModel._internal({
    required this.id,
    required this.gameSave,
    this.metaData,
  }) : creationError = null;

  /// Creates an empty [GameSaveStorageModel]
  GameSaveStorageModel.empty({String? errorMessage})
      : id = '',
        gameSave = GameSave.empty(),
        creationError = errorMessage;

  /// Creates a [GameSaveStorageModel] from a json object
  factory GameSaveStorageModel.fromJson(dynamic json) {
    // log and return empty if json is not valid.
    if (json == null) {
      const errorMessage = 'json is null';
      G.logger.e(errorMessage);
      return GameSaveStorageModel.empty(errorMessage: errorMessage);
    }
    if (json is! Map) {
      const errorMessage = 'json is not a Map';
      G.logger.e(errorMessage);
      return GameSaveStorageModel.empty(errorMessage: errorMessage);
    }
    if (json is! Map<String, dynamic>) {
      const errorMessage = 'json is not a Map<String, dynamic>';
      G.logger.e(errorMessage);
      return GameSaveStorageModel.empty(errorMessage: errorMessage);
    }

    // validate the id. log and return empty, if id is not valid.
    final id = json['id'];
    {
      if (id == null) {
        const errorMessage = 'id is null';
        G.logger.e(errorMessage);
        return GameSaveStorageModel.empty(errorMessage: errorMessage);
      }
      if (id is! String) {
        const errorMessage = 'id is not a String';
        G.logger.e(errorMessage);
        return GameSaveStorageModel.empty(errorMessage: errorMessage);
      }
    }

    // validate the dataJson. log and return empty, if dataJson is not valid.
    final dataJson = json['data'];
    {
      if (dataJson == null) {
        const errorMessage = 'dataJson is null';
        G.logger.e(errorMessage);
        return GameSaveStorageModel.empty(errorMessage: errorMessage);
      }
      if (dataJson is! Map) {
        const errorMessage = 'dataJson is not a Map';
        G.logger.e(errorMessage);
        return GameSaveStorageModel.empty(errorMessage: errorMessage);
      }
      if (dataJson is! Map<String, dynamic>) {
        const errorMessage = 'dataJson is not a Map<String, dynamic>';
        G.logger.e(errorMessage);
        return GameSaveStorageModel.empty(errorMessage: errorMessage);
      }
    }

    // validate the metadataJson. log and return empty, if metadataJson is not
    // valid.
    final metadataJson = json['metaData'];
    {
      if (metadataJson == null) {
        const errorMessage = 'metadataJson is null';
        G.logger.e(errorMessage);
        return GameSaveStorageModel.empty(errorMessage: errorMessage);
      }
      if (metadataJson is! Map) {
        const errorMessage = 'metadataJson is not a Map';
        G.logger.e(errorMessage);
        return GameSaveStorageModel.empty(errorMessage: errorMessage);
      }
      if (metadataJson is! Map<String, dynamic>) {
        const errorMessage = 'metadataJson is not a Map<String, dynamic>';
        G.logger.e(errorMessage);
        return GameSaveStorageModel.empty(errorMessage: errorMessage);
      }
    }

    try {
      return GameSaveStorageModel._internal(
        id: id,
        gameSave: GameSave.fromJson(dataJson),
        metaData: StorageModelMetaData.fromJson(metadataJson),
      );
    } on TypeError catch (e) {
      const errorMessage = 'Error while parsing json';
      G.logger.e(
        errorMessage,
        error: e,
      );
      return GameSaveStorageModel.empty(errorMessage: errorMessage);
    }
  }

  @override
  final String id;

  @override
  StorageModelMetaData? metaData;

  /// The game save data.
  final GameSave gameSave;

  /// The error message if an error occurred while creating an object.
  final String? creationError;

  @override
  GameSaveStorageModel fromJson(dynamic json) {
    return GameSaveStorageModel.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'metaData': metaData?.toJson(),
      'data': gameSave.toJson(),
    };
  }

  @override
  String toString() => 'GameSaveCacheModel: ${toJson()}';
}
