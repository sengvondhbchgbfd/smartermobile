import 'package:dio/dio.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Example mapping
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
        print("Connection Timeout");
        break;
      case DioExceptionType.badResponse:
        print("Server Error: ${err.response?.statusCode}");
        break;
      default:
        print("Unexpected Error");
    }

    super.onError(err, handler);
  }
}
