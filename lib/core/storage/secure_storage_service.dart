import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontendmobile/features/auth/data/models/auth_user_model.dart';
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

  //----------------------------
  // READ KEY
  //----------------------------
  Future<String?> _read(String key) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } else {
      return _storage.read(key: key);
    }
  }

  //----------------------------
  // CLEAR REMOVE
  //----------------------------
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
  //////////////////////////////////////////////////////////
  ///
  ////////////////////////////////

  Future<void> saveUserInfo(UserInfo user) async {
    await Future.wait([
      _write(ApiConstants.userIdKey, user.userId.toString()),
      _write(ApiConstants.companyIdKey, user.companyId.toString()),
      _write(
        ApiConstants.staffIdKey,
        user.staffId?.toString() ?? '',
      ), // ← must have `?.` now that staffId is int?
      _write(ApiConstants.usernameKey, user.username),
      _write(ApiConstants.fullNameKey, user.fullName),
      _write(ApiConstants.roleKey, user.role),
      _write(ApiConstants.statusKey, user.status),
      _write(ApiConstants.isManagerKey, user.isManager.toString()),
      _write(ApiConstants.departmentIdKey, user.departmentId?.toString() ?? ''),
      _write(ApiConstants.permissionsKey, jsonEncode(user.permissions)),
    ]);
  }

  ///////////////////////////////
  ///
  ////////////////////////////////

  Future<UserInfo?> getUserInfo() async {
    final results = await Future.wait([
      _read(ApiConstants.userIdKey),
      _read(ApiConstants.companyIdKey),
      _read(ApiConstants.staffIdKey),
      _read(ApiConstants.usernameKey),
      _read(ApiConstants.fullNameKey),
      _read(ApiConstants.roleKey),
      _read(ApiConstants.statusKey),
      _read(ApiConstants.isManagerKey),
      _read(ApiConstants.departmentIdKey),
      _read(ApiConstants.permissionsKey),
    ]);
    if (results[0] == null) return null;
    List<String> permissions = [];
    if (results[9] != null && results[9]!.isNotEmpty) {
      try {
        permissions = List<String>.from(jsonDecode(results[9]!));
      } catch (_) {
        permissions = [];
      }
    }
    return UserInfo(
      userId: int.parse(results[0]!),
      companyId: int.parse(results[1]!),
      staffId: (results[2] != null && results[2]!.isNotEmpty)
          ? int.parse(results[2]!)
          : null,
      username: results[3] ?? '',
      fullName: results[4] ?? '',
      role: results[5] ?? '',
      status: results[6] ?? '',
      isManager: results[7] == 'true',
      permissions: permissions,
      departmentId: (results[8] != null && results[8]!.isNotEmpty)
          ? int.parse(results[8]!)
          : null,
    );
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
  // Future<void> clearAuth() async {
  //   await Future.wait([
  //     _delete(ApiConstants.accessTokenKey),
  //     _delete(ApiConstants.refreshTokenKey),
  //     _delete(ApiConstants.userIdKey),
  //     _delete(ApiConstants.companyIdKey),
  //   ]);
  //////////////////////////////////////////////////////////
  ///
  /////////////////////////////////////////////////////////

  Future<void> clearAuth() async {
    await Future.wait([
      _delete(ApiConstants.accessTokenKey),
      _delete(ApiConstants.refreshTokenKey),
      _delete(ApiConstants.userIdKey),
      _delete(ApiConstants.companyIdKey),
      _delete(ApiConstants.staffIdKey),
      _delete(ApiConstants.usernameKey),
      _delete(ApiConstants.fullNameKey),
      _delete(ApiConstants.roleKey),
      _delete(ApiConstants.statusKey),
      _delete(ApiConstants.isManagerKey),
      _delete(ApiConstants.departmentIdKey),
      _delete(ApiConstants.permissionsKey),
    ]);
  }
}
