import 'package:flutter/material.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/device_properties/i_device_properties.dart';
import 'package:localchess/product/network/core/model/sender_information.dart';
import 'package:localchess/product/storage/model/sender_information_storage_model.dart';
import 'package:uuid/uuid.dart';

/// To provide the device id, use this class.
class AppDeviceProperties implements IDeviceProperties {
  late DevicePropertiesStorageModel _storageModel;

  @override
  void init() {
    // fetch the device info from storage.
    final deviceInfoSaves = G.appStorage.senderInformationOperator.getAll();

    // If there are more than one device info, log an error and remove all
    // except the first one.
    if (deviceInfoSaves.length > 1) {
      G.logger.e('More than one device id found in storage');

      // Remove all device ids except the first one.
      final first = deviceInfoSaves.first;
      G.appStorage.senderInformationOperator.removeAll();
      G.appStorage.senderInformationOperator.save(first);
      return;
    }

    // If there are no device ids, create a new one and save it.
    if (deviceInfoSaves.isEmpty) {
      _storageModel = DevicePropertiesStorageModel(
        senderInformation: SenderInformation(
          deviceId: const Uuid().v4(),
          deviceName: '',
        ),
        themeMode: ThemeMode.system,
      );

      G.logger.i('No device info found in storage, creating new one: '
          '$_storageModel');

      G.appStorage.senderInformationOperator.save(_storageModel);
      return;
    }

    // If there is exactly one device id, use it.
    _storageModel = deviceInfoSaves.first;
    G.logger.i('Device id found in storage: $_storageModel');
  }

  @override
  String get deviceId => _storageModel.senderInformation.deviceId;

  @override
  String get deviceName => _storageModel.senderInformation.deviceName;

  @override
  SenderInformation get senderInformation => _storageModel.senderInformation;

  @override
  ThemeMode get themeMode => _storageModel.themeMode;

  @override
  set deviceName(String name) {
    final trimmedName = name.trim();
    G.appStorage.senderInformationOperator.update(
      _storageModel = _storageModel.copyWith(
        senderInformation: _storageModel.senderInformation.copyWith(
          deviceName: trimmedName,
        ),
      ),
    );
  }

  @override
  set themeMode(ThemeMode theme) {
    G.appStorage.senderInformationOperator.update(
      _storageModel = _storageModel.copyWith(
        themeMode: theme,
      ),
    );
  }
}
