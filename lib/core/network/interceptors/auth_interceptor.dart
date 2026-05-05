import 'dart:async';

import 'package:dio/dio.dart';
import 'package:frontendmobile/core/storage/secure_storage_service.dart';
import 'package:frontendmobile/core/constants/ApiEndpoints.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final SecureStorageService storage;
  Completer<bool>? _refrshCompleter;
  AuthInterceptor({required this.dio, required this.storage});
  ///////////////////////////////////////////////////////////////////////
  // ADD TOKEN TO REQUEST
  //////////////////////////////////////////////////////////////////////
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

  //////////////////////////////////////////////////////////////////////
  // HANDLE ERRORS
  //////////////////////////////////////////////////////////////////////
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final request = err.requestOptions;

    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    if (request.path == ApiEndpoints.refresh) {
      return handler.next(err);
    }

    if (request.extra['retried'] == true) {
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

  /////////////////////////////////////////////////////////////////////
  // REFRESH TOKEN (SAFE)
  /////////////////////////////////////////////////////////////////////

  Future<bool> _refreshToken() async {
    if (_refrshCompleter != null) {
      return _refrshCompleter!.future;
    }
    _refrshCompleter = Completer();
    try {
      final refreshToken = await storage.getRefreshToken();
      if (refreshToken == null) return false;
      final refreshDio = Dio(BaseOptions(baseUrl: dio.options.baseUrl));

      final response = await refreshDio.post(
        ApiEndpoints.refresh,
        data: {'refresh_token': refreshToken},
      );

      await storage.saveTokens(
        accessToken: response.data['access_token'],
        refreshToken: response.data['refresh_token'],
      );

      _refrshCompleter!.complete(true);
      return true;
    } catch (_) {
      return false;
    } finally {
      _refrshCompleter = null;
    }
  }

  /////////////////////////////////////////////////////////////////////
  // CLONE REQUEST
  /////////////////////////////////////////////////////////////////////
  RequestOptions _cloneRequest(RequestOptions request) {
    return RequestOptions(
      path: request.path,
      method: request.method,
      baseUrl: request.method,
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
