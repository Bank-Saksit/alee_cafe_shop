import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static LocalStorageService _localStorageService;
  static SharedPreferences _preferences;

  static Future<LocalStorageService> getInstance() async {
    if(_localStorageService == null) {
      var secureStorage = LocalStorageService._();
      secureStorage._init();
      _localStorageService = secureStorage;

      return _localStorageService;
    }

    return _localStorageService;
  }

  LocalStorageService._();

  Future _init() async{
    _preferences = await SharedPreferences.getInstance();
  }

    static String getString(String key, {String defValue = ''}) {
    if(_preferences == null) return defValue;
    return _preferences.getString(key) ?? defValue;
  }

  static Future<bool> putString(String key,String value) {
    if(_preferences == null) return null;
    return _preferences.setString(key, value);
  }

  static int getInt(String key, {int defValue = 0}) {
    if(_preferences ==null) return defValue;
    return _preferences.getInt(key);
  }

  static Future<bool> putInt(String key, int value) {
    if(_preferences == null) return null;
    return _preferences.setInt(key, value);
  }
}