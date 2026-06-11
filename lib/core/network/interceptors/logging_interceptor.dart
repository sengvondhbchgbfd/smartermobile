import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
class LoggingInterceptor extends Interceptor {
  final bool logRequestBody;
  final bool logResponseBody;
  final bool logHeaders;
  LoggingInterceptor({
    this.logRequestBody = true,
    this.logResponseBody = true,
    this.logHeaders = false,
  });
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('''
╔═══════════════════════════════════════════
📤 REQUEST → ${options.method} ${options.uri}

Headers:
${logHeaders ? options.headers : 'Hidden'}

Query:
${options.queryParameters}

Body:
${logRequestBody ? options.data : 'Hidden'}
╚═══════════════════════════════════════════
''');
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('''
╔═══════════════════════════════════════════
📥 RESPONSE ← ${response.statusCode} ${response.requestOptions.uri}

Data:
${logResponseBody ? response.data : 'Hidden'}
╚═══════════════════════════════════════════
''');
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('''
╔═══════════════════════════════════════════
❌ ERROR → ${err.requestOptions.method} ${err.requestOptions.uri}

Status Code:
${err.response?.statusCode}

Message:
${err.message}

Response:
${err.response?.data}
╚═══════════════════════════════════════════
''');
    }

    handler.next(err);
  }
}
