class ApiConstants {
  static const String baseUrl = String.fromEnvironment(
    "BASE_URL",
    // defaultValue: "http://localhost:8000 //192.168.217.130 ||  192.168.171.130 | 192.168.51.130 | 192.168.51.130 | 192.168.91.130 | 192.168.244.130',
<<<<<<< HEAD
    defaultValue: "http://192.168.105.130:8000",
  );

  static const String apiVersion = '/api/v1';
  static const String apiBaseUrl =
      '$baseUrl$apiVersion'; // ✅ http://localhost:8000/api/v1
=======
    defaultValue: "http://192.168.117.130:8000",
  );

  static const String apiVersion = '/api/v1';
  static const String apiBaseUrl = '$baseUrl$apiVersion';
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
  // ── WebSocket ────────────────────────────────────────────────

  static String get wsBaseUrl => baseUrl
      .replaceFirst("https://", "wss://")
      .replaceFirst("http://", "ws://");
<<<<<<< HEAD
  static String chatWs(int groupId) => '/ws/chat/$groupId';
=======

  // full ws base including api version
  static String get _wsApi => '$wsBaseUrl$apiVersion';
  static String chatWs(int groupId) => '$_wsApi/ws/chat/$groupId';
  static String get notificationWs => '$_wsApi/ws/notifications';
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c

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
<<<<<<< HEAD
=======
  static const String departmentIdKey = 'department_id';
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
}
