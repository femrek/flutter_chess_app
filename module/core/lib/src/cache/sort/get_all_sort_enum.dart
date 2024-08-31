import 'package:core/core.dart';
import 'package:core/src/cache/sort/extension/date_time_sorting_extension.dart';

enum GetAllSortEnum {
  createAtAsc(isAsc: true),
  createAtDesc(isAsc: false),
  updateAtAcs(isAsc: true),
  updateAtDesc(isAsc: false),
  none(isAsc: true),
  ;

  const GetAllSortEnum({required this.isAsc});

  final bool isAsc;

  dynamic valueOf(CacheModel cacheModel) {
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

  bool canInsertLeft({
    required CacheModel checking,
    required CacheModel? nthModel,
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
        return _a(checkingValue.compare(nthValue), isAsc);
      default:
        throw UnimplementedError(
          'Type ${checkingValue.runtimeType} is not implemented',
        );
    }
  }

  bool _a(num value, bool isAsc) {
    return isAsc ? value < 0 : value > 0;
  }
}
