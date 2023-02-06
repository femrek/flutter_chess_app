import 'package:flutter/services.dart';

const platform = const MethodChannel('mychess/localIp');

Future<String> getLocalIp() async {
  return await platform.invokeMethod('getLocalIp');
}


