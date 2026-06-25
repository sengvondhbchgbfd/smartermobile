import 'package:flutter/material.dart';

class SalaryEntity {
  final int? salaryId;
  final int staffId;
  final int? managedBy; // ✅ nullable
  final double baseSalary;
  final double bonus;
  final double deductions;
  final double? netSalary; // ✅ nullable
  final DateTime payPeriodStart; // ✅ DateTime not String
  final DateTime payPeriodEnd; // ✅ DateTime not String
  final String paymentStatus;
  final DateTime? paymentDate; // ✅ DateTime not String
  final DateTime? createdAt; // ✅ DateTime not String

  const SalaryEntity({
    this.salaryId,
    required this.staffId,
    this.managedBy,
    required this.baseSalary,
    required this.bonus,
    required this.deductions,
    this.netSalary,
    required this.payPeriodStart,
    required this.payPeriodEnd,
    required this.paymentStatus,
    this.paymentDate,
    this.createdAt,
  });

  factory SalaryEntity.fromJson(Map<String, dynamic> json) => SalaryEntity(
    salaryId: json['salary_id'] as int?,
    staffId: json['staff_id'] as int? ?? 0,
    managedBy: json['managed_by'] as int?,
    baseSalary: _toDouble(json['base_salary']),
    bonus: _toDouble(json['bonus']),
    deductions: _toDouble(json['deductions']),
    netSalary: json['net_salary'] != null
        ? _toDouble(json['net_salary'])
        : null,
    payPeriodStart: DateTime.parse(json['pay_period_start'] as String),
    payPeriodEnd: DateTime.parse(json['pay_period_end'] as String),
    paymentStatus: json['payment_status'] as String? ?? 'pending',
    paymentDate: json['payment_date'] != null
        ? DateTime.parse(json['payment_date'] as String)
        : null,
    createdAt: json['created_at'] != null
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

  // ✅ useful helpers
  int get totalDays => payPeriodEnd.difference(payPeriodStart).inDays + 1;
  bool get isPending => paymentStatus == 'pending';
  bool get isPaid => paymentStatus == 'paid';
  bool get isCancelled => paymentStatus == 'cancelled';

  String get statusLabel {
    switch (paymentStatus) {
      case 'paid':
        return 'Paid';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Pending';
    }
  }

  Color statusColor() {
    switch (paymentStatus) {
      case 'paid':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  Map<String, dynamic> toJson() => {
    'salary_id': salaryId,
    'staff_id': staffId,
    'managed_by': managedBy,
    'base_salary': baseSalary,
    'bonus': bonus,
    'deductions': deductions,
    'net_salary': netSalary,
    'pay_period_start': payPeriodStart.toIso8601String(),
    'pay_period_end': payPeriodEnd.toIso8601String(),
    'payment_status': paymentStatus,
    'payment_date': paymentDate?.toIso8601String(),
    'created_at': createdAt?.toIso8601String(),
  };
}

// Add to SalaryEntity
