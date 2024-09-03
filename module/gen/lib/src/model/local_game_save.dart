import 'package:gen/src/model/board_status_and_last_move.dart';
import 'package:json_annotation/json_annotation.dart';

part 'local_game_save.g.dart';

/// Keeps the save data of a local game.
@JsonSerializable()
class LocalGameSave {
  /// Constructor
  const LocalGameSave({
    required this.name,
    required this.history,
    required this.defaultPosition,
  });

  /// Creates an empty instance of [LocalGameSave].
  LocalGameSave.empty()
      : name = '',
        history = [],
        defaultPosition = '';

  /// Creates a new instance of [LocalGameSave] from a JSON object.
  factory LocalGameSave.fromJson(Map<String, dynamic> json) {
    return _$LocalGameSaveFromJson(json);
  }

  /// The visible name of the save.
  final String name;

  /// The state history of the game in FEN format.
  final List<BoardStatusAndLastMove> history;

  /// The last move made in the game.
  final String defaultPosition;

  /// Converts the save to a JSON object.
  Map<String, dynamic> toJson() => _$LocalGameSaveToJson(this);

  /// The current state of the game.
  String get currentStateFen => history.lastOrNull?.fen ?? defaultPosition;

  BoardStatusAndLastMove? get currentState => history.lastOrNull;

  /// Returns a copy of the save with the given fields updated.
  LocalGameSave copyWith({
    String? name,
    List<BoardStatusAndLastMove>? history,
    String? defaultPosition,
  }) {
    return LocalGameSave(
      name: name ?? this.name,
      history: history ?? this.history,
      defaultPosition: defaultPosition ?? this.defaultPosition,
    );
  }

  /// Adds a new state to the history.
  LocalGameSave addHistory(BoardStatusAndLastMove state) {
    return copyWith(history: [...history, state]);
  }

  /// Removes the last state from the history.
  LocalGameSave popHistory() {
    if (history.isEmpty) throw Exception('Cannot undo the initial state');
    return copyWith(history: history.sublist(0, history.length - 1));
  }
}
