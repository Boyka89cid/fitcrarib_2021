import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static final Prefs _singleton = new Prefs._internal();

  // IOClient ioClient;

  factory Prefs() {
    return _singleton;
  }

  Prefs._internal() {
    init();
  }

  Future<bool> setString(String key, String value) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.setString(key, value);
  }

  Future<bool> setBool(String key, bool value) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.setBool(key, value);
  }

  Future<bool> setDouble(String key, double value) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.setDouble(key, value);
  }

  Future<bool> setInt(String key, int value) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.setInt(key, value);
  }

  Future<bool> setStringList(String key, List<String> value) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.setStringList(key, value);
  }

  Future<String> getString(String key) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getString(key)!;
  }

  Future<bool> getBool(String key) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getBool(key)!;
  }

  Future<double> getDouble(String key) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getDouble(key)!;
  }

  Future<int> getInt(String key) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getInt(key)!;
  }

  Future<List<String>> getStringList(String key) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getStringList(key)!;
  }

  Future<bool> clear() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.clear();
  }

  void init() async {
     await SharedPreferences.getInstance();
  }
}
