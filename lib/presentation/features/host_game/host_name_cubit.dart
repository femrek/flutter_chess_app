import 'package:flutter_bloc/flutter_bloc.dart';

class HostNameCubit extends Cubit<String> {
  HostNameCubit() : super('');

  defineHostName(String host, int port) {
    emit('$host:$port');
  }
}