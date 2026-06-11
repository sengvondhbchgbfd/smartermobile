import 'package:frontendmobile/features/hr/salary_adjustments/domain/entities/salary_adjustment_entity.dart';

enum AdjustmentType { bonus, deduction }

class SalaryAdjustmentModel {
  final int id;
  final int salaryId;
  final AdjustmentType type;
  final double amount;
  final String? note;
  final int adjustedByStaffId;
  final DateTime createdAt;

  SalaryAdjustmentModel({
    required this.id,
    required this.salaryId,
    required this.type,
    required this.amount,
    this.note,
    required this.adjustedByStaffId,
    required this.createdAt,
  });

  factory SalaryAdjustmentModel.fromJson(Map<String, dynamic> json) {
    return SalaryAdjustmentModel(
      id: json['adjustment_id'],
      salaryId: json['salary_id'],
      type: AdjustmentType.values.firstWhere(
        (e) => e.name == json['adjustment_type'],
      ),
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      note: json['reason'],
      adjustedByStaffId: json['adjusted_by'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  SalaryAdjustmentEntity toEntity() => SalaryAdjustmentEntity(
    id: id,
    salaryId: salaryId,
    type: type.name,
    amount: amount,
    note: note,
    adjustedByStaffId: adjustedByStaffId,
    createdAt: createdAt,
  );
}

class SalaryAdjustmentCreateDto {
  final int salaryId;
  final String type;
  final double amount;
  final String? note;

  SalaryAdjustmentCreateDto({
    required this.salaryId,
    required this.type,
    required this.amount,
    this.note,
  });

  Map<String, dynamic> toJson() => {
    'salary_id': salaryId,
    'adjustment_type': type,
    'amount': amount,
    if (note != null) 'reason': note,
  };
}
