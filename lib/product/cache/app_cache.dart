import 'package:core/core.dart';
import 'package:localchess/product/cache/model/local_game_save_cache_model.dart';
import 'package:logger/logger.dart';

/// Manages caching operations
class AppCache {
  /// Creates a new instance of [AppCache]
  AppCache({
    required CacheManager cacheManager,
    required this.logger,
  }) : _cacheManager = cacheManager;

  final CacheManager _cacheManager;

  /// The logger instance
  final Logger logger;

  /// Initializes the cache
  Future<void> init() async {
    await _cacheManager.init(items: [
      LocalGameSaveCacheModel.empty(),
    ]);
  }

  /// The operator instance for performing cache operations over
  /// [LocalGameSaveCacheModel].
  late final CacheOperator<LocalGameSaveCacheModel> localGameSaveOperator =
      HiveCacheOperator(logger: logger);
}
