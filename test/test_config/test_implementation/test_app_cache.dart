import 'package:core/core.dart';
import 'package:localchess/product/cache/i_app_cache.dart';
import 'package:localchess/product/cache/model/local_game_save_cache_model.dart';

final class TestCache implements IAppCache {
  TestCache({required this.localGameSaveOperator});

  @override
  Future<void> init() async {}

  @override
  CacheOperator<LocalGameSaveCacheModel> localGameSaveOperator;
}
