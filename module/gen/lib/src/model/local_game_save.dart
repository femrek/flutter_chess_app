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
  String get currentState => history.last;

  /// Returns a copy of the save with the given fields updated.
  LocalGameSave copyWith({
    String? id,
    String? name,
    List<String>? history,
    String? lastMoveFrom,
    String? lastMoveTo,
  }) {
    return LocalGameSave(
      id: id ?? this.id,
      name: name ?? this.name,
      history: history ?? this.history,
      lastMoveFrom: lastMoveFrom ?? this.lastMoveFrom,
      lastMoveTo: lastMoveTo ?? this.lastMoveTo,
    );
  }

  /// Adds a new state to the history.
  LocalGameSave addHistory(String stateFEN) {
    return copyWith(history: [...history, stateFEN]);
  }

  /// Removes the last state from the history.
  LocalGameSave popHistory() {
    if (history.length < 2) throw Exception('Cannot undo the initial state');
    return copyWith(history: history.sublist(0, history.length - 1));
  }
}
