class ApiConstants {
  static const String baseUrl = String.fromEnvironment(
    "BASE_URL",
    // defaultValue: "http://localhost:8000",
    defaultValue: "http://192.168.181.130:8000",
  );

  static const String apiVersion = '/api/v1';
  static const String apiBaseUrl =
      '$baseUrl$apiVersion'; // ✅ http://localhost:8000/api/v1
  static const int connectTimeout = 10000;
  static const int receiveTimeout = 10000;
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String companyIdKey = 'company_id';
}
