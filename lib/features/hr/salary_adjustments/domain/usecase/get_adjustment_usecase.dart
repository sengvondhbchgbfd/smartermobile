import 'package:frontendmobile/features/hr/salary_adjustments/domain/entities/salary_adjustment_entity.dart';
import 'package:frontendmobile/features/hr/salary_adjustments/domain/repositories/salary_adjust_repository.dart';

class GetAdjustmentsUsecase {
  final SalariesAdjustRepository repo;
  GetAdjustmentsUsecase(this.repo);
  Future<List<SalaryAdjustmentEntity>> call(int salaryId) =>
      repo.getAdjustments(salaryId);
}
