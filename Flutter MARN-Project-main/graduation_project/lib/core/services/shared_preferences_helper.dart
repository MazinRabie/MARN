import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static late SharedPreferences _prefs;

  static final _controller = StreamController<Map<String, dynamic>>.broadcast();

  static Stream<Map<String, dynamic>> get stream => _controller.stream;

  /// Init
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// 🔥 notify
  static void _notify(String key, dynamic value) {
    _controller.add({key: value});
  }

  /// ================== SET ==================

  static Future<bool> setString(String key, String value) async {
    final result = await _prefs.setString(key, value);
    _notify(key, value);
    return result;
  }

  static Future<bool> setInt(String key, int value) async {
    final result = await _prefs.setInt(key, value);
    _notify(key, value);
    return result;
  }

  static Future<bool> setBool(String key, bool value) async {
    final result = await _prefs.setBool(key, value);
    _notify(key, value);
    return result;
  }

  static Future<bool> setDouble(String key, double value) async {
    final result = await _prefs.setDouble(key, value);
    _notify(key, value);
    return result;
  }

  static Future<bool> setStringList(String key, List<String> value) async {
    final result = await _prefs.setStringList(key, value);
    _notify(key, value);
    return result;
  }

  /// ================== GET ==================

  static String? getString(String key) => _prefs.getString(key);

  static int? getInt(String key) => _prefs.getInt(key);

  static bool? getBool(String key) => _prefs.getBool(key);

  static double? getDouble(String key) => _prefs.getDouble(key);

  static List<String>? getStringList(String key) => _prefs.getStringList(key);

  /// ================== REMOVE ==================

  static Future<bool> remove(String key) async {
    final result = await _prefs.remove(key);
    _notify(key, null);
    return result;
  }

  static Future<bool> clear() async {
    final result = await _prefs.clear();
    _notify("clear_all", true);
    return result;
  }
}

class LocalStorageVariables {
  static const String token = "token";
  static const String expiration = "expiration";
  static const String fcmToken = "fcmToken";
  static const String user = "user";
  static const String profileSettings = "profileSettings";
  static const String userId = "userId";
  static const String language = "app_language";
}

void saveLocalData(
  String token,
  String expiration,
) async {
  await SharedPreferencesHelper.setString(LocalStorageVariables.token, token);
  await SharedPreferencesHelper.setString(
    LocalStorageVariables.expiration,
    expiration,
  );
}

void deleteLocalData() async {
  await SharedPreferencesHelper.remove(LocalStorageVariables.token);
  await SharedPreferencesHelper.remove(LocalStorageVariables.expiration);
  await SharedPreferencesHelper.remove(LocalStorageVariables.user);
  await SharedPreferencesHelper.remove(LocalStorageVariables.userId);
  await SharedPreferencesHelper.remove(LocalStorageVariables.profileSettings);
}
