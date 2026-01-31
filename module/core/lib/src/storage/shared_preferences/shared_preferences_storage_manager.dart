import 'package:core/core.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A [StorageManager] implementation using [SharedPreferences].
final class SharedPreferencesStorageManager implements StorageManager {
  /// Initializes the cache with [SharedPreferences].
  const SharedPreferencesStorageManager();

  @override
  Future<void> init() async {
    SharedPreferencesStorageOperator.sp = await SharedPreferences.getInstance();
  }

  @override
  void registerStorageModel<T extends StorageModel>(T modelSample) {
    SharedPreferencesStorageOperator.typeKeyMap[T] = modelSample;
  }

  @override
  void remove() {
    SharedPreferences.getInstance().then((prefs) => prefs.clear());
  }
}
