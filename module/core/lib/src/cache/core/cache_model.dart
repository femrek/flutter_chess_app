/// Base class for all cache models
abstract interface class CacheModel {
  /// The unique identifier of the cache model
  String get id;

  /// Creates a cache model from a dynamic json object
  CacheModel fromDynamicJson(dynamic json);

  /// Converts the cache model to a json object
  Map<String, dynamic> toJson();
}
