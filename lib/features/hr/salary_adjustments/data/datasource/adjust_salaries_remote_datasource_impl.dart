import 'package:dio/dio.dart';
import 'package:frontendmobile/core/constants/ApiEndpoints.dart';
import 'package:frontendmobile/core/errors/exceptions.dart';
import 'package:frontendmobile/features/hr/salary_adjustments/data/datasource/adjust_salaries_remote_datasource.dart';
import 'package:frontendmobile/features/hr/salary_adjustments/data/model/salaries_adjust_model.dart';

class SalaryAdjustmentRemoteDataSource
    implements ISalaryAdjustmentRemoteDataSource {
  final Dio _dio;

  const SalaryAdjustmentRemoteDataSource(this._dio);

  // ---------------------------------------------------------------------------
  @override
  Future<List<SalaryAdjustmentModel>> getAdjustments({
    required int salaryId,
  }) async {
    try {
      final response = await _dio.get(ApiEndpoints.salaryAdjustments(salaryId));
      final data = response.data as List<dynamic>;
      return data
          .map((e) => SalaryAdjustmentModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerEception(message: _parseError(e));
    }
  }

  // ---------------------------------------------------------------------------

  @override
  Future<SalaryAdjustmentModel> createAdjustment({
    required int salaryId,
    required AdjustmentType adjustmentType,
    required double amount,
    String? reason,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.createAdjustment,
        data: {
          'salary_id': salaryId,
          'adjustment_type': adjustmentType.name,
          'amount': amount,
          if (reason != null && reason.isNotEmpty) 'reason': reason,
        },
      );
      return SalaryAdjustmentModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ServerEception(message: _parseError(e));
    }
  }

  // ---------------------------------------------------------------------------

  @override
  Future<String> deleteAdjustment({required int adjustmentId}) async {
    try {
      final response = await _dio.delete(
        ApiEndpoints.adjustmentById(adjustmentId),
      );
      return (response.data as Map<String, dynamic>)['message'] as String;
    } on DioException catch (e) {
      throw ServerEception(message: _parseError(e));
    }
  }

  // ---------------------------------------------------------------------------

  String _parseError(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      return data['detail'] as String? ?? 'Unknown error';
    }
    return e.message ?? 'Unknown error';
  }
}

// ── Riverpod provider ─────────────────────────────────────────────────────────
