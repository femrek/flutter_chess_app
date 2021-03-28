import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FindIpCubit extends Cubit<String> {
  FindIpCubit() : super("");
  
  static const platform = const MethodChannel('mychess/localIp');

  void defineIpAndPortNum(int port) async {
    String localIp = await _getLocalIp();
    emit('$localIp:$port');
  }

  Future<String> _getLocalIp() async {
    String localIp;
    try {
      final String result = await platform.invokeMethod('getLocalIp');
      localIp = result ?? 'ip not found';
    } on PlatformException catch (e) {
      localIp = 'ip not found';
      print(e);
    }
    return localIp;
  }

}