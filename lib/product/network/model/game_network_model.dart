import 'package:core/core.dart';
import 'package:localchess/product/data/piece/app_piece.dart';
import 'package:localchess/product/data/piece/app_piece_json_extension.dart';
import 'package:localchess/product/dependency_injection/get.dart';

/// The network model to send the status of the board and other details.
/// Does non include the whole game save.
class GameNetworkModel implements NetworkModel {
  /// Creates the [GameNetworkModel] instance.
  const GameNetworkModel({
    required this.capturedPieces,
    required this.gameFen,
    required this.isGameOver,
    this.lastMoveFrom,
    this.lastMoveTo,
  }) : _senderInformation = null;

  const GameNetworkModel._internal({
    required SenderInformation senderInformation,
    required this.capturedPieces,
    required this.gameFen,
    required this.isGameOver,
    this.lastMoveFrom,
    this.lastMoveTo,
  }) : _senderInformation = senderInformation;

  /// Creates an empty [GameNetworkModel] instance.
  const GameNetworkModel.empty()
      : _senderInformation = null,
        gameFen = '',
        capturedPieces = const [],
        isGameOver = false,
        lastMoveFrom = null,
        lastMoveTo = null;

  factory GameNetworkModel.fromJson(Map<String, dynamic> json) {
    // validate sender information
    final senderInformationJson = json['senderInformation'];
    if (senderInformationJson == null) {
      throw Exception('senderInformation is null');
    }
    if (senderInformationJson is! Map<String, dynamic>) {
      throw Exception('senderInformation is not a Map<String, dynamic>');
    }

    // validate capturedPieces
    final capturedPiecesJson = json['capturedPieces'];
    if (capturedPiecesJson == null) {
      throw Exception('capturedPieces is null');
    }
    if (capturedPiecesJson is! List) {
      throw Exception(
          'capturedPieces is not a List: ${capturedPiecesJson.runtimeType}');
    }

    // validate gameFen
    final gameFenJson = json['gameFen'];
    if (gameFenJson == null) {
      throw Exception('gameFen is null');
    }
    if (gameFenJson is! String) {
      throw Exception('gameFen is not a String');
    }

    // validate isGameOver
    final isGameOverJson = json['isGameOver'];
    if (isGameOverJson == null) {
      throw Exception('isGameOver is null');
    }
    if (isGameOverJson is! bool) {
      throw Exception('isGameOver is not a bool');
    }

    // validate lastMoveFrom
    final lastMoveFromJson = json['lastMoveFrom'];
    if (lastMoveFromJson == null) {
      throw Exception('lastMoveFrom is null');
    }
    if (lastMoveFromJson is! String) {
      throw Exception('lastMoveFrom is not a String');
    }

    // validate lastMoveTo
    final lastMoveToJson = json['lastMoveTo'];
    if (lastMoveToJson == null) {
      throw Exception('lastMoveTo is null');
    }
    if (lastMoveToJson is! String) {
      throw Exception('lastMoveTo is not a String');
    }

    return GameNetworkModel._internal(
      senderInformation: SenderInformation.fromJson(senderInformationJson),
      capturedPieces: capturedPiecesJson.cast<String>().toAppPieceList(),
      gameFen: gameFenJson,
      isGameOver: isGameOverJson,
      lastMoveFrom: lastMoveFromJson,
      lastMoveTo: lastMoveToJson,
    );
  }

  final SenderInformation? _senderInformation;

  /// The FEN of the game.
  final String gameFen;

  /// The pieces captured in the game.
  final List<AppPiece> capturedPieces;

  /// Whether the game is over.
  final bool isGameOver;

  /// The starting position of the last move.
  final String? lastMoveFrom;

  /// The ending position of the last move.
  final String? lastMoveTo;

  @override
  SenderInformation get senderInformation =>
      _senderInformation ?? G.deviceProperties.senderInformation;

  @override
  Object get typeId => type;

  /// The type id of the network model.
  static const String type = 'GameNetworkModel';

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

    return GameNetworkModel.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'typeId': typeId,
      'senderInformation': senderInformation.toJson(),
      'capturedPieces': capturedPieces.toJson(),
      'gameFen': gameFen,
      'isGameOver': isGameOver,
      'lastMoveFrom': lastMoveFrom,
      'lastMoveTo': lastMoveTo,
    };
  }
}
