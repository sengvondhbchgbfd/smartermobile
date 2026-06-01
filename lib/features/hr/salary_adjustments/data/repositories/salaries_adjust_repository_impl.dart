import 'package:frontendmobile/features/hr/salary_adjustments/data/datasource/adjust_salaries_remote_datasource.dart';
import 'package:frontendmobile/features/hr/salary_adjustments/data/model/salaries_adjust_model.dart';
import 'package:frontendmobile/features/hr/salary_adjustments/domain/entities/salary_adjustment_entity.dart';
import 'package:frontendmobile/features/hr/salary_adjustments/domain/repositories/salary_adjust_repository.dart';

class SalariesAdjustRepositoryImpl implements SalariesAdjustRepository {
  final ISalaryAdjustmentRemoteDataSource datasource;
  SalariesAdjustRepositoryImpl(this.datasource);

  @override
  Future<List<SalaryAdjustmentEntity>> getAdjustments(int salaryId) async {
    final result = await datasource.getAdjustments(salaryId: salaryId);
    return result.map((e) => e.toEntity()).toList();
  }

  @override
  Future<SalaryAdjustmentEntity> createAdjustment(SalaryAdjustmentCreateDto data) async {
    final result = await datasource.createAdjustment(
      salaryId:       data.salaryId,
      adjustmentType: AdjustmentType.values.firstWhere((e) => e.name == data.type),
      amount:         data.amount,
      reason:         data.note,
    );
    return result.toEntity();
  }

  @override
  Future<void> deleteAdjustment(int adjustmentId) async {
    await datasource.deleteAdjustment(adjustmentId: adjustmentId);
  }
}