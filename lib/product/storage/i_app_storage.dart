import 'package:core/core.dart';
import 'package:localchess/product/storage/model/game_save_storage_model.dart';
import 'package:localchess/product/storage/model/sender_information_storage_model.dart';

/// Interface to init and provide storage operators
abstract interface class IAppStorage {
  /// Initializes the cache
  Future<void> init();

  /// The operator instance for performing cache operations over
  /// [GameSaveStorageModel].
  StorageOperator<GameSaveStorageModel> get gameSaveOperator;

  /// The operator instance for performing cache operations over
  /// [DevicePropertiesStorageModel].
  StorageOperator<DevicePropertiesStorageModel> get senderInformationOperator;
}
