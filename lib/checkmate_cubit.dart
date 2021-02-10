import 'package:flutter_bloc/flutter_bloc.dart';

class CheckmateCubit extends Cubit<bool> {
  CheckmateCubit() : super(false);

  void checkmate() {
    emit(true);
  }

  void reset() {
    emit(false);
  }

}