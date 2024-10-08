import 'dart:io';

import 'package:localchess/product/network/core/model/address_on_network.dart';

/// The constant for the host configuration.
abstract final class HostConstant {
  /// The address on the network.
  static final AddressOnNetwork addressOnNetwork = AddressOnNetwork(
    address: InternetAddress.anyIPv4,
    port: 5600,
  );
}
