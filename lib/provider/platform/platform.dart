import 'package:flutter/services.dart';
import 'package:localchess/provider/platform/model/local_ip.dart';

const platform = const MethodChannel('mychess/localIp');

Future<LocalIp> getLocalIp() async {
  final map = await platform.invokeMethod('getLocalIp');
  final LocalIp data = LocalIp.fromMap(Map<String, dynamic>.from(map));
  return data;
}
