enum AdjustmentType { bonus, deduction }

class SalaryAdjustmentEntity {
  final int adjustmentId;
  final int companyId;
  final int salaryId;
  final int adjustedBy;
  final AdjustmentType adjustmentType;
  final double amount;
  final String? reason;
  final DateTime createdAt;

  const SalaryAdjustmentEntity({
    required this.adjustmentId,
    required this.companyId,
    required this.salaryId,
    required this.adjustedBy,
    required this.adjustmentType,
    required this.amount,
    this.reason,
    required this.createdAt,
  });
}