import 'package:core/core.dart';
import 'package:localchess/product/cache/i_app_cache.dart';
import 'package:localchess/product/cache/model/local_game_save_cache_model.dart';
import 'package:logger/logger.dart';

/// Manages caching operations
class AppCache implements IAppCache {
  /// Creates a new instance of [AppCache]
  AppCache({
    required CacheManager cacheManager,
    required Logger logger,
  })  : _cacheManager = cacheManager,
        _logger = logger;

  final CacheManager _cacheManager;

  /// The logger instance
  final Logger _logger;

  @override
  Future<void> init() async {
    await _cacheManager.init(items: [
      LocalGameSaveCacheModel.empty(),
    ]);
  }

  @override
  late final CacheOperator<LocalGameSaveCacheModel> localGameSaveOperator =
      HiveCacheOperator(logger: _logger);
}
