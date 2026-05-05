import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  final SharedPreferences prefs;
  CacheService(this.prefs);
  Future<void> save(String key, dynamic data) async {
    final jsonString = jsonEncode(data);
    await prefs.setString(key, jsonString);
  }

  dynamic get(String key) {
    final jsonString = prefs.getString(key);
    if (jsonString == null) return null;
    return jsonDecode(jsonString);
  }

  Future<void> clear(String key) async {
    await prefs.remove(key);
  }
}
