import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localchess/provider/network_info_provider.dart';

class FindIpCubit extends Cubit<String> {
  FindIpCubit() : super("");

  void defineIpAndPortNum(int port) async {
    String localIp = await _getLocalIp();
    emit('$localIp:$port');
  }

  Future<String> _getLocalIp() async {
    String localIp;
    final String? result = await NetworkInfoProvider().getInetAddress();
    localIp = result ?? 'ip not found';
    return localIp;
  }
}
