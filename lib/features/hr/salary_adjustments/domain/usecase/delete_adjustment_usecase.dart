import 'package:dartz/dartz.dart';
import 'package:frontendmobile/core/errors/failures.dart';
import 'package:frontendmobile/features/hr/salary_adjustments/domain/repositories/salary_adjust_repository.dart';

class DeleteAdjustmentUseCase {
  final ISalaryAdjustmentRepository _repo;
  const DeleteAdjustmentUseCase(this._repo);

  Future<Either<Failure, String>> call({required int adjustmentId}) =>
      _repo.deleteAdjustment(adjustmentId: adjustmentId);
}
