import 'package:frontendmobile/features/hr/salaries/domain/entities/salaries_entity.dart';

abstract class SalaryRepository {
  Future<List<SalaryEntity>> getAll({int? staffId, String? status});




  Future<SalaryEntity> getById(int salaryId);

  Future<List<SalaryEntity>> getMySalaries();

  Future<SalaryEntity> create(SalaryEntity salary);

  Future<SalaryEntity> update(int salaryId, SalaryEntity salary);

  Future<SalaryEntity> markPaid(int salaryId, String paymentDate);

  Future<void> delete(int salaryId);

  Future<Map<String, dynamic>> getSummary();
}
