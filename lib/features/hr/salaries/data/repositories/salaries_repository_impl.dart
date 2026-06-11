import 'package:frontendmobile/features/hr/salaries/data/datasources/salaries_remote_datasource.dart';
import 'package:frontendmobile/features/hr/salaries/data/model/salaries_model.dart';
import 'package:frontendmobile/features/hr/salaries/data/model/salary_staff_group_model.dart';
import 'package:frontendmobile/features/hr/salaries/domain/entities/salaries_entity.dart';
import 'package:frontendmobile/features/hr/salaries/domain/entities/salary_staff_group_entity.dart';
import 'package:frontendmobile/features/hr/salaries/domain/repositories/salaries_repository.dart';

class SalaryRepositoryImpl implements SalaryRepository {
  final SalaryRemoteDatasource _datasource;

  SalaryRepositoryImpl(this._datasource);

  @override
  Future<List<SalaryEntity>> getAll({int? staffId, String? status}) =>
      _datasource.getAll(staffId: staffId, status: status);

  @override
  Future<List<SalaryStaffGroupEntity>> getGroupedByStaff() async {
    final models = await _datasource.getGroupedByStaff();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<SalaryEntity> getById(int salaryId) => _datasource.getById(salaryId);

  @override
  Future<List<SalaryEntity>> getMySalaries() => _datasource.getMySalaries();

  @override
  Future<SalaryEntity> create(SalaryEntity salary) =>
      _datasource.create((salary as SalaryModel).toCreateJson());

  @override
  Future<SalaryEntity> update(int salaryId, SalaryEntity salary) =>
      _datasource.update(salaryId, (salary as SalaryModel).toUpdateJson());

  @override
  Future<SalaryEntity> markPaid(int salaryId, String paymentDate) =>
      _datasource.markPaid(salaryId, paymentDate);

  @override
  Future<void> delete(int salaryId) => _datasource.delete(salaryId);

  @override
  Future<Map<String, dynamic>> getSummary() => _datasource.getSummary();
}
