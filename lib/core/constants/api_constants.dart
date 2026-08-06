import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static final String baseUrl =
      dotenv.env['BASE_URL']?.trim().isNotEmpty == true
      ? dotenv.env['BASE_URL']!.trim()
      : 'http://10.154.106.130:8000';

  static const String apiVersion = '/api/v1';
  static String get apiBaseUrl => '$baseUrl$apiVersion';

  // ── WebSocket ────────────────────────────────────────────────
  static String get wsBaseUrl => baseUrl
      .replaceFirst("https://", "wss://")
      .replaceFirst("http://", "ws://");

  // full ws base including api version
  static String get _wsApi => '$wsBaseUrl$apiVersion';
  static String chatWs(int groupId) => '$_wsApi/ws/chat/$groupId';
  static String get notificationWs => '$_wsApi/ws/notifications';

  // ── Timeouts ─────────────────────────────────────────────────
  static const int connectTimeout = 10000;
  static const int receiveTimeout = 10000;
  // ── Token keys ───────────────────────────────────────────────

  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String companyIdKey = 'company_id';

  // ============================================================
  // API CONSTANTS
  // ============================================================
  static const String staffIdKey = 'staff_id';
  static const String usernameKey = 'username';
  static const String fullNameKey = 'full_name';
  static const String roleKey = 'role';
  static const String statusKey = 'status';
  static const String isManagerKey = 'is_manager';
  static const String departmentIdKey = 'department_id';
}
