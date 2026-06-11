import 'package:dio/dio.dart';
import '../network/network_info.dart';
import '../cache/cache_service.dart';

class CacheInterceptor extends Interceptor {
  final NetworkInfo networkInfo;
  final CacheService cacheService;

  CacheInterceptor({required this.networkInfo, required this.cacheService});

  ///////////////////////////////////////////////////////////////////////
  //
  //////////////////////////////////////////////////////////////////////

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      final cached = cacheService.get(options.uri.toString());

      if (cached != null) {
        return handler.resolve(
          Response(requestOptions: options, data: cached, statusCode: 200),
        );
      }
    }

    handler.next(options);
  }

  /////////////////////////////////////////////////////////////////////
  //
  ////////////////////////////////////////////////////////////////////

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    if (response.requestOptions.method == 'GET') {
      await cacheService.save(
        response.requestOptions.uri.toString(),
        response.data,
      );
    }

    handler.next(response);
  }
}
