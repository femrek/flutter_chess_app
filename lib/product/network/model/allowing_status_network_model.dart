import 'package:core/core.dart';
import 'package:localchess/product/dependency_injection/get.dart';

/// A network model for allowing a client to play the game. also can be used to
/// deny or cancel the allowing status.
class AllowingStatusNetworkModel implements NetworkModel {
  /// Creates a new [AllowingStatusNetworkModel]
  const AllowingStatusNetworkModel({
    required this.allowed,
  }) : _senderInformation = null;

  AllowingStatusNetworkModel._internal({
    required this.allowed,
    required SenderInformation senderInformation,
  }) : _senderInformation = senderInformation;

  /// Creates an empty [AllowingStatusNetworkModel]
  const AllowingStatusNetworkModel.empty()
      : _senderInformation = null,
        allowed = false;

  factory AllowingStatusNetworkModel.fromJson(Map<String, dynamic> json) {
    // validate sender information
    final senderInformation = json['senderInformation'];
    if (senderInformation == null) {
      throw Exception('senderInformation is null');
    }
    if (senderInformation is! Map<String, dynamic>) {
      throw Exception('senderInformation is not a Map<String, dynamic>');
    }

    // validate allowed
    final allowed = json['allowed'];
    if (allowed == null) {
      throw Exception('allowed is null');
    }
    if (allowed is! bool) {
      throw Exception('allowed is not a bool');
    }

    return AllowingStatusNetworkModel._internal(
      senderInformation: SenderInformation.fromJson(senderInformation),
      allowed: allowed,
    );
  }

  /// Whether the client is allowed to play the game.
  final bool allowed;

  final SenderInformation? _senderInformation;

  /// The type identifier for the [AllowingStatusNetworkModel]
  static const String type = 'AllowingStatusNetworkModel';

  @override
  Object get typeId => AllowingStatusNetworkModel.type;

  @override
  SenderInformation get senderInformation =>
      _senderInformation ?? G.deviceProperties.senderInformation;

  @override
  NetworkModel fromJson(Map<String, dynamic> json) {
    // validate typeId
    final typeIdJson = json['typeId'];
    if (typeIdJson == null) {
      throw Exception('typeId is null');
    }
    if (typeIdJson is! String) {
      throw Exception('typeId is not a String');
    }
    if (typeIdJson != typeId) {
      throw Exception('typeId is not equal to typeId');
    }

    return AllowingStatusNetworkModel.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'typeId': typeId,
      'senderInformation': senderInformation.toJson(),
      'allowed': allowed,
    };
  }

  @override
  String toString() {
    return 'AllowingStatusNetworkModel:${toJson()}';
  }
}
