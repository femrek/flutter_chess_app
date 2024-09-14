import 'package:core/core.dart';
import 'package:localchess/product/data/move/app_chess_move.dart';
import 'package:localchess/product/dependency_injection/get.dart';

/// The network model to send the chess move data. Sent from the guest player
/// to the host player.
class MoveNetworkModel implements NetworkModel {
  /// Creates the [MoveNetworkModel] instance.
  const MoveNetworkModel({
    required this.move,
    this.promotion,
  }) : _senderInformation = null;

  const MoveNetworkModel._internal({
    required this.move,
    required SenderInformation senderInformation,
    this.promotion,
  }) : _senderInformation = senderInformation;

  /// Creates an empty [MoveNetworkModel].
  const MoveNetworkModel.empty()
      : move = const AppChessMove.empty(),
        promotion = null,
        _senderInformation = null;

  factory MoveNetworkModel.fromJson(Map<String, dynamic> json) {
    // validate sender information
    final senderInformationJson = json['senderInformation'];
    if (senderInformationJson == null) {
      throw Exception('senderInformation is null');
    }
    if (senderInformationJson is! Map<String, dynamic>) {
      throw Exception('senderInformation is not a Map<String, dynamic>');
    }

    // validate move
    final moveJson = json['move'];
    if (moveJson == null) {
      throw Exception('move is null');
    }
    if (moveJson is! Map<String, dynamic>) {
      throw Exception('move is not a Map<String, dynamic>');
    }

    // validate promotion
    final promotionJson = json['promotion'];
    if (promotionJson is! String?) {
      throw Exception('promotion is not a String');
    }

    return MoveNetworkModel._internal(
      move: AppChessMove.fromJson(moveJson),
      senderInformation: SenderInformation.fromJson(senderInformationJson),
      promotion: promotionJson,
    );
  }

  /// The chess move data.
  final AppChessMove move;

  /// The promotion piece if any.
  final String? promotion;

  final SenderInformation? _senderInformation;

  @override
  SenderInformation get senderInformation =>
      _senderInformation ?? G.deviceProperties.senderInformation;

  @override
  Object get typeId => type;

  /// The type id of the [MoveNetworkModel].
  static const String type = 'MoveNetworkModel';

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

    return MoveNetworkModel.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'typeId': typeId,
      'move': move.toJson,
      'senderInformation': senderInformation.toJson(),
    };
  }
}
