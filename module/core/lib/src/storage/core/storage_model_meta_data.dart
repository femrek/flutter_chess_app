/// Data class to keep some data managed by database management system for all
/// cache models. This field of CacheModel is managed by the database management
/// system and should not be modified by the application.
class StorageModelMetaData {
  /// Creates a new [StorageModelMetaData]
  const StorageModelMetaData({
    required this.createAt,
    required this.updateAt,
  });

  /// Creates a new [StorageModelMetaData] from a JSON object
  factory StorageModelMetaData.fromJson(Map<String, dynamic> json) {
    return StorageModelMetaData(
      createAt: DateTime.parse(json['createdAt'] as String),
      updateAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// The creation date of the cache
  final DateTime createAt;

  /// The last update date of the cache
  final DateTime updateAt;

  /// Converts the [StorageModelMetaData] to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'createdAt': createAt.toIso8601String(),
      'updatedAt': updateAt.toIso8601String(),
    };
  }

  @override
  String toString() => 'CacheModelMetaData${toJson()}';
}
