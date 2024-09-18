// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_save.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameSave _$GameSaveFromJson(Map<String, dynamic> json) => GameSave(
      name: json['name'] as String,
      history: (json['history'] as List<dynamic>)
          .map(
              (e) => BoardStatusAndLastMove.fromJson(e as Map<String, dynamic>))
          .toList(),
      defaultPosition: json['defaultPosition'] as String,
      isGameOver: json['isGameOver'] as bool,
    );

Map<String, dynamic> _$GameSaveToJson(GameSave instance) => <String, dynamic>{
      'name': instance.name,
      'history': instance.history,
      'defaultPosition': instance.defaultPosition,
      'isGameOver': instance.isGameOver,
    };
