// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_game_save.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalGameSave _$LocalGameSaveFromJson(Map<String, dynamic> json) =>
    LocalGameSave(
      id: json['id'] as String,
      name: json['name'] as String,
      history:
          (json['history'] as List<dynamic>).map((e) => e as String).toList(),
      lastMoveFrom: json['lastMoveFrom'] as String?,
      lastMoveTo: json['lastMoveTo'] as String?,
    );

Map<String, dynamic> _$LocalGameSaveToJson(LocalGameSave instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'history': instance.history,
      'lastMoveFrom': instance.lastMoveFrom,
      'lastMoveTo': instance.lastMoveTo,
    };
