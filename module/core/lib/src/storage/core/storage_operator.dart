import 'package:core/src/storage/core/storage_model.dart';
import 'package:core/src/storage/sort/get_all_sort_enum.dart';

/// Cache operation interface
abstract interface class StorageOperator<T extends StorageModel> {
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
