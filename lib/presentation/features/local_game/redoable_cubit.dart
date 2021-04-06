import 'package:flutter_bloc/flutter_bloc.dart';

class RedoableCubit extends Cubit<bool> {
  RedoableCubit() : super(false);

  void redoable() => emit(true);
  void nonRedoable() => emit(false);
}