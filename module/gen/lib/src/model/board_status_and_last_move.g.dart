// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_status_and_last_move.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoardStatusAndLastMove _$BoardStatusAndLastMoveFromJson(
        Map<String, dynamic> json) =>
    BoardStatusAndLastMove(
      fen: json['fen'] as String,
      lastMoveFrom: json['lastMoveFrom'] as String,
      lastMoveTo: json['lastMoveTo'] as String,
    );

Map<String, dynamic> _$BoardStatusAndLastMoveToJson(
        BoardStatusAndLastMove instance) =>
    <String, dynamic>{
      'fen': instance.fen,
      'lastMoveFrom': instance.lastMoveFrom,
      'lastMoveTo': instance.lastMoveTo,
    };
