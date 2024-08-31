import 'package:json_annotation/json_annotation.dart';

part 'local_game_save.g.dart';

/// Keeps the save data of a local game.
@JsonSerializable()
class LocalGameSave {
  /// Constructor
  const LocalGameSave({
    required this.id,
    required this.name,
    required this.history,
    this.lastMoveFrom,
    this.lastMoveTo,
  });

  /// Creates an empty instance of [LocalGameSave].
  LocalGameSave.empty()
      : id = '',
        name = '',
        history = [],
        lastMoveFrom = null,
        lastMoveTo = null;

  /// Creates a new instance of [LocalGameSave] from a JSON object.
  factory LocalGameSave.fromJson(Map<String, dynamic> json) {
    return _$LocalGameSaveFromJson(json);
  }

  /// The id of the save. Have to be unique. Recommended to use UUIDs.
  final String id;

  /// The visible name of the save.
  final String name;

  /// The state history of the game in FEN format.
  final List<String> history;

  /// The coordinates of where the last move was made from.
  final String? lastMoveFrom;

  /// The coordinates of where the last move was made to.
  final String? lastMoveTo;

  /// Converts the save to a JSON object.
  Map<String, dynamic> toJson() => _$LocalGameSaveToJson(this);

  /// The current state of the game.
  String? get currentState => history.isNotEmpty ? history.last : null;
}
