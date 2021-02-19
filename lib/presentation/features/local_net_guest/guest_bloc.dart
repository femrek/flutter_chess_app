import 'package:flutter_bloc/flutter_bloc.dart';

import 'guest_event.dart';
import 'guest_state.dart';

class GuestBloc extends Bloc<GuestEvent, GuestState> {
  GuestBloc() : super(GuestInitialState());

  @override
  Stream<GuestState> mapEventToState(GuestEvent event) async* {

  }
}