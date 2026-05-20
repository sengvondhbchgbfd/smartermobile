import 'package:frontendmobile/features/hr/salaries/data/model/salaries_model.dart';

abstract class SalaryRemoteDatasource {
  Future<List<SalaryModel>> getAll({int? staffId, String? status});
  Future<SalaryModel> getById(int salaryId);
  Future<List<SalaryModel>> getMySalaries();
  Future<SalaryModel> create(Map<String, dynamic> data);
  Future<SalaryModel> update(int salaryId, Map<String, dynamic> data);
  Future<SalaryModel> markPaid(int salaryId, String paymentDate);
  Future<void> delete(int salaryId);
  Future<Map<String, dynamic>> getSummary();
}
