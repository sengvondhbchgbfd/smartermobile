import 'package:frontendmobile/features/hr/salaries/domain/entities/salaries_entity.dart';

class SalaryModel extends SalaryEntity {
  const SalaryModel({
    super.salaryId,
    required super.staffId,
    super.managedBy,          // ✅ nullable
    required super.baseSalary,
    required super.bonus,
    required super.deductions,
    super.netSalary,          // ✅ nullable
    required super.payPeriodStart,
    required super.payPeriodEnd,
    required super.paymentStatus,
    super.paymentDate,
    super.createdAt,
  });

  factory SalaryModel.fromJson(Map<String, dynamic> json) => SalaryModel(
    salaryId:       json['salary_id']  as int?,
    staffId:        json['staff_id']   as int? ?? 0,
    managedBy:      json['managed_by'] as int?,           // ✅ nullable
    baseSalary:     _toDouble(json['base_salary']),
    bonus:          _toDouble(json['bonus']),
    deductions:     _toDouble(json['deductions']),
    netSalary:      json['net_salary'] != null            // ✅ nullable
        ? _toDouble(json['net_salary'])
        : null,
    payPeriodStart: DateTime.parse(json['pay_period_start'] as String), // ✅ DateTime
    payPeriodEnd:   DateTime.parse(json['pay_period_end']   as String), // ✅ DateTime
    paymentStatus:  json['payment_status'] as String? ?? 'pending',
    paymentDate:    json['payment_date'] != null                        // ✅ DateTime
        ? DateTime.parse(json['payment_date'] as String)
        : null,
    createdAt:      json['created_at'] != null                          // ✅ DateTime
        ? DateTime.parse(json['created_at'] as String)
        : null,
  );

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toCreateJson() => {
    'staff_id':        staffId,
    'managed_by':      managedBy,
    'base_salary':     baseSalary,
    'bonus':           bonus,
    'deductions':      deductions,
    'pay_period_start': payPeriodStart.toIso8601String().split('T').first, // ✅ date only
    'pay_period_end':   payPeriodEnd.toIso8601String().split('T').first,   // ✅ date only
    'payment_status':  paymentStatus,
    'payment_date':    paymentDate?.toIso8601String().split('T').first,
  };

  Map<String, dynamic> toUpdateJson() => {
    'base_salary':    baseSalary,
    'bonus':          bonus,
    'deductions':     deductions,
    'payment_status': paymentStatus,
    'payment_date':   paymentDate?.toIso8601String().split('T').first,
  };

  SalaryModel copyWith({
    int?      salaryId,
    int?      staffId,
    int?      managedBy,
    double?   baseSalary,
    double?   bonus,
    double?   deductions,
    double?   netSalary,
    DateTime? payPeriodStart, // ✅ DateTime
    DateTime? payPeriodEnd,   // ✅ DateTime
    String?   paymentStatus,
    DateTime? paymentDate,    // ✅ DateTime
    DateTime? createdAt,      // ✅ DateTime
  }) => SalaryModel(
    salaryId:       salaryId       ?? this.salaryId,
    staffId:        staffId        ?? this.staffId,
    managedBy:      managedBy      ?? this.managedBy,
    baseSalary:     baseSalary     ?? this.baseSalary,
    bonus:          bonus          ?? this.bonus,
    deductions:     deductions     ?? this.deductions,
    netSalary:      netSalary      ?? this.netSalary,
    payPeriodStart: payPeriodStart ?? this.payPeriodStart,
    payPeriodEnd:   payPeriodEnd   ?? this.payPeriodEnd,
    paymentStatus:  paymentStatus  ?? this.paymentStatus,
    paymentDate:    paymentDate    ?? this.paymentDate,
    createdAt:      createdAt      ?? this.createdAt,
  );
}