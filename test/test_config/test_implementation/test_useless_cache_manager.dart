import 'package:core/core.dart';

final class TestCacheManager implements CacheManager {
  @override
  Future<void> init({required List<CacheModel> items}) async {
    // Do nothing
  }

  @override
  void remove() {
    // Do nothing
  }

  @override
  String? get path => '';
}
