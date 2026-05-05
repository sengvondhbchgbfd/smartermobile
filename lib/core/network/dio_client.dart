import 'package:dio/dio.dart';
import 'package:frontendmobile/core/cache/cache_interceptor.dart';
import 'package:frontendmobile/core/cache/cache_service.dart';
import 'package:frontendmobile/core/network/interceptors/auth_interceptor.dart';
import 'package:frontendmobile/core/network/interceptors/error_interceptor.dart';
import 'package:frontendmobile/core/network/interceptors/logging_interceptor.dart';
import 'package:frontendmobile/core/network/network_info.dart';
import '../constants/api_constants.dart';
import '../storage/secure_storage_service.dart';

class DioClient {
  late final Dio dio;
  final SecureStorageService storage;
  final NetworkInfo networkInfo;
  final CacheService cacheService;

  ////////////////////////////////////////////////////////////////////
  //
  ////////////////////////////////////////////////////////////////////

  DioClient(this.storage, this.networkInfo, this.cacheService) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.apiBaseUrl,
        connectTimeout: Duration(milliseconds: ApiConstants.connectTimeout),
        receiveTimeout: Duration(milliseconds: ApiConstants.receiveTimeout),
        headers: {'Content-Type': 'application/json'},
      ),
    );
    _initializeInterceptors();
  }

  ////////////////////////////////////////////////////////////////////////
  // when real product no add parameter
  ////////////////////////////////////////////////////////////////////////

  void _initializeInterceptors() {
    dio.interceptors.addAll([
      LoggingInterceptor(
        logHeaders: false,
        logRequestBody: true,
        logResponseBody: true,
      ),

      //================================================================
      //enable loging for debug only
      //=================================================================
      // PrettyDioLogger(
      //   requestHeader: true,
      //   requestBody: true,
      //   responseBody: true,
      // ),
      /// 2. Auth (token + refresh)
      AuthInterceptor(dio: dio, storage: storage),
      // Cache
      CacheInterceptor(networkInfo: networkInfo, cacheService: cacheService),
      ErrorInterceptor(),
    ]);
  }
}
