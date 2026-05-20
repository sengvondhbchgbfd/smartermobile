import 'package:dartz/dartz.dart';
import 'package:frontendmobile/core/errors/failures.dart';
import 'package:frontendmobile/features/hr/salary_adjustments/domain/repositories/salary_adjust_repository.dart';

import '../entities/salary_adjustment_entity.dart';


class CreateAdjustmentUseCase {
  final ISalaryAdjustmentRepository _repo;
  const CreateAdjustmentUseCase(this._repo);

  Future<Either<Failure, SalaryAdjustmentEntity>> call({
    required int salaryId,
    required AdjustmentType adjustmentType,
    required double amount,
    String? reason,
  }) =>
      _repo.createAdjustment(
        salaryId:       salaryId,
        adjustmentType: adjustmentType,
        amount:         amount,
        reason:         reason,
      );
}

