import 'package:core/src/storage/core/storage_model.dart';

/// Cache manager interface
abstract interface class StorageManager {
  /// Get ready to use the cache manager
  Future<void> init();

  /// Register a storage model type to the storage manager.
  void registerStorageModel<T extends StorageModel>(T model);

  /// Remove the stored cache
  void remove();

  /// Get the path to the cache
  String? get path;
}
