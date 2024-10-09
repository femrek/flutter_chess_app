import 'package:core/core.dart';

final class TestStorageManager implements StorageManager {
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
  void registerStorageModel<T extends StorageModel>(T model) {
    // Do nothing
  }
}
