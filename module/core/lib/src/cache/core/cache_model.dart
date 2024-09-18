import 'package:core/core.dart';

/// Base class for all cache models
abstract interface class CacheModel {
  /// The unique identifier of the cache model. Recommended to use UUIDs.
  String get id;

  /// The metadata of the cache model
  CacheModelMetaData? metaData;

  /// Creates a cache model from a dynamic json object
  CacheModel fromJson(dynamic json);

  /// Converts the cache model to a json object
  Map<String, dynamic> toJson();
}
