import 'package:core/core.dart';

final class TestCacheManager implements CacheManager {
  @override
  Future<void> init() async {
    // Do nothing
  }

  @override
  void remove() {
    // Do nothing
  }

  @override
  String? get path => '';

  @override
  void registerCacheModel<T extends CacheModel>(T model) {
    // Do nothing
  }
}
