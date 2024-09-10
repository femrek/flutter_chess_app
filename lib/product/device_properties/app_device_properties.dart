import 'package:core/core.dart';
import 'package:localchess/product/cache/model/sender_information_cache_model.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:uuid/uuid.dart';

/// To provide the device id, use this class.
class AppDeviceProperties implements IDeviceProperties {
  late final SenderInformation _senderInformation;

  @override
  Future<void> init() async {
    // fetch the device info from cache.
    final deviceInfoSaves = await G.appCache.senderInformationOperator.getAll();

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
      _senderInformation = SenderInformation(
        deviceId: const Uuid().v4(),
        deviceName: '',
      );

      G.logger.i('No device info found in cache, creating new one: '
          '$_senderInformation');
      G.appCache.senderInformationOperator.save(
        SenderInformationCacheModel(
          senderInformation: _senderInformation,
        ),
      );
      return;
    }

    // If there is exactly one device id, use it.
    _senderInformation = deviceInfoSaves.first.senderInformation;
    G.logger.i('Device id found in cache: $_senderInformation');
  }

  @override
  String get deviceId => _senderInformation.deviceId;

  @override
  String get deviceName => _senderInformation.deviceName;

  @override
  SenderInformation get senderInformation => _senderInformation;
}
