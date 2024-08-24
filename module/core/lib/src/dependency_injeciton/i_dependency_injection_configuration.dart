/// [IDependencyInjectionConfiguration] is the configuration interface for the GetIt
/// service locator in the production environment. Instances of classes are
/// registered in the GetIt service locator in the [init] method.
abstract interface class IDependencyInjectionConfiguration {
  /// Registers the instances of classes in the GetIt service locator.
  void init();

  /// Gets the instance of the class registered in the GetIt service locator.
  T call<T>();
}
