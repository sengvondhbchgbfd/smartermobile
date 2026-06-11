import 'package:dio/dio.dart';

class ApiErrorHandler {
  static String getMessage(DioException e) {
    final data = e.response?.data;

    if (data is Map) {
      final detail = data['detail'];

      // ----------------------
      if (detail is Map) {
        return detail['message']?.toString() ??
            'Something went wrong. Please try again.';
      }

      // ---------------------
      if (detail is String) return detail;

      //=================================
      // ← fallback to message field
      //=================================
      if (data['message'] != null) return data['message'].toString();
    }

    if (e.message != null && e.message!.isNotEmpty) return e.message!;

    return 'Something went wrong. Please try again.';
  }
}
