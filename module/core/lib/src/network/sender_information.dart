import 'package:flutter/foundation.dart';

/// A class that holds information about the sender of a message.
@immutable
class SenderInformation {
  /// Creates a new [SenderInformation] with the given [deviceId] and
  /// [deviceName].
  const SenderInformation({
    required this.deviceId,
    required this.deviceName,
  });

  /// Creates an empty [SenderInformation].
  const SenderInformation.empty()
      : deviceId = '',
        deviceName = '';

  /// Creates a new [SenderInformation] from a json map.
  factory SenderInformation.fromJson(Map<String, dynamic> json) {
    // validate the name field
    final name = json['name'];
    if (name == null) {
      throw const FormatException('The name is missing in the json');
    }
    if (name is! String) {
      throw const FormatException('The name is not a string');
    }

    // validate the deviceId field
    final deviceId = json['deviceId'];
    if (deviceId == null) {
      throw const FormatException('The deviceId is missing in the json');
    }
    if (deviceId is! String) {
      throw const FormatException('The deviceId is not a string');
    }

    return SenderInformation(
      deviceId: deviceId,
      deviceName: name,
    );
  }

  /// The device id of the sender.
  final String deviceId;

  /// The name of the sender.
  final String deviceName;

  /// Converts the object to a json map.
  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'name': deviceName,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SenderInformation &&
        other.deviceId == deviceId &&
        other.deviceName == deviceName;
  }

  @override
  int get hashCode => deviceId.hashCode ^ deviceName.hashCode;

  @override
  String toString() => 'SenderInformation${toJson()}';
}
