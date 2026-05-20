import 'package:dartz/dartz.dart';
import 'package:frontendmobile/core/errors/failures.dart';

import '../entities/salary_adjustment_entity.dart';

abstract class ISalaryAdjustmentRepository {
  Future<Either<Failure, List<SalaryAdjustmentEntity>>> getAdjustments({
    required int salaryId,
  });

  Future<Either<Failure, SalaryAdjustmentEntity>> createAdjustment({
    required int salaryId,
    required AdjustmentType adjustmentType,
    required double amount,
    String? reason,
  });

  Future<Either<Failure, String>> deleteAdjustment({required int adjustmentId});
}
