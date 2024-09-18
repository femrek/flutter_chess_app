import 'package:core/core.dart';
import 'package:network_info_plus/network_info_plus.dart';

/// Network info provider implementation.
class NetworkInfoProvider implements INetworkInfoProvider {
  /// Creates a new [NetworkInfoProvider] instance.
  NetworkInfoProvider();

  final NetworkInfo _networkInfo = NetworkInfo();

  @override
  Future<String?> get inetAddress async {
    return _networkInfo.getWifiIP();
  }

  @override
  Future<String?> get submask async {
    return _networkInfo.getWifiSubmask();
  }
}
