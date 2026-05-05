import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;
  SecureStorageService(this._storage);
  // ─────────────────────────────

  // INTERNAL HELPERS
  // ─────────────────────────────
  Future<void> _write(String key, String value) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
    } else {
      await _storage.write(key: key, value: value);
    }
  }

  Future<String?> _read(String key) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } else {
      return _storage.read(key: key);
    }
  }

  Future<void> _delete(String key) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
    } else {
      await _storage.delete(key: key);
    }
  }

  // ─────────────────────────────
  // TOKEN MANAGEMENT
  // ─────────────────────────────
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _write(ApiConstants.accessTokenKey, accessToken),
      _write(ApiConstants.refreshTokenKey, refreshToken),
    ]);
  }

  Future<void> updateAccessToken(String accessToken) async {
    await _write(ApiConstants.accessTokenKey, accessToken);
  }

  // ─────────────────────────────
  // USER INFO
  // ─────────────────────────────
  Future<void> saveUserInfo({
    required String userId,
    required String companyId,
  }) async {
    await Future.wait([
      _write(ApiConstants.userIdKey, userId),
      _write(ApiConstants.companyIdKey, companyId),
    ]);
  }

  Future<Map<String, String?>> getUserInfo() async {
    final results = await Future.wait([getUserId(), getCompanyId()]);
    return {"userId": results[0], "companyId": results[1]};
  }



  // ─────────────────────────────
  // READ
  // ─────────────────────────────
  Future<String?> getAccessToken() => _read(ApiConstants.accessTokenKey);
  Future<String?> getRefreshToken() => _read(ApiConstants.refreshTokenKey);
  Future<String?> getUserId() => _read(ApiConstants.userIdKey);
  Future<String?> getCompanyId() => _read(ApiConstants.companyIdKey);
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null;
  }

  // ─────────────────────────────
  // CLEAR ALL
  // ─────────────────────────────
  Future<void> clearAuth() async {
    await Future.wait([
      _delete(ApiConstants.accessTokenKey),
      _delete(ApiConstants.refreshTokenKey),
      _delete(ApiConstants.userIdKey),
      _delete(ApiConstants.companyIdKey),
    ]);
  }
}
