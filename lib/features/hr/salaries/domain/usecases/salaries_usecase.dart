<<<<<<< HEAD
=======
import 'package:frontendmobile/features/hr/salaries/data/model/salary_staff_group_model.dart';
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
import 'package:frontendmobile/features/hr/salaries/domain/entities/salaries_entity.dart';
import 'package:frontendmobile/features/hr/salaries/domain/entities/salary_staff_group_entity.dart';
import 'package:frontendmobile/features/hr/salaries/domain/repositories/salaries_repository.dart';

class GetAllSalariesUseCase {
  final SalaryRepository _repo;
  GetAllSalariesUseCase(this._repo);
  Future<List<SalaryEntity>> call({int? staffId, String? status}) =>
      _repo.getAll(staffId: staffId, status: status);
}

class GetSalariesGroupCase {
  final SalaryRepository _repo;

  GetSalariesGroupCase(this._repo);

  Future<List<SalaryStaffGroupEntity>> call() {
    return _repo.getGroupedByStaff();
  }
}

class GetSalaryByIdUseCase {
  final SalaryRepository _repo;
  GetSalaryByIdUseCase(this._repo);
  Future<SalaryEntity> call(int salaryId) => _repo.getById(salaryId);
}

class GetMySalariesUseCase {
  final SalaryRepository _repo;
  GetMySalariesUseCase(this._repo);
  Future<List<SalaryEntity>> call() => _repo.getMySalaries();
}

class CreateSalaryUseCase {
  final SalaryRepository _repo;
  CreateSalaryUseCase(this._repo);
  Future<SalaryEntity> call(SalaryEntity salary) => _repo.create(salary);
}

class UpdateSalaryUseCase {
  final SalaryRepository _repo;
  UpdateSalaryUseCase(this._repo);
  Future<SalaryEntity> call(int salaryId, SalaryEntity salary) =>
      _repo.update(salaryId, salary);
}

class MarkPaidUseCase {
  final SalaryRepository _repo;
  MarkPaidUseCase(this._repo);
  Future<SalaryEntity> call(int salaryId, String paymentDate) =>
      _repo.markPaid(salaryId, paymentDate);
}

class DeleteSalaryUseCase {
  final SalaryRepository _repo;
  DeleteSalaryUseCase(this._repo);
  Future<void> call(int salaryId) => _repo.delete(salaryId);
}

class GetSalarySummaryUseCase {
  final SalaryRepository _repo;
  GetSalarySummaryUseCase(this._repo);
  Future<Map<String, dynamic>> call() => _repo.getSummary();
}
