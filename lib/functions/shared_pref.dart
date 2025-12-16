import "package:shared_preferences/shared_preferences.dart";

class SharedPref {
  static late SharedPreferences _prefs;
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool? readBool(String key) => _prefs.getBool(key);
  static Future<bool> setBool(String key, bool v) => _prefs.setBool(key, v);
}
