import 'package:core/core.dart';
import 'package:gen/gen.dart';
import 'package:localchess/product/dependency_injection/get.dart';

/// A cache model for [LocalGameSave]
final class LocalGameSaveCacheModel implements CacheModel {
  /// Creates a new [LocalGameSaveCacheModel]
  LocalGameSaveCacheModel({
    required this.localGameSave,
  });

  LocalGameSaveCacheModel._internal({
    required this.localGameSave,
    this.metaData,
  });

  /// Creates an empty [LocalGameSaveCacheModel]
  LocalGameSaveCacheModel.empty() : localGameSave = LocalGameSave.empty();

  /// The local game save
  final LocalGameSave localGameSave;

  @override
  CacheModel fromJson(dynamic json) {
    // log and return empty if json is not valid.
    if (json == null) {
      G.logger.e(
        'json is null',
        stackTrace: StackTrace.current,
      );
      return LocalGameSaveCacheModel.empty();
    }
    if (json is! Map) {
      G.logger.e(
        'json is not a Map',
        stackTrace: StackTrace.current,
      );
      return LocalGameSaveCacheModel.empty();
    }
    if (json is! Map<String, dynamic>) {
      G.logger.e(
        'json is not a Map<String, dynamic>',
        stackTrace: StackTrace.current,
      );
      return LocalGameSaveCacheModel.empty();
    }
    final dataJson = json['data'];
    if (dataJson == null) {
      G.logger.e(
        'dataJson is null',
        stackTrace: StackTrace.current,
      );
      return LocalGameSaveCacheModel.empty();
    }
    if (dataJson is! Map) {
      G.logger.e(
        'dataJson is not a Map',
        stackTrace: StackTrace.current,
      );
      return LocalGameSaveCacheModel.empty();
    }
    if (dataJson is! Map<String, dynamic>) {
      G.logger.e(
        'dataJson is not a Map<String, dynamic>',
        stackTrace: StackTrace.current,
      );
      return LocalGameSaveCacheModel.empty();
    }

    try {
      return LocalGameSaveCacheModel._internal(
        localGameSave: LocalGameSave.fromJson(dataJson),
        metaData: CacheModelMetaData.fromJson(
            json['metaData'] as Map<String, dynamic>),
      );
    } on TypeError catch (e) {
      G.logger.e(
        'Error while parsing json',
        error: e,
        stackTrace: StackTrace.current,
      );
      return LocalGameSaveCacheModel.empty();
    }
  }

  @override
  String get id => localGameSave.id;

  @override
  CacheModelMetaData? metaData;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'metaData': metaData?.toJson(),
      'data': localGameSave.toJson(),
    };
  }
}
