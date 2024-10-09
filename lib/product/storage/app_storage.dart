import 'package:core/core.dart';
import 'package:localchess/product/storage/i_app_storage.dart';
import 'package:localchess/product/storage/model/game_save_storage_model.dart';
import 'package:localchess/product/storage/model/sender_information_storage_model.dart';
import 'package:logger/logger.dart';

/// Manages storage operations
class AppStorage implements IAppStorage {
  /// Creates a new instance of [AppStorage]
  AppStorage({
    required StorageManager storageManager,
    required Logger logger,
  })  : _storageManager = storageManager,
        _logger = logger;

  final StorageManager _storageManager;

  /// The logger instance
  final Logger _logger;

  @override
  Future<void> init() async {
    await _storageManager.init();

    _storageManager
      ..registerStorageModel<GameSaveStorageModel>(GameSaveStorageModel.empty())
      ..registerStorageModel<DevicePropertiesStorageModel>(
          DevicePropertiesStorageModel.empty());
  }

  @override
  late final StorageOperator<GameSaveStorageModel> gameSaveOperator =
      HiveStorageOperator<GameSaveStorageModel>(logger: _logger);

  @override
  late final StorageOperator<DevicePropertiesStorageModel>
      senderInformationOperator =
      HiveStorageOperator<DevicePropertiesStorageModel>(logger: _logger);
}
