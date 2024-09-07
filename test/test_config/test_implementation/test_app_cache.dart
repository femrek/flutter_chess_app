import 'package:core/core.dart';
import 'package:localchess/product/cache/i_app_cache.dart';
import 'package:localchess/product/cache/model/game_save_cache_model.dart';

final class TestCache implements IAppCache {
  TestCache({required this.gameSaveOperator});

  @override
  Future<void> init() async {}

  @override
  CacheOperator<GameSaveCacheModel> gameSaveOperator;
}
