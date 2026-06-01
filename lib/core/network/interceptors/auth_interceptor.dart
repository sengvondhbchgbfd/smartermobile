import 'dart:async';

import 'package:dio/dio.dart';
import 'package:frontendmobile/core/storage/secure_storage_service.dart';
import 'package:frontendmobile/core/constants/ApiEndpoints.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final SecureStorageService storage;
  Completer<bool>? _refreshCompleter;

  AuthInterceptor({required this.dio, required this.storage});

  // ── Attach token to every request ──────────────────────────────────────────
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await storage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  // ── Handle errors ───────────────────────────────────────────────────────────
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final request = err.requestOptions;

    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }
    ////////////////////////////////////////////////////////////////////////////
    // Don't retry the refresh endpoint itself — infinite loop prevention
    ////////////////////////////////////////////////////////////////////////////
    if (request.path == ApiEndpoints.refresh) {
      await storage.clearAuth();
      return handler.next(err);
    }

    ////////////////////////////////////////////////////////////////////////////
    // Don't retry a request that already was retried
    ////////////////////////////////////////////////////////////////////////////

    if (request.extra['retried'] == true) {
      await storage.clearAuth();
      return handler.next(err);
    }

    try {
      final success = await _refreshToken();

      if (!success) {
        await storage.clearAuth();
        return handler.next(err);
      }

      final newToken = await storage.getAccessToken();
      final retryRequest = _cloneRequest(request);
      retryRequest.headers['Authorization'] = 'Bearer $newToken';
      retryRequest.extra['retried'] = true;

      final response = await dio.fetch(retryRequest);
      return handler.resolve(response);
    } catch (e) {
      await storage.clearAuth();
      return handler.next(err);
    }
  }
  ////////////////////////////////////////////////////////////////////////////
  // ── Refresh token — safe for concurrent requests ────────────────────────────
  ////////////////////////////////////////////////////////////////////////////

  Future<bool> _refreshToken() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<bool>();

    try {
      final refreshToken = await storage.getRefreshToken();
      if (refreshToken == null) {
        _refreshCompleter!.complete(false);
        return false;
      }
      //////////////////////////////////////////////////////////////////////////////
      // Use a separate Dio so the interceptor doesn't intercept the refresh call
      //////////////////////////////////////////////////////////////////////////////
      final refreshDio = Dio(BaseOptions(baseUrl: dio.options.baseUrl));

      final response = await refreshDio.post(
        ApiEndpoints.refresh,
        data: {'refresh_token': refreshToken},
      );

      await storage.saveTokens(
        accessToken: response.data['access_token'],
        refreshToken: response.data['refresh_token'],
      );

      _refreshCompleter!.complete(true);
      return true;
    } catch (_) {
      _refreshCompleter!.complete(false);
      return false;
    } finally {
      _refreshCompleter = null;
    }
  }

  // ── Clone request ───────────────────────────────────────────────────────────
  RequestOptions _cloneRequest(RequestOptions request) {
    return RequestOptions(
      path: request.path,
      method: request.method,
      baseUrl: request.baseUrl,
      data: request.data,
      queryParameters: request.queryParameters,
      headers: Map<String, dynamic>.from(request.headers),
      extra: Map<String, dynamic>.from(request.extra),
      contentType: request.contentType,
      sendTimeout: request.sendTimeout,
      receiveTimeout: request.receiveTimeout,
    );
  }
}
