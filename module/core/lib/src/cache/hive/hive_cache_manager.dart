import 'dart:io';

import 'package:core/core.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

/// Hive implementation of the cache manager.
final class HiveCacheManager implements CacheManager {
  /// Initializes the cache.
  /// [path] is the path to the cache. 'getApplicationDocumentsDirectory' is
  /// used by default.
  HiveCacheManager({String? path}) : _path = path;

  final String? _path;

  @override
  Future<void> init() async {
    final dir = _path ?? (await getApplicationDocumentsDirectory()).path;
    Directory(dir).createSync(recursive: true);
    Hive.defaultDirectory = dir;
  }

  @override
  void registerCacheModel<T extends CacheModel>(T modelSample) {
    Hive.registerAdapter<T>(
      modelSample.runtimeType.toString(),
      (json) => modelSample.fromJson(json) as T,
    );
  }

  @override
  void remove() {
    Hive.deleteAllBoxesFromDisk();
  }

  @override
  String? get path => Hive.defaultDirectory;
}
