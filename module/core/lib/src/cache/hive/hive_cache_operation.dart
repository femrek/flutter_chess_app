import 'dart:async';

import 'package:core/core.dart';
import 'package:hive/hive.dart';

/// [CacheOperation] implementation using Hive
class HiveCacheOperation<T extends CacheModel> implements CacheOperation<T> {
  /// Constructor
  HiveCacheOperation() {
    _box = Hive.box<T>(name: T.toString());
  }

  late final Box<T> _box;

  @override
  FutureOr<T?> get(String id) {
    return _box.get(id);
  }

  @override
  FutureOr<List<T>> getAll() {
    return _box.getAll(_box.keys).where((e) => e != null).cast<T>().toList();
  }

  @override
  FutureOr<bool> remove(String id) {
    return _box.delete(id);
  }

  @override
  FutureOr<void> removeAll() {
    _box.deleteAll(_box.keys);
  }

  @override
  FutureOr<void> save(T item) {
    _box.put(item.id, item);
  }

  @override
  FutureOr<void> saveAll(List<T> items) {
    for (final item in items) {
      _box.put(item.id, item);
    }
  }

  @override
  FutureOr<void> update(T item) {
    _box.put(item.id, item);
  }

  @override
  FutureOr<void> updateAll(List<T> items) {
    for (final item in items) {
      _box.put(item.id, item);
    }
  }
}
