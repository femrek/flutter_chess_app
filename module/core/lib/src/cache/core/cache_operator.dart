import 'dart:async';

import 'package:core/src/cache/core/cache_model.dart';
import 'package:core/src/cache/sort/get_all_sort_enum.dart';

/// Cache operation interface
abstract interface class CacheOperator<T extends CacheModel> {
  /// Get the cache
  FutureOr<T?> get(String id);

  /// Get all caches
  FutureOr<List<T>> getAll({GetAllSortEnum sort});

  /// Save the cache
  FutureOr<T> save(T item);

  /// Save all caches
  FutureOr<List<T>> saveAll(List<T> items);

  /// Update the cache
  FutureOr<T> update(T item);

  /// Update all caches
  FutureOr<List<T>> updateAll(List<T> items);

  /// Remove the cache
  FutureOr<bool> remove(String id);

  /// Remove all caches
  FutureOr<void> removeAll();
}
