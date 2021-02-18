import 'package:flutter_bloc/flutter_bloc.dart';

class HostCheckmateCubit extends Cubit<bool> {
  HostCheckmateCubit() : super(false);

  void checkmate() {
    emit(true);
  }

  void reset() {
    emit(false);
  }

}