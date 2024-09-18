import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:localchess/product/cache/model/sender_information_cache_model.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:uuid/uuid.dart';

/// To provide the device id, use this class.
class AppDeviceProperties implements IDeviceProperties {
  late DevicePropertiesCacheModel _cacheModel;

  @override
  void init() {
    // fetch the device info from cache.
    final deviceInfoSaves = G.appCache.senderInformationOperator.getAll();

    // If there are more than one device info, log an error and remove all
    // except the first one.
    if (deviceInfoSaves.length > 1) {
      G.logger.e('More than one device id found in cache');

      // Remove all device ids except the first one.
      final first = deviceInfoSaves.first;
      G.appCache.senderInformationOperator.removeAll();
      G.appCache.senderInformationOperator.save(first);
      return;
    }

    // If there are no device ids, create a new one and save it.
    if (deviceInfoSaves.isEmpty) {
      _cacheModel = DevicePropertiesCacheModel(
        senderInformation: SenderInformation(
          deviceId: const Uuid().v4(),
          deviceName: '',
        ),
        themeMode: ThemeMode.system,
      );

      G.logger.i('No device info found in cache, creating new one: '
          '$_cacheModel');

      G.appCache.senderInformationOperator.save(_cacheModel);
      return;
    }

    // If there is exactly one device id, use it.
    _cacheModel = deviceInfoSaves.first;
    G.logger.i('Device id found in cache: $_cacheModel');
  }

  @override
  String get deviceId => _cacheModel.senderInformation.deviceId;

  @override
  String get deviceName => _cacheModel.senderInformation.deviceName;

  @override
  SenderInformation get senderInformation => _cacheModel.senderInformation;

  @override
  ThemeMode get themeMode => _cacheModel.themeMode;

  @override
  set deviceName(String name) {
    G.appCache.senderInformationOperator.update(
      _cacheModel = _cacheModel.copyWith(
        senderInformation: _cacheModel.senderInformation.copyWith(
          deviceName: name,
        ),
      ),
    );
  }

  @override
  set themeMode(ThemeMode theme) {
    G.appCache.senderInformationOperator.update(
      _cacheModel = _cacheModel.copyWith(
        themeMode: theme,
      ),
    );
  }
}
