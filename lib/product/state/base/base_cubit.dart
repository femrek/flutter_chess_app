import 'package:flutter_bloc/flutter_bloc.dart';

/// The base class for all Cubits in the application.
abstract class BaseCubit<T> extends Cubit<T> {
  /// The base class for all Cubits in the application.
  BaseCubit(super.state);

  @override
  void emit(T state) {
    if (isClosed) return;
    super.emit(state);
  }
}
