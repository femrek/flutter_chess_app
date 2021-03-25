import 'package:mychess/data/model/last_move_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {

  static const String LAST_GAME_FEN = 'lastGameFen';
  static const String LAST_HOST_GAME_FEN = 'lastHostGameFen';
  static const String LAST_CONNECTED_HOST = 'lastConnectedHost';
  static const String LAST_CONNECTED_PORT = 'lastConnectedPort';
  static const String LAST_GAME_LAST_FROM = 'lastGameLastFrom';
  static const String LAST_GAME_LAST_TO = 'lastGameLastTo';

  SharedPreferences _sharedPreferences;

  Future _setSharedPreferences() async {
    if (_sharedPreferences == null) 
      _sharedPreferences = await SharedPreferences.getInstance();
  }

  String _lastGameFen;
  Future<bool> setLastGameFen(String newFen) async {
    await _setSharedPreferences();
    if (await _sharedPreferences.setString(LAST_GAME_FEN, newFen)) {
      _lastGameFen = newFen;
      return true;
    }
    return false;
  }
  Future<String> get lastGameFen async {
    if (_lastGameFen != null) return _lastGameFen;
    await _setSharedPreferences();
    _lastGameFen = _sharedPreferences.getString(LAST_GAME_FEN);
    return _lastGameFen;
  }
  LastMoveModel _lastGameLastMove;
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
  Future<LastMoveModel> get lastGameLastMove async {
    if (_lastGameLastMove != null) return _lastGameLastMove;
    await _setSharedPreferences();
    String from = _sharedPreferences.getString(LAST_GAME_LAST_FROM);
    String to = _sharedPreferences.getString(LAST_GAME_LAST_TO);
    _lastGameLastMove = LastMoveModel(from: from, to: to);
    return _lastGameLastMove;
  }

  String _lastHostGameFen;
  Future<bool> setLastHostGameFen(String newFen) async {
    await _setSharedPreferences();
    if (await _sharedPreferences.setString(LAST_HOST_GAME_FEN, newFen)) {
      _lastHostGameFen = newFen;
      return true;
    }
    return false;
  }
  Future<String> get lastHostGameFen async {
    if (_lastHostGameFen != null) return _lastHostGameFen;
    await _setSharedPreferences();
    _lastHostGameFen = _sharedPreferences.getString(LAST_HOST_GAME_FEN);
    return _lastHostGameFen;
  }

  String _lastConnectedHost;
  Future<bool> setLastConnectedHost(String newHost) async {
    await _setSharedPreferences();
    if (await _sharedPreferences.setString(LAST_CONNECTED_HOST, newHost)) {
      _lastConnectedHost = newHost;
      return true;
    }
    return false;
  }
  Future<String> get lastConnectedHost async {
    if (_lastConnectedHost != null) return _lastConnectedHost;
    await _setSharedPreferences();
    _lastConnectedHost = _sharedPreferences.getString(LAST_CONNECTED_HOST);
    return _lastConnectedHost;
  }

  int _lastConnectedPort;
  Future<bool> setLastConnectedPort(int newPort) async {
    await _setSharedPreferences();
    if (await _sharedPreferences.setInt(LAST_CONNECTED_PORT, newPort)) {
      _lastConnectedPort = newPort;
      return true;
    }
    return false;
  }
  Future<int> get lastConnectedPort async {
    if (_lastConnectedPort != null) return _lastConnectedPort;
    await _setSharedPreferences();
    _lastConnectedPort = _sharedPreferences.getInt(LAST_CONNECTED_PORT);
    return _lastConnectedPort;
  }

  static final StorageManager _instance = StorageManager._internal();
  StorageManager._internal();
  factory StorageManager() =>_instance; 
}