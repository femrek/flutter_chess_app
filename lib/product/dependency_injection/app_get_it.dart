import 'package:core/core.dart';
import 'package:get_it/get_it.dart';

/// [AppGetIt] is the implementation of [IDependencyInjectionConfiguration] for
/// production.
abstract class AppGetIt {
  /// Singleton instance of [IDependencyInjectionConfiguration]
  static IDependencyInjectionConfiguration I = _AppGetIt();
}

class _AppGetIt implements IDependencyInjectionConfiguration {
  final GetIt _getIt = GetIt.instance;

  @override
  void init() {}

  @override
  T call<T>() => _getIt<T>();
}
