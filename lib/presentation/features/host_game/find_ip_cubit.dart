import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localchess/provider/platform/platform.dart';

class FindIpCubit extends Cubit<String> {
  FindIpCubit() : super("");
  
  void defineIpAndPortNum(int port) async {
    String localIp = await _getLocalIp();
    emit('$localIp:$port');
  }

  Future<String> _getLocalIp() async {
    String localIp;
    try {
      final String result = (await getLocalIp()).address;
      localIp = result ?? 'ip not found';
    } on PlatformException catch (e) {
      localIp = 'ip not found';
      print(e);
    }
    return localIp;
  }

}