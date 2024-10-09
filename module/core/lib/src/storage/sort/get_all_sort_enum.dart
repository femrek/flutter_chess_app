import 'package:core/src/storage/core/storage_model.dart';
import 'package:core/src/storage/sort/extension/date_time_sorting_extension.dart';

/// The enum for sorting the [StorageModel] list when reading from the cache.
enum GetAllSortEnum {
  /// Sort by createAt in ascending order.
  createAtAsc(isAsc: true),

  /// Sort by createAt in descending order.
  createAtDesc(isAsc: false),

  /// Sort by updateAt in ascending order.
  updateAtAcs(isAsc: true),

  /// Sort by updateAt in descending order.
  updateAtDesc(isAsc: false),

  /// No sorting.
  none(isAsc: true),
  ;

  const GetAllSortEnum({required this.isAsc});

  /// Whether the sorting is in ascending order.
  final bool isAsc;

  /// Returns the value of the [StorageModel] based on the sorting type.
  dynamic valueOf(StorageModel cacheModel) {
    switch (this) {
      // createAt
      case GetAllSortEnum.createAtAsc:
      case GetAllSortEnum.createAtDesc:
        return cacheModel.metaData?.createAt;

      // updateAt
      case GetAllSortEnum.updateAtAcs:
      case GetAllSortEnum.updateAtDesc:
        return cacheModel.metaData?.updateAt;

      // none
      case GetAllSortEnum.none:
        return null;
    }
  }

  /// Returns true if the value should be inserted to the left of the nthModel.
  bool canInsertLeft({
    required StorageModel checking,
    required StorageModel? nthModel,
  }) {
    if (this == GetAllSortEnum.none) {
      return true;
    }

    final checkingValue = valueOf(checking);
    final nthValue = nthModel != null ? valueOf(nthModel) : null;

    assert(checkingValue != null, 'Checking value must not be null');
    assert(
      checking.runtimeType == nthModel.runtimeType,
      'Checking type must be the same as nthModel type',
    );
    assert(
      checkingValue.runtimeType == nthValue.runtimeType,
      'Checking value type must be the same as nthValue type',
    );

    if (nthValue == null) return true;

    switch (checkingValue.runtimeType) {
      case DateTime:
        checkingValue as DateTime;
        nthValue as DateTime;
        return _compare(checkingValue.compare(nthValue), isAsc);
      default:
        throw UnimplementedError(
          'Type ${checkingValue.runtimeType} is not implemented',
        );
    }
  }

  /// return true if the value should be inserted to the left by comparing
  /// result.
  bool _compare(num value, bool isAsc) {
    return isAsc ? value < 0 : value > 0;
  }
}
