/// [IDependencyInjectionConfigurer] is the configuration interface for
/// dependency injection configures.
abstract interface class IDependencyInjectionConfigurer {
  /// Registers the instances of classes in the GetIt service locator.
  void init();

  /// Gets the instance of the class registered in the GetIt service locator.
  T call<T>();
}
