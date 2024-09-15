import 'package:core/core.dart';

/// Interface for initializing and getting the device properties such as the
/// device id.
abstract interface class IDeviceProperties {
  /// Fetch or create the device id.
  void init();

  /// Get the device information as a [SenderInformation] object.
  SenderInformation get senderInformation;

  /// Get the device id.
  String get deviceId;

  /// Get the device name taken from the user.
  String get deviceName;

  /// Update the device name.
  set deviceName(String name);
}
