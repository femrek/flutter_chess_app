import 'package:localchess/product/data/player_color/player_color.dart';
import 'package:localchess/product/data/player_color/player_color_json_extension.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/network/core/model/network_model.dart';
import 'package:localchess/product/network/core/model/sender_information.dart';

/// A network model for introducing a game to  client by the host.
class GameIntroduceNetworkModel implements NetworkModel {
  /// Creates a new [GameIntroduceNetworkModel]
  const GameIntroduceNetworkModel({
    required this.gameName,
    required this.hostColor,
  }) : _senderInformation = null;

  const GameIntroduceNetworkModel._internal({
    required SenderInformation senderInformation,
    required this.gameName,
    required this.hostColor,
  }) : _senderInformation = senderInformation;

  /// Creates an empty [GameIntroduceNetworkModel] instance.
  const GameIntroduceNetworkModel.empty()
      : _senderInformation = null,
        gameName = '',
        hostColor = PlayerColor.white;

  factory GameIntroduceNetworkModel.fromJson(Map<String, dynamic> json) {
    // validate sender information
    final senderInformationJson = json['senderInformation'];
    if (senderInformationJson == null) {
      throw Exception('senderInformation is null');
    }
    if (senderInformationJson is! Map<String, dynamic>) {
      throw Exception('senderInformation is not a Map<String, dynamic>');
    }

    // validate gameName
    final gameNameJson = json['gameName'];
    if (gameNameJson == null) {
      throw Exception('gameName is null');
    }
    if (gameNameJson is! String) {
      throw Exception('gameName is not a String');
    }

    // validate hostColor
    final hostColorJson = json['hostColor'];
    if (hostColorJson == null) {
      throw Exception('hostColor is null');
    }
    if (hostColorJson is! String) {
      throw Exception('hostColor is not a String');
    }
    if (!hostColorJson.canParseToPlayerColor) {
      throw Exception('hostColor can not be parsed to PlayerColor');
    }

    return GameIntroduceNetworkModel._internal(
      senderInformation: SenderInformation.fromJson(senderInformationJson),
      gameName: gameNameJson,
      hostColor: hostColorJson.toPlayerColor,
    );
  }

  final SenderInformation? _senderInformation;

  /// The name of the game playing on.
  final String gameName;

  /// The side of the host player.
  final PlayerColor hostColor;

  @override
  SenderInformation get senderInformation =>
      _senderInformation ?? G.deviceProperties.senderInformation;

  @override
  Object get typeId => type;

  /// The type identifier for the [GameIntroduceNetworkModel]
  static const String type = 'GameIntroduceNetworkModel';

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

    return GameIntroduceNetworkModel.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'typeId': typeId,
      'senderInformation': senderInformation.toJson(),
      'gameName': gameName,
      'hostColor': hostColor.toJson,
    };
  }
}
