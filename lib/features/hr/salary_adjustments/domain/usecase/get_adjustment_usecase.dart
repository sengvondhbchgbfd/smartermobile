import 'package:dartz/dartz.dart';
import 'package:frontendmobile/core/errors/failures.dart';
import 'package:frontendmobile/features/hr/salary_adjustments/domain/entities/salary_adjustment_entity.dart';
import 'package:frontendmobile/features/hr/salary_adjustments/domain/repositories/salary_adjust_repository.dart';




class GetAdjustmentsUseCase {
  final ISalaryAdjustmentRepository _repo;
  const GetAdjustmentsUseCase(this._repo);

  Future<Either<Failure, List<SalaryAdjustmentEntity>>> call({
    required int salaryId,
  }) =>
      _repo.getAdjustments(salaryId: salaryId);
}

