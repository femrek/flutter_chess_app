/// Data class to keep some data managed by database management system for all
/// cache models. This field of CacheModel is managed by the database management
/// system and should not be modified by the application.
class CacheModelMetaData {
  /// Creates a new [CacheModelMetaData]
  const CacheModelMetaData({
    required this.createAt,
    required this.updateAt,
  });

  /// Creates a new [CacheModelMetaData] from a JSON object
  factory CacheModelMetaData.fromJson(Map<String, dynamic> json) {
    return CacheModelMetaData(
      createAt: DateTime.parse(json['createdAt'] as String),
      updateAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// The creation date of the cache
  final DateTime createAt;

  /// The last update date of the cache
  final DateTime updateAt;

  /// Converts the [CacheModelMetaData] to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'createdAt': createAt.toIso8601String(),
      'updatedAt': updateAt.toIso8601String(),
    };
  }

  @override
  String toString() => 'CacheModelMetaData${toJson()}';
}
