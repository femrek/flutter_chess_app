import 'package:core/core.dart';
import 'package:localchess/product/dependency_injection/get.dart';

/// Cache model for device id
final class SenderInformationCacheModel implements CacheModel {
  /// Creates a new [SenderInformationCacheModel]
  SenderInformationCacheModel({
    required this.senderInformation,
  });

  SenderInformationCacheModel._internal({
    required this.senderInformation,
    this.metaData,
  });

  /// Creates an empty [SenderInformationCacheModel]. Use to create a sample
  /// model.
  SenderInformationCacheModel.empty()
      : senderInformation = const SenderInformation.empty();

  /// The model that contains the device and user information to send messages.
  final SenderInformation senderInformation;

  @override
  String get id => senderInformation.deviceId;

  @override
  SenderInformationCacheModel fromJson(dynamic json) {
    // log and return empty if json is not valid.
    if (json == null) {
      G.logger.e('json is null');
      return SenderInformationCacheModel.empty();
    }
    if (json is! Map) {
      G.logger.e('json is not a Map');
      return SenderInformationCacheModel.empty();
    }
    if (json is! Map<String, dynamic>) {
      G.logger.e('json is not a Map<String, dynamic>');
      return SenderInformationCacheModel.empty();
    }

    // validate the metaData. log and return empty, if metaData is not valid.
    final metaDataJson = json['metaData'];
    if (metaDataJson == null) {
      G.logger.e('metaData is null');
      return SenderInformationCacheModel.empty();
    }
    if (metaDataJson is! Map) {
      G.logger.e('metaData is not a Map');
      return SenderInformationCacheModel.empty();
    }
    if (metaDataJson is! Map<String, dynamic>) {
      G.logger.e('metaData is not a Map<String, dynamic>');
      return SenderInformationCacheModel.empty();
    }

    // validate the senderInformation. log and return empty, if
    // senderInformation is not valid.
    final senderInformation = json['senderInformation'];
    if (senderInformation == null) {
      G.logger.e('senderInformation is null');
      return SenderInformationCacheModel.empty();
    }
    if (senderInformation is! Map) {
      G.logger.e('senderInformation is not a Map');
      return SenderInformationCacheModel.empty();
    }
    if (senderInformation is! Map<String, dynamic>) {
      G.logger.e('senderInformation is not a Map<String, dynamic>');
      return SenderInformationCacheModel.empty();
    }

    return SenderInformationCacheModel._internal(
      senderInformation: SenderInformation.fromJson(senderInformation),
      metaData: CacheModelMetaData.fromJson(metaDataJson),
    );
  }

  @override
  CacheModelMetaData? metaData;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': senderInformation.deviceId,
      'senderInformation': senderInformation.toJson(),
      'metaData': metaData?.toJson(),
    };
  }
}
