import 'dart:io';

/// Represents an address on the network.
class AddressOnNetwork {
  /// Creates an object of [AddressOnNetwork].
  const AddressOnNetwork({
    required this.address,
    required this.port,
  });

  /// The address of the network. Usually keeps the local IP address.
  final InternetAddress address;

  /// The port of the running service.
  final int port;

  @override
  String toString() {
    return 'AddressOnNetwork{$address:$port}';
  }
}
