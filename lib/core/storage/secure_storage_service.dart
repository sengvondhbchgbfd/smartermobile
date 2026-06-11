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
  //////////////////////////////////////////////////////////

  Future<void> saveUserInfo(UserInfo user) async {
    await Future.wait([
      _write(ApiConstants.userIdKey, user.userId.toString()),
      _write(ApiConstants.companyIdKey, user.companyId.toString()),
      _write(ApiConstants.staffIdKey, user.staffId.toString()),
      _write(ApiConstants.usernameKey, user.username),
      _write(ApiConstants.fullNameKey, user.fullName),
      _write(ApiConstants.roleKey, user.role),
      _write(ApiConstants.statusKey, user.status),
      _write(ApiConstants.isManagerKey, user.isManager.toString()),
<<<<<<< HEAD
=======
      _write(ApiConstants.departmentIdKey, user.departmentId?.toString() ?? ''),
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
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
<<<<<<< HEAD
=======
      _read(ApiConstants.departmentIdKey),
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
    ]);

    if (results[0] == null) return null;

    return UserInfo(
      userId: int.parse(results[0]!),
      companyId: int.parse(results[1]!),
      staffId: int.parse(results[2]!),
      username: results[3] ?? '',
      fullName: results[4] ?? '',
      role: results[5] ?? '',
      status: results[6] ?? '',
      isManager: results[7] == 'true',
      permissions: [],
<<<<<<< HEAD
      departmentId: null,
=======
      departmentId: results[8] != null ? int.parse(results[8]!) : null,
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
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
<<<<<<< HEAD
=======
      _delete(ApiConstants.departmentIdKey),
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
    ]);
  }
}
