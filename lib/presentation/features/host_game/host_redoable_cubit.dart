import 'package:flutter_bloc/flutter_bloc.dart';

class HostRedoableCubit extends Cubit<bool> {
  HostRedoableCubit() : super(false);
  
  void redoable() => emit(true);
  void nonRedoable() => emit(false);
}