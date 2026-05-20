import 'package:dio/dio.dart';
import 'package:frontendmobile/core/constants/ApiEndpoints.dart';
import 'package:frontendmobile/features/hr/salaries/data/datasources/salaries_remote_datasource.dart';
import 'package:frontendmobile/features/hr/salaries/data/model/salaries_model.dart';

class SalaryRemoteDatasourceImpl implements SalaryRemoteDatasource {
  final Dio _dio;

  SalaryRemoteDatasourceImpl(this._dio);

  @override
  Future<List<SalaryModel>> getAll({int? staffId, String? status}) async {
    final params = <String, dynamic>{};
    if (staffId != null) params['staff_id'] = staffId;
    if (status != null) params['status'] = status;
    final res = await _dio.get(ApiEndpoints.salaries, queryParameters: params);
    return (res.data as List)
        .map((e) => SalaryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }




  @override
  Future<SalaryModel> getById(int salaryId) async {
    final res = await _dio.get(ApiEndpoints.salaryById(salaryId));
    return SalaryModel.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<List<SalaryModel>> getMySalaries() async {
    final res = await _dio.get(ApiEndpoints.salariesMy);
    return (res.data as List)
        .map((e) => SalaryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<SalaryModel> create(Map<String, dynamic> data) async {
    final res = await _dio.post(ApiEndpoints.salaries, data: data);
    return SalaryModel.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<SalaryModel> update(int salaryId, Map<String, dynamic> data) async {
    final res = await _dio.patch(ApiEndpoints.salaryById(salaryId), data: data);

    return SalaryModel.fromJson(res.data);
  }

  @override
  Future<SalaryModel> markPaid(int salaryId, String paymentDate) async {
    final res = await _dio.patch(
      ApiEndpoints.salaryMarkPaid(salaryId),
      data: {'payment_date': paymentDate},
    );
    return SalaryModel.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<void> delete(int salaryId) async {
    await _dio.delete(ApiEndpoints.salaryById(salaryId));
  }

  @override
  Future<Map<String, dynamic>> getSummary() async {
    final res = await _dio.get(ApiEndpoints.salariesSummary);
    return res.data as Map<String, dynamic>;
  }
}
