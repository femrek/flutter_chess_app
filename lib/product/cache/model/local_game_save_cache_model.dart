import 'package:core/core.dart';
import 'package:gen/gen.dart';
import 'package:localchess/product/dependency_injection/get.dart';

/// A cache model for [LocalGameSave]
final class LocalGameSaveCacheModel implements CacheModel {
  /// Creates a new [LocalGameSaveCacheModel]
  LocalGameSaveCacheModel({
    required this.id,
    required this.localGameSave,
    this.creationError,
  });

  LocalGameSaveCacheModel._internal({
    required this.id,
    required this.localGameSave,
    this.metaData,
  }) : creationError = null;

  /// Creates an empty [LocalGameSaveCacheModel]
  LocalGameSaveCacheModel.empty({String? errorMessage})
      : id = '',
        localGameSave = LocalGameSave.empty(),
        creationError = errorMessage;

  @override
  final String id;

  @override
  CacheModelMetaData? metaData;

  /// The local game save.
  final LocalGameSave localGameSave;

  /// The error message if an error occurred while creating an object.
  final String? creationError;

  @override
  CacheModel fromJson(dynamic json) {
    // log and return empty if json is not valid.
    if (json == null) {
      const errorMessage = 'json is null';
      G.logger.e(errorMessage);
      return LocalGameSaveCacheModel.empty(errorMessage: errorMessage);
    }
    if (json is! Map) {
      const errorMessage = 'json is not a Map';
      G.logger.e(errorMessage);
      return LocalGameSaveCacheModel.empty(errorMessage: errorMessage);
    }
    if (json is! Map<String, dynamic>) {
      const errorMessage = 'json is not a Map<String, dynamic>';
      G.logger.e(errorMessage);
      return LocalGameSaveCacheModel.empty(errorMessage: errorMessage);
    }

    // validate the id. log and return empty, if id is not valid.
    final id = json['id'];
    {
      if (id == null) {
        const errorMessage = 'id is null';
        G.logger.e(errorMessage);
        return LocalGameSaveCacheModel.empty(errorMessage: errorMessage);
      }
      if (id is! String) {
        const errorMessage = 'id is not a String';
        G.logger.e(errorMessage);
        return LocalGameSaveCacheModel.empty(errorMessage: errorMessage);
      }
    }

    // validate the dataJson. log and return empty, if dataJson is not valid.
    final dataJson = json['data'];
    {
      if (dataJson == null) {
        const errorMessage = 'dataJson is null';
        G.logger.e(errorMessage);
        return LocalGameSaveCacheModel.empty(errorMessage: errorMessage);
      }
      if (dataJson is! Map) {
        const errorMessage = 'dataJson is not a Map';
        G.logger.e(errorMessage);
        return LocalGameSaveCacheModel.empty(errorMessage: errorMessage);
      }
      if (dataJson is! Map<String, dynamic>) {
        const errorMessage = 'dataJson is not a Map<String, dynamic>';
        G.logger.e(errorMessage);
        return LocalGameSaveCacheModel.empty(errorMessage: errorMessage);
      }
    }

    // validate the metadataJson. log and return empty, if metadataJson is not
    // valid.
    final metadataJson = json['metaData'];
    {
      if (metadataJson == null) {
        const errorMessage = 'metadataJson is null';
        G.logger.e(errorMessage);
        return LocalGameSaveCacheModel.empty(errorMessage: errorMessage);
      }
      if (metadataJson is! Map) {
        const errorMessage = 'metadataJson is not a Map';
        G.logger.e(errorMessage);
        return LocalGameSaveCacheModel.empty(errorMessage: errorMessage);
      }
      if (metadataJson is! Map<String, dynamic>) {
        const errorMessage = 'metadataJson is not a Map<String, dynamic>';
        G.logger.e(errorMessage);
        return LocalGameSaveCacheModel.empty(errorMessage: errorMessage);
      }
    }

    try {
      return LocalGameSaveCacheModel._internal(
        id: id,
        localGameSave: LocalGameSave.fromJson(dataJson),
        metaData: CacheModelMetaData.fromJson(metadataJson),
      );
    } on TypeError catch (e) {
      const errorMessage = 'Error while parsing json';
      G.logger.e(
        errorMessage,
        error: e,
      );
      return LocalGameSaveCacheModel.empty(errorMessage: errorMessage);
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'metaData': metaData?.toJson(),
      'data': localGameSave.toJson(),
    };
  }

  @override
  String toString() => 'LocalGameSaveCacheModel: ${toJson()}';
}
