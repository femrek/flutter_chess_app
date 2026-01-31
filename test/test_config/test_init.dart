import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/device_properties/app_device_properties.dart';
import 'package:localchess/product/device_properties/i_device_properties.dart';
import 'package:localchess/product/network/core/i_socket_configuration.dart';
import 'package:localchess/product/network/impl/app_socket_configuration.dart';
import 'package:localchess/product/storage/app_storage.dart';
import 'package:localchess/product/storage/i_app_storage.dart';
import 'package:localchess/product/storage/model/game_save_storage_model.dart';
import 'package:localchess/product/storage/model/sender_information_storage_model.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'test_implementation/test_app_storage.dart';
import 'test_implementation/test_storage_operator.dart';

abstract final class TestInit {
  static Future<void> initWithTestStorageImpl() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final logger = Logger();
    final cache = TestStorage(
      gameSaveOperator: TestStorageOperator<GameSaveStorageModel>(),
      senderInformationOperator:
          TestStorageOperator<DevicePropertiesStorageModel>(),
    );

    await GetIt.I.reset();
    GetIt.I.registerSingleton<Logger>(logger);
    GetIt.I.registerSingleton<IAppStorage>(cache);
    GetIt.I.registerSingleton<ISocketConfiguration>(AppSocketConfiguration());
    GetIt.I.registerSingleton<IDeviceProperties>(AppDeviceProperties());
    GetIt.I.registerSingleton<INetworkInfoProvider>(NetworkInfoProvider());

    // Initialize the cache
    await G.appStorage.init();
    G.deviceProperties.init();
  }

  static Future<void> initWithSharedPreferencesImpl() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Setup GetIt dependencies
    await GetIt.I.reset();
    GetIt.I.registerSingleton<Logger>(Logger(
      printer: PrettyPrinter(methodCount: 100),
    ));
    GetIt.I.registerSingleton<StorageManager>(
      const SharedPreferencesStorageManager(),
    );
    GetIt.I.registerSingleton<IAppStorage>(AppStorage(
      storageManager: GetIt.I<StorageManager>(),
      logger: GetIt.I<Logger>(),
    ));
    GetIt.I.registerSingleton<ISocketConfiguration>(AppSocketConfiguration());
    GetIt.I.registerSingleton<IDeviceProperties>(AppDeviceProperties());
    GetIt.I.registerSingleton<INetworkInfoProvider>(NetworkInfoProvider());

    // Initialize the cache
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await G.appStorage.init();
    G.deviceProperties.init();
  }
}
