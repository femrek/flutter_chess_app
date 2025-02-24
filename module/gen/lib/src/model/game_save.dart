import 'package:gen/src/model/board_status_and_last_move.dart';
import 'package:json_annotation/json_annotation.dart';

part 'game_save.g.dart';

/// Keeps the save data of a local game.
@JsonSerializable()
class GameSave {
  /// Create a [GameSave] object.
  const GameSave({
    required this.name,
    required this.history,
    required this.defaultPosition,
    required this.isGameOver,
  });

  /// Creates an empty instance of [GameSave].
  GameSave.empty()
      : name = '',
        history = [],
        defaultPosition = '',
        isGameOver = false;

  /// Creates a new instance of [GameSave] from a JSON object.
  factory GameSave.fromJson(Map<String, dynamic> json) {
    return _$GameSaveFromJson(json);
  }

  /// The visible name of the save.
  final String name;

  /// The state history of the game in FEN format.
  final List<BoardStatusAndLastMove> history;

  /// The initial position of the save in FEN format.
  ///
  /// By default in an initial game save the [history] must be empty.
  /// [currentStateFen] returns this value if the [history] is empty.
  final String defaultPosition;

  /// Whether the game is over.
  final bool isGameOver;

  /// Converts the save to a JSON object.
  Map<String, dynamic> toJson() => _$GameSaveToJson(this);

  /// The current state of the game.
  String get currentStateFen => history.lastOrNull?.fen ?? defaultPosition;

  /// The current state of the game as FEN string.
  BoardStatusAndLastMove? get currentState => history.lastOrNull;

  /// Returns a copy of the save with the given fields updated.
  GameSave copyWith({
    String? name,
    List<BoardStatusAndLastMove>? history,
    String? defaultPosition,
    bool? isGameOver,
  }) {
    return GameSave(
      name: name ?? this.name,
      history: history ?? this.history,
      defaultPosition: defaultPosition ?? this.defaultPosition,
      isGameOver: isGameOver ?? this.isGameOver,
    );
  }

  /// Adds a new state to the history.
  GameSave addHistory(BoardStatusAndLastMove state) {
    return copyWith(history: [...history, state]);
  }

  /// Removes the last state from the history.
  GameSave popHistory() {
    if (history.isEmpty) throw Exception('Cannot undo the initial state');
    return copyWith(history: history.sublist(0, history.length - 1));
  }
}
