import 'package:frontendmobile/features/hr/salary_adjustments/data/model/salaries_adjust_model.dart';
import 'package:frontendmobile/features/hr/salary_adjustments/domain/repositories/salary_adjust_repository.dart';

import '../entities/salary_adjustment_entity.dart';

class CreateAdjustmentUsecase {
  final SalariesAdjustRepository repo;
  CreateAdjustmentUsecase(this.repo);
  Future<SalaryAdjustmentEntity> call(SalaryAdjustmentCreateDto data) =>
      repo.createAdjustment(data);
}

