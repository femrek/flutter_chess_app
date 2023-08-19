import 'package:network_info_plus/network_info_plus.dart';

class NetworkInfoProvider {
  NetworkInfo _networkInfo = NetworkInfo();

  /// returns inet address if wifi is connected. otherwise returns null.
  /// return format '192.168.0.20'
  Future<String?> getInetAddress() async {
    final String? inet = await _networkInfo.getWifiIP();
    return inet;
  }

  /// returns submask if wifi is connected. otherwise returns null.
  /// return format '255.255.255.0'
  Future<String?> getSubmask() async {
    final String? submask = await _networkInfo.getWifiSubmask();
    return submask;
  }

  // singleton
  static NetworkInfoProvider? _instance;

  factory NetworkInfoProvider() =>
      _instance ??= NetworkInfoProvider._internal();

  NetworkInfoProvider._internal();
}
