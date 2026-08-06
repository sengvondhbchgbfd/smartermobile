import 'package:dio/dio.dart';
import 'package:frontendmobile/core/network/dio_client.dart';
import 'package:frontendmobile/features/dashboard/data/models/dashboard_stats.dart';

class DashboardRemoteDatasource {
  final DioClient _dioClient;
  Dio get _dio => _dioClient.dio;

  DashboardRemoteDatasource(this._dioClient);

  Future<DashboardStatsModel> getStats({int days = 11}) async {
    final res = await _dio.get(
      '/dashboard/stats',
      queryParameters: {'days': days},
    );
    return DashboardStatsModel.fromJson(res.data);
  }
}
