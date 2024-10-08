import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/network/core/model/network_model.dart';
import 'package:localchess/product/network/core/model/sender_information.dart';

/// A network model for disconnecting a client from the server or server from
/// client.
class DisconnectNetworkModel implements NetworkModel {
  /// Creates a new [DisconnectNetworkModel]
  const DisconnectNetworkModel() : _senderInformation = null;

  /// Creates a new [DisconnectNetworkModel] with the [senderInformation].
  const DisconnectNetworkModel._internal({
    required SenderInformation senderInformation,
  }) : _senderInformation = senderInformation;

  /// Creates an empty [DisconnectNetworkModel]
  const DisconnectNetworkModel.empty() : _senderInformation = null;

  factory DisconnectNetworkModel.fromJson(Map<String, dynamic> json) {
    // validate sender information
    final senderInformation = json['senderInformation'];
    if (senderInformation == null) {
      throw Exception('senderInformation is null');
    }
    if (senderInformation is! Map<String, dynamic>) {
      throw Exception('senderInformation is not a Map<String, dynamic>');
    }

    return DisconnectNetworkModel._internal(
      senderInformation: SenderInformation.fromJson(senderInformation),
    );
  }

  final SenderInformation? _senderInformation;

  @override
  SenderInformation get senderInformation =>
      _senderInformation ?? G.deviceProperties.senderInformation;

  @override
  Object get typeId => type;

  /// The type identifier for the [DisconnectNetworkModel]
  static const String type = 'DisconnectNetworkModel';

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

    return DisconnectNetworkModel.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'typeId': type,
      'senderInformation': senderInformation.toJson(),
    };
  }
}
