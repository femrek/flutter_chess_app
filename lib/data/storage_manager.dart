import 'package:localchess/data/model/last_move_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config.dart';

class StorageManager {

  static const String LAST_GAME_FEN = 'lastGameFen';
  static const String LAST_HOST_GAME_FEN = 'lastHostGameFen';
  static const String LAST_CONNECTED_HOST = 'lastConnectedHost';
  static const String LAST_CONNECTED_PORT = 'lastConnectedPort';
  static const String LAST_GAME_LAST_FROM = 'lastGameLastFrom';
  static const String LAST_GAME_LAST_TO = 'lastGameLastTo';
  static const String LAST_HOST_GAME_LAST_FROM = 'lastHostGameLastFrom';
  static const String LAST_HOST_GAME_LAST_TO = 'lastHostGameLastTo';
  static const String GAME_STATE_HISTORY = 'gameStateHistory';
  static const String HOST_GAME_STATE_HISTORY = 'hostGameStateHistory';

  SharedPreferences _sharedPreferences;

  /// set _sharedPreferences value if it is null. CALL WITH AWAIT
  Future _setSharedPreferences() async {
    if (_sharedPreferences == null) 
      _sharedPreferences = await SharedPreferences.getInstance();
  }

  // TWO PLAYER GAME ------------------------------------------------------------------------------
  String _lastGameFen;
  /// param fen: board state in fen format.
  /// return: if save success return true else false.
  Future<bool> setLastGameFen(String newFen) async {
    await _setSharedPreferences();
    if (await _sharedPreferences.setString(LAST_GAME_FEN, newFen)) {
      _lastGameFen = newFen;
      return true;
    }
    return false;
  }
  /// return: saved last board state in fen format. (use setLastGameFen for
  /// save last fen).
  Future<String> get lastGameFen async {
    if (_lastGameFen != null) return _lastGameFen;
    await _setSharedPreferences();
    _lastGameFen = _sharedPreferences.getString(LAST_GAME_FEN);
    return _lastGameFen;
  }
  LastMoveModel _lastGameLastMove;
  /// return: if save success return true else false.
  Future<bool> setLastGameLastMove(LastMoveModel newMove) async {
    await _setSharedPreferences();
    if (await _sharedPreferences.setString(LAST_GAME_LAST_FROM, newMove.from)
      && await _sharedPreferences.setString(LAST_GAME_LAST_TO, newMove.to)
    ) {
      _lastGameLastMove = newMove;
      return true;
    }
    return false;
  }
  /// return: saved last move. (use setLastGameLastMove for save last move).
  Future<LastMoveModel> get lastGameLastMove async {
    if (_lastGameLastMove != null) return _lastGameLastMove;
    await _setSharedPreferences();
    String from = _sharedPreferences.getString(LAST_GAME_LAST_FROM) ?? '';
    String to = _sharedPreferences.getString(LAST_GAME_LAST_TO) ?? '';
    _lastGameLastMove = LastMoveModel(from: from, to: to);
    return _lastGameLastMove;
  }
  List<String> _boardStateHistory;
  /// return: if save success return true else false.
  Future<bool> setBoardStateHistory(List<String> newList) async {
    await _setSharedPreferences();
    if (await _sharedPreferences.setStringList(GAME_STATE_HISTORY, newList)) {
      _boardStateHistory = newList;
      return true;
    }
    return false;
  }
  /// return: a list of bundle string like "fen#a1/a5". Bundle string is the
  /// data type for save board state and last move.
  Future<List<String>> get boardStateHistory async {
    if (_boardStateHistory != null) return _boardStateHistory;
    await _setSharedPreferences();
    _boardStateHistory =
        _sharedPreferences.getStringList(GAME_STATE_HISTORY) ?? List();
    return _boardStateHistory;
  }
  /// param bundleString: Bundle string is the data type sent
  /// from the host to the client. Like "fen#a1/a5".
  /// return: if save success return true else false.
  Future<bool> addBoardStateHistory(String bundleString) async =>
    await setBoardStateHistory((await boardStateHistory)..add(bundleString));
  /// return: removed bundle string like "fen#a1/a5". Bundle string is the data
  /// type for save board state and last move.
  Future<String> removeLastFromBoardStateHistory() async {
    final List<String> currentHistoryList = (await boardStateHistory);
    final String removedState = currentHistoryList.removeLast();
    await setBoardStateHistory(currentHistoryList);
    return removedState;
  }
  

