import 'package:dio/dio.dart';
import 'package:frontendmobile/core/constants/ApiEndpoints.dart';
import 'package:frontendmobile/core/errors/exceptions.dart';
import 'package:frontendmobile/core/network/dio_client.dart';
import '../models/stock_movement_report_model.dart';




abstract class StockMovementReportRemoteDataSource {
  Future<StockMovementReportResponse> getReport({
    String period = 'all',
    int? categoryId,
    int? variantId,
    bool includeBalance = false,
    DateTime? start,
    DateTime? end,
  });
}

class StockMovementReportRemoteDataSourceImpl
    implements StockMovementReportRemoteDataSource {
  final DioClient _dioClient;
  StockMovementReportRemoteDataSourceImpl(this._dioClient);
  Dio get _dio => _dioClient.dio;

  Never _throw(DioException e) {
    final detail = e.response?.data;
    final message = detail is Map
        ? (detail['detail'] ?? e.message ?? 'Error').toString()
        : e.message ?? 'Error';
    throw ApiException(
      statusCode: e.response?.statusCode ?? 0,
      message: message,
    );
  }

  @override
  Future<StockMovementReportResponse> getReport({
    String period = 'all',
    int? categoryId,
    int? variantId,
    bool includeBalance = false,
    DateTime? start,
    DateTime? end,
  }) async {
    try {
      final res = await _dio.get(
        ApiEndpoints.stockMovementReports,
        queryParameters: {
          'period': period,
          if (categoryId != null) 'category_id': categoryId,
          if (variantId != null) 'variant_id': variantId,
          'include_balance': includeBalance,
          if (start != null) 'start_date': start.toIso8601String(),
          if (end != null) 'end_date': end.toIso8601String(),
        },
      );
      return StockMovementReportResponse.fromJson(
        res.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      _throw(e);
    }
  }

  String _fmt(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
