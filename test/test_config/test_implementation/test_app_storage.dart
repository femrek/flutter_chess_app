import 'package:core/core.dart';
import 'package:localchess/product/storage/i_app_storage.dart';
import 'package:localchess/product/storage/model/game_save_storage_model.dart';
import 'package:localchess/product/storage/model/sender_information_storage_model.dart';

final class TestStorage implements IAppStorage {
  TestStorage({
    required this.gameSaveOperator,
    required this.senderInformationOperator,
  });

  @override
  Future<void> init() async {}

  @override
  StorageOperator<GameSaveStorageModel> gameSaveOperator;

  @override
  StorageOperator<DevicePropertiesStorageModel> senderInformationOperator;
}
