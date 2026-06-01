import 'package:frontendmobile/features/hr/salaries/domain/entities/salaries_entity.dart';

class SalaryModel extends SalaryEntity {
  const SalaryModel({
    super.salaryId,
    required super.staffId,
    required super.managedBy,
    required super.baseSalary,
    required super.bonus,
    required super.deductions,
    required super.netSalary,
    required super.payPeriodStart,
    required super.payPeriodEnd,
    required super.paymentStatus,
    super.paymentDate,
    super.createdAt,
  });

  // ============================================================
  // FROM API  → APP (Response mapper)
  // ============================================================
  factory SalaryModel.fromJson(Map<String, dynamic> json) {
    return SalaryModel(
      salaryId: json['salary_id'] as int?,
      staffId: json['staff_id'] as int,
      managedBy: json['managed_by'] as int,
      baseSalary: double.parse(json['base_salary'].toString()),
      bonus: double.parse(json['bonus'].toString()),
      deductions: double.parse(json['deductions'].toString()),
      netSalary: double.parse(json['net_salary'].toString()),
      payPeriodStart: json['pay_period_start'] as String,
      payPeriodEnd: json['pay_period_end'] as String,
      paymentStatus: json['payment_status'] as String,
      paymentDate: json['payment_date'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  // ============================================================
  // APP → API (CREATE SALARY)  POST /salaries
  // Full payload required by backend
  // ============================================================
  Map<String, dynamic> toCreateJson() => {
    'staff_id': staffId,
    'managed_by': managedBy,
    'base_salary': baseSalary,
    'bonus': bonus,
    'deductions': deductions,
    'net_salary': netSalary,
    'pay_period_start': payPeriodStart,
    'pay_period_end': payPeriodEnd,
    'payment_status': paymentStatus,
    'payment_date': paymentDate,
  };

  // ============================================================
  // APP → API (UPDATE SALARY)  PATCH /salaries/{id}
  // Partial payload (only editable fields)
  // ============================================================
  Map<String, dynamic> toUpdateJson() => {
    'base_salary': baseSalary,
    'bonus': bonus,
    'deductions': deductions,
    'net_salary': netSalary,
    'payment_status': paymentStatus,
    'payment_date': paymentDate,
  };

  // ============================================================
  // CopyWith (🔥 Very useful for editing forms)
  // ============================================================
  SalaryModel copyWith({
    int? salaryId,
    int? staffId,
    int? managedBy,
    double? baseSalary,
    double? bonus,
    double? deductions,
    double? netSalary,
    String? payPeriodStart,
    String? payPeriodEnd,
    String? paymentStatus,
    String? paymentDate,
    String? createdAt,
  }) {
    return SalaryModel(
      salaryId: salaryId ?? this.salaryId,
      staffId: staffId ?? this.staffId,
      managedBy: managedBy ?? this.managedBy,
      baseSalary: baseSalary ?? this.baseSalary,
      bonus: bonus ?? this.bonus,
      deductions: deductions ?? this.deductions,
      netSalary: netSalary ?? this.netSalary,
      payPeriodStart: payPeriodStart ?? this.payPeriodStart,
      payPeriodEnd: payPeriodEnd ?? this.payPeriodEnd,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentDate: paymentDate ?? this.paymentDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

}
