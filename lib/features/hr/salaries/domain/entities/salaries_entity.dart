class SalaryEntity {
  final int? salaryId;
  final int staffId;
  final int managedBy;
  final double baseSalary;
  final double bonus;
  final double deductions;
  final double netSalary;
  final String payPeriodStart;
  final String payPeriodEnd;
  final String paymentStatus; // pending | paid
  final String? paymentDate;
  final String? createdAt;

  const SalaryEntity({
    this.salaryId,
    required this.staffId,
    required this.managedBy,
    required this.baseSalary,
    required this.bonus,
    required this.deductions,
    required this.netSalary,
    required this.payPeriodStart,
    required this.payPeriodEnd,
    required this.paymentStatus,
    this.paymentDate,
    this.createdAt,
  });

  factory SalaryEntity.fromJson(Map<String, dynamic> json) {
    return SalaryEntity(
      salaryId: json['salary_id'] as int?,
      staffId: json['staff_id'] as int? ?? 0,
      managedBy: json['managed_by'] as int? ?? 0,
      baseSalary: _toDouble(json['base_salary']),
      bonus: _toDouble(json['bonus']),
      deductions: _toDouble(json['deductions']),
      netSalary: _toDouble(json['net_salary']),
      payPeriodStart: json['pay_period_start'] as String? ?? '',
      payPeriodEnd: json['pay_period_end'] as String? ?? '',
      paymentStatus: json['payment_status'] as String? ?? 'pending',
      paymentDate: json['payment_date'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  /// Safely parses a value that may be a String, int, or double into double.
  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() => {
    'salary_id': salaryId,
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
    'created_at': createdAt,
  };
}
