import 'package:flutter/material.dart';
import 'package:localchess/product/network/core/model/sender_information.dart';

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

  /// Get the saved theme mode.
  ThemeMode get themeMode;

  /// Update the device name.
  set deviceName(String name);

  /// Update the theme mode.
  set themeMode(ThemeMode theme);
}
