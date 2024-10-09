import 'package:core/core.dart';

import 'sample_model.dart';

class SampleStorageModel implements StorageModel {
  SampleStorageModel({
    required this.data,
  });

  SampleStorageModel._internal({
    required this.data,
    this.metaData,
  });

  SampleStorageModel.empty() : data = SampleModel.empty();

  factory SampleStorageModel.fromJson(dynamic json) {
    if (json == null) {
      return SampleStorageModel.empty();
    }
    if (json is! Map) {
      return SampleStorageModel.empty();
    }
    if (json is! Map<String, dynamic>) {
      return SampleStorageModel.empty();
    }

    final dataJson = json['data'];
    if (dataJson == null) {
      return SampleStorageModel.empty();
    }
    if (dataJson is! Map) {
      return SampleStorageModel.empty();
    }
    if (dataJson is! Map<String, dynamic>) {
      return SampleStorageModel.empty();
    }

    final metaDataJson = json['metaData'];
    if (metaDataJson == null) {
      return SampleStorageModel.empty();
    }
    if (metaDataJson is! Map) {
      return SampleStorageModel.empty();
    }
    if (metaDataJson is! Map<String, dynamic>) {
      return SampleStorageModel.empty();
    }

    return SampleStorageModel._internal(
      data: SampleModel.fromJson(dataJson),
      metaData: StorageModelMetaData.fromJson(metaDataJson),
    );
  }

  final SampleModel data;

  @override
  StorageModelMetaData? metaData;

  @override
  StorageModel fromJson(dynamic json) {
    return SampleStorageModel.fromJson(json);
  }

  @override
  String get id => data.id;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data': data.toJson(),
      'metaData': metaData?.toJson(),
    };
  }
}
