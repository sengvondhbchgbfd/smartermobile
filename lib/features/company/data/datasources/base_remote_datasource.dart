import 'package:dio/dio.dart';
import 'package:frontendmobile/core/errors/exceptions.dart';

abstract class BaseRemoteDatasource {
  ////////////////////////////////////////////////////////////////////
  //
  ///////////////////////////////////////////////////////////////////
  dynamic extractData(Response response) {
    final body = response.data;
    if (body == null) {
      throw ServerException(
        message: 'Empty server response',
        statusCode: response.statusCode ?? 500,
      );
    }
    return body['data'] ?? body;
  }
  ////////////////////////////////////////////////////////////////////
  //
  ///////////////////////////////////////////////////////////////////

  Future<T> safeRequest<T>({
    required Future<Response> Function() request,
    required T Function(dynamic data) parser,
  }) async {
    try {
      final response = await request();
      final data = extractData(response);
      return parser(data);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Server error',
        statusCode: e.response?.statusCode ?? 500,
      );
    }
  }
}
