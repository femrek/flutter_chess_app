import 'package:flutter_bloc/flutter_bloc.dart';

class HostTurnCubit extends Cubit<bool> {
  HostTurnCubit() : super(true);

  whiteTurn(bool isWhiteTurn) {
    emit(isWhiteTurn);
  }
}