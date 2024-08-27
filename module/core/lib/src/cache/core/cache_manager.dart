import 'package:core/core.dart';

/// Cache manager interface
abstract interface class CacheManager {
  /// Get ready to use the cache manager
  Future<void> init({required List<CacheModel> items});

  /// Remove the stored cache
  void remove();

  /// Get the path to the cache
  String? get path;
}
