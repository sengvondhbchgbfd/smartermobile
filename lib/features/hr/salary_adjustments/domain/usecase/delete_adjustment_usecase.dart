import 'package:frontendmobile/features/hr/salary_adjustments/domain/repositories/salary_adjust_repository.dart';

class DeleteAdjustmentUsecase {
  final SalariesAdjustRepository repo;
  DeleteAdjustmentUsecase(this.repo);
  Future<void> call(int adjustmentId) =>
      repo.deleteAdjustment(adjustmentId);
}
