import 'dart:async';

import 'package:core/src/cache/core/cache_model.dart';

/// Cache operation interface
abstract interface class CacheOperator<T extends CacheModel> {
  /// Get the cache
  FutureOr<T?> get(String id);

  /// Get all caches
  FutureOr<List<T>> getAll();

  /// Save the cache
  FutureOr<void> save(T item);

  /// Save all caches
  FutureOr<void> saveAll(List<T> items);

  /// Update the cache
  FutureOr<void> update(T item);

  /// Update all caches
  FutureOr<void> updateAll(List<T> items);

  /// Remove the cache
  FutureOr<bool> remove(String id);

  /// Remove all caches
  FutureOr<void> removeAll();
}
