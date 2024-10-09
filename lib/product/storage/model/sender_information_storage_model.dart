import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/network/core/model/sender_information.dart';
import 'package:localchess/product/util/theme_mode_json_converter.dart';

/// Cache model for device id
final class DevicePropertiesStorageModel implements StorageModel {
  /// Creates a new [DevicePropertiesStorageModel]
  DevicePropertiesStorageModel({
    required this.senderInformation,
    required this.themeMode,
  });

  DevicePropertiesStorageModel._internal({
    required this.senderInformation,
    required this.themeMode,
    this.metaData,
  });

  /// Creates an empty [DevicePropertiesStorageModel]. Use to create a sample
  /// model.
  DevicePropertiesStorageModel.empty()
      : senderInformation = const SenderInformation.empty(),
        themeMode = ThemeMode.system;

  /// The model that contains the device and user information to send messages.
  final SenderInformation senderInformation;

  /// The theme option the user has selected.
  final ThemeMode themeMode;

  @override
  String get id => senderInformation.deviceId;

  @override
  DevicePropertiesStorageModel fromJson(dynamic json) {
    // log and return empty if json is not valid.
    if (json == null) {
      G.logger.e('json is null');
      return DevicePropertiesStorageModel.empty();
    }
    if (json is! Map) {
      G.logger.e('json is not a Map');
      return DevicePropertiesStorageModel.empty();
    }
    if (json is! Map<String, dynamic>) {
      G.logger.e('json is not a Map<String, dynamic>');
      return DevicePropertiesStorageModel.empty();
    }

    // validate the metaData. log and return empty, if metaData is not valid.
    final metaDataJson = json['metaData'];
    if (metaDataJson == null) {
      G.logger.e('metaData is null');
      return DevicePropertiesStorageModel.empty();
    }
    if (metaDataJson is! Map) {
      G.logger.e('metaData is not a Map');
      return DevicePropertiesStorageModel.empty();
    }
    if (metaDataJson is! Map<String, dynamic>) {
      G.logger.e('metaData is not a Map<String, dynamic>');
      return DevicePropertiesStorageModel.empty();
    }

    // validate the senderInformation. log and return empty, if
    // senderInformation is not valid.
    final senderInformation = json['senderInformation'];
    if (senderInformation == null) {
      G.logger.e('senderInformation is null');
      return DevicePropertiesStorageModel.empty();
    }
    if (senderInformation is! Map) {
      G.logger.e('senderInformation is not a Map');
      return DevicePropertiesStorageModel.empty();
    }
    if (senderInformation is! Map<String, dynamic>) {
      G.logger.e('senderInformation is not a Map<String, dynamic>');
      return DevicePropertiesStorageModel.empty();
    }

    // validate the themeMode. log and return empty, if themeMode is not valid.
    final themeMode = json['themeMode'];
    if (themeMode is! String?) {
      G.logger.e('themeMode is not a String');
      return DevicePropertiesStorageModel.empty();
    }

    return DevicePropertiesStorageModel._internal(
      senderInformation: SenderInformation.fromJson(senderInformation),
      themeMode: ThemeModeJsonConverter.fromJson(themeMode),
      metaData: StorageModelMetaData.fromJson(metaDataJson),
    );
  }

  @override
  StorageModelMetaData? metaData;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': senderInformation.deviceId,
      'senderInformation': senderInformation.toJson(),
      'themeMode': themeMode.toJson(),
      'metaData': metaData?.toJson(),
    };
  }

  /// Creates a new [DevicePropertiesStorageModel] with the given parameters.
  DevicePropertiesStorageModel copyWith({
    SenderInformation? senderInformation,
    ThemeMode? themeMode,
  }) {
    return DevicePropertiesStorageModel._internal(
      senderInformation: senderInformation ?? this.senderInformation,
      themeMode: themeMode ?? this.themeMode,
      metaData: metaData,
    );
  }
}
