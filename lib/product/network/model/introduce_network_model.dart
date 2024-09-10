import 'package:core/core.dart';
import 'package:localchess/product/dependency_injection/get.dart';

/// A network model for introducing a new client to the server or server to
/// client. Can not be listened to by the on data listeners.
class IntroduceNetworkModel implements NetworkModel {
  /// Creates a new [IntroduceNetworkModel]
  const IntroduceNetworkModel() : _senderInformation = null;

  IntroduceNetworkModel._internal({
    required SenderInformation senderInformation,
  }) : _senderInformation = senderInformation;

  /// Creates an empty [IntroduceNetworkModel]
  const IntroduceNetworkModel.empty() : _senderInformation = null;

  final SenderInformation? _senderInformation;

  /// The type identifier for the [IntroduceNetworkModel]
  static const String type = 'IntroduceNetworkModel';

  @override
  Object get typeId => IntroduceNetworkModel.type;

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

    // validate sender information
    final senderInformation = json['senderInformation'];
    if (senderInformation == null) {
      throw Exception('senderInformation is null');
    }
    if (senderInformation is! Map<String, dynamic>) {
      throw Exception('senderInformation is not a Map<String, dynamic>');
    }

    return IntroduceNetworkModel._internal(
      senderInformation: SenderInformation.fromJson(senderInformation),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'senderInformation': senderInformation.toJson(),
      'typeId': typeId,
    };
  }
}
