import 'package:dartz/dartz.dart';
import 'package:frontendmobile/core/errors/exceptions.dart';
import 'package:frontendmobile/core/errors/failures.dart';
import 'package:frontendmobile/features/hr/salary_adjustments/data/datasource/adjust_salaries_remote_datasource.dart';
import 'package:frontendmobile/features/hr/salary_adjustments/domain/repositories/salary_adjust_repository.dart';

import '../../domain/entities/salary_adjustment_entity.dart';


class SalaryAdjustmentRepositoryImpl implements ISalaryAdjustmentRepository {
  final ISalaryAdjustmentRemoteDataSource _remote;

  const SalaryAdjustmentRepositoryImpl(this._remote);

  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, List<SalaryAdjustmentEntity>>> getAdjustments({
    required int salaryId,
  }) async {
    try {
      final result = await _remote.getAdjustments(salaryId: salaryId);
      return Right(result);
    } on ServerEception catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, SalaryAdjustmentEntity>> createAdjustment({
    required int salaryId,
    required AdjustmentType adjustmentType,
    required double amount,
    String? reason,
  }) async {
    try {
      final result = await _remote.createAdjustment(
        salaryId:       salaryId,
        adjustmentType: adjustmentType,
        amount:         amount,
        reason:         reason,
      );
      return Right(result);
    } on ServerEception catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, String>> deleteAdjustment({
    required int adjustmentId,
  }) async {
    try {
      final message = await _remote.deleteAdjustment(
        adjustmentId: adjustmentId,
      );
      return Right(message);
    } on ServerEception catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
