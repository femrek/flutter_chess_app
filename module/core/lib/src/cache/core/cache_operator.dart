import 'package:core/src/cache/core/cache_model.dart';
import 'package:core/src/cache/sort/get_all_sort_enum.dart';

/// Cache operation interface
abstract interface class CacheOperator<T extends CacheModel> {
  /// Get the cache
  T? get(String id);

  /// Get all caches
  List<T> getAll({GetAllSortEnum sort});

  /// Save the cache
  T save(T item);

  /// Save all caches
  List<T> saveAll(List<T> items);

  /// Update the cache
  T update(T item);

  /// Update all caches
  List<T> updateAll(List<T> items);

  /// Remove the cache
  bool remove(String id);

  /// Remove all caches
  void removeAll();
}
