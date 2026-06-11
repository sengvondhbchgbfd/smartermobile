import '../entities/salary_adjustment_entity.dart';
import '../../data/model/salaries_adjust_model.dart';

abstract class SalariesAdjustRepository {
  Future<List<SalaryAdjustmentEntity>> getAdjustments(int salaryId);
  Future<SalaryAdjustmentEntity> createAdjustment(SalaryAdjustmentCreateDto data);
  Future<void> deleteAdjustment(int adjustmentId);
}