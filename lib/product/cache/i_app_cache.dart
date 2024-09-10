import 'package:core/core.dart';
import 'package:localchess/product/cache/model/game_save_cache_model.dart';
import 'package:localchess/product/cache/model/sender_information_cache_model.dart';

///
abstract interface class IAppCache {
  /// Initializes the cache
  Future<void> init();

  /// The operator instance for performing cache operations over
  /// [GameSaveCacheModel].
  CacheOperator<GameSaveCacheModel> get gameSaveOperator;

  /// The operator instance for performing cache operations over
  /// [SenderInformationCacheModel].
  CacheOperator<SenderInformationCacheModel> get senderInformationOperator;
}
