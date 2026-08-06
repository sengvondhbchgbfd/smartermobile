import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/hr/salaries/domain/entities/salaries_entity.dart';

class PayrollStats extends StatelessWidget {
  final List<SalaryEntity> salaries;
  final Color surface;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;

  const PayrollStats({
    super.key,
    required this.salaries,
    required this.surface,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final totalPayroll = salaries.fold<double>(
      0,
      (sum, s) => sum + (s.netSalary ?? 0.0),
    );
    final paidCount = salaries.where((s) => s.isPaid).length;
    final pendingCount = salaries
        .where((s) => !s.isPaid && !s.isCancelled)
        .length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              icon: Icons.account_balance_wallet_outlined,
              label: 'Total Payroll',
              value: '\$${totalPayroll.toStringAsFixed(0)}',
              color: Pallets.blurple,
              tint: Pallets.infoTint,
              surface: surface,
              border: border,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatCard(
              icon: Icons.check_circle_outline,
              label: 'Paid',
              value: '$paidCount',
              color: Pallets.success,
              tint: Pallets.successTint,
              surface: surface,
              border: border,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatCard(
              icon: Icons.hourglass_empty_rounded,
              label: 'Pending',
              value: '$pendingCount',
              color: Pallets.warning,
              tint: Pallets.warningTint,
              surface: surface,
              border: border,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color tint;
  final Color surface;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.tint,
    required this.surface,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: tint,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 1),
          Text(label, style: TextStyle(fontSize: 10.5, color: textSecondary)),
        ],
      ),
    );
  }
}
