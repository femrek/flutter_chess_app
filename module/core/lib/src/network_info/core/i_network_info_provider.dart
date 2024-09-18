/// Interface for network info provider. Provides information about the
/// network connection of the device such as the inet.
abstract interface class INetworkInfoProvider {
  /// Get the inet address of the device.
  Future<String?> get inetAddress;

  /// Get the mask of the connected network.
  Future<String?> get submask;
}
