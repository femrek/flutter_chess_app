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
  Future<void> init({required List<CacheModel> items}) async {
    final dir = _path ?? (await getApplicationDocumentsDirectory()).path;
    Directory(dir).createSync(recursive: true);
    Hive.defaultDirectory = dir;

    for (final item in items) {
      Hive.registerAdapter(item.runtimeType.toString(), item.fromDynamicJson);
    }
  }

  /// Removes the cache.
  @override
  Future<void> remove() async {
    Hive.deleteAllBoxesFromDisk();
  }

  /// The path to the cache.
  @override
  String? get path => Hive.defaultDirectory;
}
