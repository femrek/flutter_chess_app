import 'package:core/core.dart';

/// Base class for all cache models
abstract interface class StorageModel {
  /// The unique identifier of the cache model. Recommended to use UUIDs.
  String get id;

  /// The metadata of the cache model
  StorageModelMetaData? metaData;

  /// Creates a cache model from a dynamic json object
  StorageModel fromJson(dynamic json);

  /// Converts the cache model to a json object
  Map<String, dynamic> toJson();
}
