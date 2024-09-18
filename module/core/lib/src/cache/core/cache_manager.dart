import 'package:core/src/cache/core/cache_model.dart';

/// Cache manager interface
abstract interface class CacheManager {
  /// Get ready to use the cache manager
  Future<void> init();

  /// Register a cache model type to the cache manager.
  void registerCacheModel<T extends CacheModel>(T model);

  /// Remove the stored cache
  void remove();

  /// Get the path to the cache
  String? get path;
}
