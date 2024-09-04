import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:localchess/product/cache/app_cache.dart';
import 'package:localchess/product/cache/i_app_cache.dart';
import 'package:localchess/product/cache/model/local_game_save_cache_model.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:logger/logger.dart';

import 'hive/hive_common.dart';
import 'test_implementation/test_app_cache.dart';
import 'test_implementation/test_cache_operator.dart';

abstract final class TestInit {
  static Future<void> initWithTestCacheImpl() async {
    final logger = Logger();
    final cacheOperator = TestCacheOperator<LocalGameSaveCacheModel>();
    final cache = TestCache(localGameSaveOperator: cacheOperator);

    await GetIt.I.reset();
    GetIt.I.registerSingleton<Logger>(logger);
    GetIt.I.registerSingleton<IAppCache>(cache);

    // Initialize the cache
    await initHiveTests();
    await G.appCache.init();
  }

  static Future<void> initWithHiveImpl() async {
    // Setup GetIt dependencies
    await GetIt.I.reset();
    GetIt.I.registerSingleton<Logger>(Logger());
    GetIt.I.registerSingleton<CacheManager>(
      HiveCacheManager(path: 'test/cache/hive'),
    );
    GetIt.I.registerSingleton<IAppCache>(AppCache(
      cacheManager: GetIt.I<CacheManager>(),
      logger: GetIt.I<Logger>(),
    ));

    // Initialize the cache
    await initHiveTests();
    await G.appCache.init();
  }
}
