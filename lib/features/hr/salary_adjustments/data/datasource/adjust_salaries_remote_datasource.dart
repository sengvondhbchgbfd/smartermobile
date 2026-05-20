import 'package:frontendmobile/features/hr/salary_adjustments/data/model/salaries_adjust_model.dart';
import 'package:frontendmobile/features/hr/salary_adjustments/domain/entities/salary_adjustment_entity.dart';

abstract class ISalaryAdjustmentRemoteDataSource {
  Future<List<SalaryAdjustmentModel>> getAdjustments({required int salaryId});
 
  Future<SalaryAdjustmentModel> createAdjustment({
    required int salaryId,
    required AdjustmentType adjustmentType,
    required double amount,
    String? reason,
  });
 
  Future<String> deleteAdjustment({required int adjustmentId});
}

 