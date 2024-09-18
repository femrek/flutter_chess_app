import 'package:core/core.dart';

/// The data class to store the network scan result.
class NetworkScanResult {
  /// Creates the [NetworkScanResult] instance.
  NetworkScanResult({
    required this.hostInformation,
    required this.address,
  });

  /// The information about the host.
  final SenderInformation hostInformation;

  /// The address of the host.
  final AddressOnNetwork address;
}
