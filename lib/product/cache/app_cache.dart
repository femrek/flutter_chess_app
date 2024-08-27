import 'package:core/core.dart';
import 'package:localchess/product/cache/model/local_game_save_cache_model.dart';

/// Manages caching operations
class AppCache {
  /// Creates a new instance of [AppCache]
  AppCache({required CacheManager cacheManager}) : _cacheManager = cacheManager;

  final CacheManager _cacheManager;

  /// Initializes the cache
  Future<void> init() async {
    await _cacheManager.init(items: [
      LocalGameSaveCacheModel.empty(),
    ]);
  }

  /// The operator instance for performing cache operations over
  /// [LocalGameSaveCacheModel].
  late final CacheOperator<LocalGameSaveCacheModel> localGameSaveOperator =
      HiveCacheOperator();
}
