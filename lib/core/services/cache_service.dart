import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static late SharedPreferences _prefs;

  /// Initialize this in main.dart before running the app
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // --- Helpers ---

  static String? getString(String key) {
    return _prefs.getString(key);
  }

  static Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  static Future<void> remove(String key) async {
    await _prefs.remove(key);
  }
}