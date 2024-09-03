import 'package:core/core.dart';
import 'package:localchess/product/cache/model/local_game_save_cache_model.dart';

///
abstract interface class IAppCache {
  /// Initializes the cache
  Future<void> init();

  /// The operator instance for performing cache operations over
  /// [LocalGameSaveCacheModel].
  CacheOperator<LocalGameSaveCacheModel> get localGameSaveOperator;
}