  // HOST GAME -------------------------------------------------------------------------------------
  String _lastHostGameFen;
  /// param fen: board state in fen format.
  /// return: if save success return true else false.
  Future<bool> setLastHostGameFen(String newFen) async {
    await _setSharedPreferences();
    if (await _sharedPreferences.setString(LAST_HOST_GAME_FEN, newFen)) {
      _lastHostGameFen = newFen;
      return true;
    }
    return false;
  }
  /// return: saved last board state in fen format. (use setLastHostGameFen for
  /// save last fen).
  Future<String> get lastHostGameFen async {
    if (_lastHostGameFen != null) return _lastHostGameFen;
    await _setSharedPreferences();
    _lastHostGameFen = _sharedPreferences.getString(LAST_HOST_GAME_FEN);
    return _lastHostGameFen;
  }
  LastMoveModel _lastHostGameLastMove;
  /// return: if save success return true else false.
  Future<bool> setLastHostGameLastMove(LastMoveModel newMove) async {
    await _setSharedPreferences();
    if (await _sharedPreferences.setString(LAST_HOST_GAME_LAST_FROM, newMove.from)
      && await _sharedPreferences.setString(LAST_HOST_GAME_LAST_TO, newMove.to)
    ) {
      _lastHostGameLastMove = newMove;
      return true;
    }
    return false;
  }
  /// return: saved last move. (use setLastHostGameLastMove for save last move)
  Future<LastMoveModel> get lastHostGameLastMove async {
    if (_lastHostGameLastMove != null) return _lastHostGameLastMove;
    await _setSharedPreferences();
    String from = _sharedPreferences.getString(LAST_HOST_GAME_LAST_FROM) ?? '';
    String to = _sharedPreferences.getString(LAST_HOST_GAME_LAST_TO) ?? '';
    _lastHostGameLastMove = LastMoveModel(from: from, to: to);
    return _lastHostGameLastMove;
  }
  List<String> _hostBoardStateHistory;
  /// return: if save success return true else false.
  Future<bool> setHostBoardStateHistory(List<String> newList) async {
    await _setSharedPreferences();
    if (await _sharedPreferences.setStringList(HOST_GAME_STATE_HISTORY, newList)) {
      _hostBoardStateHistory = newList;
      return true;
    }
    return false;
  }
  /// return: a list of bundle string like "fen#a1/a5". Bundle string is the
  /// data type for save board state and last move.
  Future<List<String>> get hostBoardStateHistory async {
    if (_hostBoardStateHistory != null) return _hostBoardStateHistory;
    await _setSharedPreferences();
    _hostBoardStateHistory = _sharedPreferences.getStringList(HOST_GAME_STATE_HISTORY) ?? List();
    return _hostBoardStateHistory;
  }
  /// param bundleString: Bundle string is the data type sent
  /// from the host to the client. Like "fen#a1/a5".
  /// return: if save success return true else false.
  Future<bool> addHostBoardStateHistory(String bundleString) async =>
    await setHostBoardStateHistory((await hostBoardStateHistory)..add(bundleString));
  /// return: removed bundle string like "fen#a1/a5". Bundle string is the data
  /// type for save board state and last move.
  Future<String> removeLastFromHostBoardStateHistory() async {
    final List<String> currentHistoryList = (await hostBoardStateHistory);
    final String removedState = currentHistoryList.removeLast();
    await setHostBoardStateHistory(currentHistoryList);
    return removedState;
  }

  // CLIENT ------------------------------------------------------------------------------------
  String _lastConnectedHost;
  /// return: if save success return true else false.
  Future<bool> setLastConnectedHost(String newHost) async {
    await _setSharedPreferences();
    if (await _sharedPreferences.setString(LAST_CONNECTED_HOST, newHost)) {
      _lastConnectedHost = newHost;
      return true;
    }
    return false;
  }
  /// return: saved last connected host. (use setLastConnectedHost for save).
  Future<String> get lastConnectedHost async {
    if (_lastConnectedHost != null) return _lastConnectedHost;
    await _setSharedPreferences();
    _lastConnectedHost = _sharedPreferences.getString(LAST_CONNECTED_HOST);
    return _lastConnectedHost;
  }

  int _lastConnectedPort;
  /// return: if save success return true else false.
  Future<bool> setLastConnectedPort(int newPort) async {
    await _setSharedPreferences();
    if (await _sharedPreferences.setInt(LAST_CONNECTED_PORT, newPort)) {
      _lastConnectedPort = newPort;
      return true;
    }
    return false;
  }
  /// return: saved last connected port. (use setLastConnectedPort for save).
  Future<int> get lastConnectedPort async {
    if (_lastConnectedPort != null) return _lastConnectedPort;
    await _setSharedPreferences();
    _lastConnectedPort = _sharedPreferences.getInt(LAST_CONNECTED_PORT) ?? 0;
    if (_lastConnectedPort == 0) {
      _lastConnectedPort = portsWithPriority[0];
    }
    return _lastConnectedPort;
  }

  // singleton-----------------------------------------------------------------------------------
  static final StorageManager _instance = StorageManager._internal();
  StorageManager._internal();
  factory StorageManager() =>_instance; 
}