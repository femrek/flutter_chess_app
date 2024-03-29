import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localchess/data/model/turn_model.dart';

class HostTurnCubit extends Cubit<TurnModel> {
  HostTurnCubit() : super(TurnModel());

  changeState(bool isWhiteTurn, bool checkmate) {
    emit(TurnModel(
      isWhiteTurn: isWhiteTurn,
      checkmate: checkmate,
    ));
  }
}