import 'package:flutter_bloc/flutter_bloc.dart';

class TurnCubit extends Cubit<bool> {
  TurnCubit() : super(true);

  whiteTurn(bool isWhiteTurn) {
    emit(isWhiteTurn);
  }
}