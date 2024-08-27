import 'package:core/core.dart';
import 'package:gen/gen.dart';
import 'package:localchess/product/dependency_injection/get.dart';

/// A cache model for [LocalGameSave]
final class LocalGameSaveCacheModel implements CacheModel {
  /// Creates a new [LocalGameSaveCacheModel]
  LocalGameSaveCacheModel({required this.localGameSave});

  /// Creates an empty [LocalGameSaveCacheModel]
  LocalGameSaveCacheModel.empty() : localGameSave = LocalGameSave.empty();

  /// The local game save
  final LocalGameSave localGameSave;

  @override
  CacheModel fromDynamicJson(dynamic json) {
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

    try {
      return LocalGameSaveCacheModel(
        localGameSave: LocalGameSave.fromJson(json),
      );
    }
    // ignore: avoid_catching_errors
    on TypeError catch (e) {
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
  Map<String, dynamic> toJson() {
    return localGameSave.toJson();
  }
}
