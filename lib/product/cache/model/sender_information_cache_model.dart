import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/network/core/model/sender_information.dart';
import 'package:localchess/product/util/theme_mode_json_converter.dart';

/// Cache model for device id
final class DevicePropertiesCacheModel implements CacheModel {
  /// Creates a new [DevicePropertiesCacheModel]
  DevicePropertiesCacheModel({
    required this.senderInformation,
    required this.themeMode,
  });

  DevicePropertiesCacheModel._internal({
    required this.senderInformation,
    required this.themeMode,
    this.metaData,
  });

  /// Creates an empty [DevicePropertiesCacheModel]. Use to create a sample
  /// model.
  DevicePropertiesCacheModel.empty()
      : senderInformation = const SenderInformation.empty(),
        themeMode = ThemeMode.system;

  /// The model that contains the device and user information to send messages.
  final SenderInformation senderInformation;

  /// The theme option the user has selected.
  final ThemeMode themeMode;

  @override
  String get id => senderInformation.deviceId;

  @override
  DevicePropertiesCacheModel fromJson(dynamic json) {
    // log and return empty if json is not valid.
    if (json == null) {
      G.logger.e('json is null');
      return DevicePropertiesCacheModel.empty();
    }
    if (json is! Map) {
      G.logger.e('json is not a Map');
      return DevicePropertiesCacheModel.empty();
    }
    if (json is! Map<String, dynamic>) {
      G.logger.e('json is not a Map<String, dynamic>');
      return DevicePropertiesCacheModel.empty();
    }

    // validate the metaData. log and return empty, if metaData is not valid.
    final metaDataJson = json['metaData'];
    if (metaDataJson == null) {
      G.logger.e('metaData is null');
      return DevicePropertiesCacheModel.empty();
    }
    if (metaDataJson is! Map) {
      G.logger.e('metaData is not a Map');
      return DevicePropertiesCacheModel.empty();
    }
    if (metaDataJson is! Map<String, dynamic>) {
      G.logger.e('metaData is not a Map<String, dynamic>');
      return DevicePropertiesCacheModel.empty();
    }

    // validate the senderInformation. log and return empty, if
    // senderInformation is not valid.
    final senderInformation = json['senderInformation'];
    if (senderInformation == null) {
      G.logger.e('senderInformation is null');
      return DevicePropertiesCacheModel.empty();
    }
    if (senderInformation is! Map) {
      G.logger.e('senderInformation is not a Map');
      return DevicePropertiesCacheModel.empty();
    }
    if (senderInformation is! Map<String, dynamic>) {
      G.logger.e('senderInformation is not a Map<String, dynamic>');
      return DevicePropertiesCacheModel.empty();
    }

    // validate the themeMode. log and return empty, if themeMode is not valid.
    final themeMode = json['themeMode'];
    if (themeMode is! String?) {
      G.logger.e('themeMode is not a String');
      return DevicePropertiesCacheModel.empty();
    }

    return DevicePropertiesCacheModel._internal(
      senderInformation: SenderInformation.fromJson(senderInformation),
      themeMode: ThemeModeJsonConverter.fromJson(themeMode),
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
      'themeMode': themeMode.toJson(),
      'metaData': metaData?.toJson(),
    };
  }

  /// Creates a new [DevicePropertiesCacheModel] with the given parameters.
  DevicePropertiesCacheModel copyWith({
    SenderInformation? senderInformation,
    ThemeMode? themeMode,
  }) {
    return DevicePropertiesCacheModel._internal(
      senderInformation: senderInformation ?? this.senderInformation,
      themeMode: themeMode ?? this.themeMode,
      metaData: metaData,
    );
  }
}
