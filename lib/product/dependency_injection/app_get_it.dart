import 'package:core/core.dart';
import 'package:get_it/get_it.dart';

/// [AppGetIt] is the implementation of [IDependencyInjectionConfigurer] for
/// production.
abstract class AppGetIt {
  /// Singleton instance of [IDependencyInjectionConfigurer]
  static IDependencyInjectionConfigurer I = _AppGetIt();
}

class _AppGetIt implements IDependencyInjectionConfigurer {
  final GetIt _getIt = GetIt.instance;

  @override
  void init() {}

  @override
  T call<T>() => _getIt<T>();
}
