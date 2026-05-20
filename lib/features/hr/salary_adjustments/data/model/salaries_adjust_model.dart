import 'package:frontendmobile/features/hr/salary_adjustments/domain/entities/salary_adjustment_entity.dart';

class SalaryAdjustmentModel extends SalaryAdjustmentEntity {
  const SalaryAdjustmentModel({
    required super.adjustmentId,
    required super.companyId,
    required super.salaryId,
    required super.adjustedBy,
    required super.adjustmentType,
    required super.amount,
    super.reason,
    required super.createdAt,
  });

  factory SalaryAdjustmentModel.fromJson(Map<String, dynamic> json) {
    return SalaryAdjustmentModel(
      adjustmentId:   json['adjustment_id'] as int,
      companyId:      json['company_id'] as int,
      salaryId:       json['salary_id'] as int,
      adjustedBy:     json['adjusted_by'] as int,
      adjustmentType: json['adjustment_type'] == 'bonus'
          ? AdjustmentType.bonus
          : AdjustmentType.deduction,
      amount:         (json['amount'] as num).toDouble(),
      reason:         json['reason'] as String?,
      createdAt:      DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'adjustment_id':   adjustmentId,
    'company_id':      companyId,
    'salary_id':       salaryId,
    'adjusted_by':     adjustedBy,
    'adjustment_type': adjustmentType == AdjustmentType.bonus ? 'bonus' : 'deduction',
    'amount':          amount,
    'reason':          reason,
    'created_at':      createdAt.toIso8601String(),
  };
}