import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {

  static const String LAST_GAME_FEN = 'lastGameFen';

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

  static final StorageManager _instance = StorageManager._internal();
  StorageManager._internal();
  factory StorageManager() =>_instance; 
}