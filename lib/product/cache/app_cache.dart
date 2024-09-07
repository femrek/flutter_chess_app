import 'package:core/core.dart';
import 'package:localchess/product/cache/i_app_cache.dart';
import 'package:localchess/product/cache/model/game_save_cache_model.dart';
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
      GameSaveCacheModel.empty(),
    ]);
  }

  @override
  late final CacheOperator<GameSaveCacheModel> gameSaveOperator =
      HiveCacheOperator(logger: _logger);
}
