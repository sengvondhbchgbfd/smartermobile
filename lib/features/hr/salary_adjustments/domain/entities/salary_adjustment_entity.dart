class SalaryAdjustmentEntity {
  final int id;
  final int salaryId;
  final String type; // 'bonus' | 'deduction'
  final double amount;
  final String? note;
  final int adjustedByStaffId;
  final DateTime createdAt;

  const SalaryAdjustmentEntity({
    required this.id,
    required this.salaryId,
    required this.type,
    required this.amount,
    this.note,
    required this.adjustedByStaffId,
    required this.createdAt,
  });
}