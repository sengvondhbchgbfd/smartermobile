import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/hr/staff/presentation/providers/staff_notifier.dart';
import 'package:frontendmobile/shared/widgets/app_action_buttons.dart';
import 'package:frontendmobile/shared/widgets/app_card.dart';
import 'package:frontendmobile/shared/widgets/app_status_badge.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/salaries_entity.dart';

class SalaryCard extends ConsumerWidget {
  final SalaryEntity salary;
  final VoidCallback onEdit;
  final VoidCallback onMarkPaid;
  final VoidCallback onDelete;
  final VoidCallback? onAdjustments;

  const SalaryCard({
    super.key,
    required this.salary,
    required this.onEdit,
    required this.onMarkPaid,
    required this.onDelete,
    required this.onAdjustments,
  });

  String _fmt(DateTime dt) => DateFormat('dd MMM yyyy').format(dt);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPaid = salary.isPaid;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final subText = isDark ? const Color(0xFF8E8E93) : const Color(0xFF6C6C70);
    final border = isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA);

    // ✅ safe null-aware net salary
    final netSalary = salary.netSalary ?? 0.0;

    final staffList = ref.watch(staffNotifierProvider).valueOrNull ?? [];
    final staff = staffList.where((s) => s.id == salary.staffId).firstOrNull;
    final manager = staffList
        .where((s) => s.userId == salary.managedBy)
        .firstOrNull;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ───────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Salary #${salary.salaryId}',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: subText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '\$${netSalary.toStringAsFixed(2)}', // ✅ null-safe
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Pallets.gradient2,
                      ),
                    ),
                  ],
                ),
              ),
              AppStatusBadge(
                label: salary.statusLabel,
                type: isPaid
                    ? AppStatusType.success
                    : salary.isCancelled
                    ? AppStatusType.error
                    : AppStatusType.warning,
              ),
            ],
          ),

          const SizedBox(height: 12),
          Divider(height: 1, color: border),
          const SizedBox(height: 12),

          // ── People ───────────────────────────────────────
          _StaffRow(
            label: 'Employee',
            name: staff?.name ?? 'Staff #${salary.staffId}',
            avatarUrl: staff?.avatarUrl,
            sub: staff?.staffRole?.roleName,
            subText: subText,
          ),
          const SizedBox(height: 8),
          _StaffRow(
            label: 'Managed by',
            name: manager?.name ?? 'User #${salary.managedBy}',
            avatarUrl: manager?.avatarUrl,
            sub: manager?.staffRole?.roleName,
            subText: subText,
          ),

          const SizedBox(height: 12),
          Divider(height: 1, color: border),
          const SizedBox(height: 8),

          // ── Breakdown ────────────────────────────────────
          _AmountRow(label: 'Base', value: salary.baseSalary, subText: subText),
          const SizedBox(height: 4),
          _AmountRow(
            label: 'Bonus',
            value: salary.bonus,
            color: Colors.green,
            prefix: '+',
            subText: subText,
          ),
          const SizedBox(height: 4),
          _AmountRow(
            label: 'Deductions',
            value: salary.deductions,
            color: Colors.red,
            prefix: '-',
            subText: subText,
          ),

          const SizedBox(height: 8),
          Divider(height: 1, color: border),
          const SizedBox(height: 8),

          // ── Pay period ───────────────────────────────────
          Row(
            children: [
              Icon(Icons.date_range_outlined, size: 14, color: subText),
              const SizedBox(width: 6),
              Text(
                // ✅ formatted DateTime
                '${_fmt(salary.payPeriodStart)}  →  ${_fmt(salary.payPeriodEnd)}',
                style: theme.textTheme.bodySmall?.copyWith(color: subText),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ── Actions ──────────────────────────────────────
          AppActionButtons(
            onPrimary: isPaid ? null : onMarkPaid,
            primaryIcon: Icons.payments_outlined,
            primaryTooltip: 'Mark Paid',
            onEdit: onEdit,
            onDelete: onDelete,
            onAdjustments: onAdjustments,
          ),
        ],
      ),
    );
  }
}

class _StaffRow extends StatelessWidget {
  final String label;
  final String name;
  final String? avatarUrl;
  final String? sub;
  final Color subText;

  const _StaffRow({
    required this.label,
    required this.name,
    this.avatarUrl,
    this.sub,
    required this.subText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
          backgroundColor: subText.withOpacity(0.15),
          child: avatarUrl == null
              ? Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: subText,
                  ),
                )
              : null,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: subText,
                  fontSize: 10,
                ),
              ),
              Text(
                name,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              if (sub != null)
                Text(
                  sub!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: subText,
                    fontSize: 10,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AmountRow extends StatelessWidget {
  final String label;
  final double value;
  final Color? color;
  final String prefix;
  final Color subText;

  const _AmountRow({
    required this.label,
    required this.value,
    this.color,
    this.prefix = '',
    required this.subText,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(label, style: theme.textTheme.bodySmall?.copyWith(color: subText)),
        const Spacer(),
        Text(
          '$prefix\$${value.toStringAsFixed(2)}',
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }
}
