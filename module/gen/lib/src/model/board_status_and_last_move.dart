import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'board_status_and_last_move.g.dart';

/// Keeps the board status in FEN format and the last move made.
@JsonSerializable()
@immutable
class BoardStatusAndLastMove {
  /// Creates a new object of [BoardStatusAndLastMove].
  const BoardStatusAndLastMove({
    required this.fen,
    required this.lastMoveFrom,
    required this.lastMoveTo,
  });

  /// Creates a new instance of [BoardStatusAndLastMove] from a JSON object.
  factory BoardStatusAndLastMove.fromJson(Map<String, dynamic> json) {
    return _$BoardStatusAndLastMoveFromJson(json);
  }

  /// Keeps the board status in FEN format.
  final String fen;

  /// The starting position of the last move.
  final String lastMoveFrom;

  /// The ending position of the last move.
  final String lastMoveTo;

  /// Converts the object to a JSON object.
  Map<String, dynamic> toJson() => _$BoardStatusAndLastMoveToJson(this);
}
