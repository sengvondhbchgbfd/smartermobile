import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/hr/salaries/presentation/widgets/salary_row.dart';
import 'package:frontendmobile/features/hr/salaries/presentation/widgets/salary_staff_row.dart';
import 'package:frontendmobile/features/hr/staff/presentation/providers/staff_notifier.dart';
import 'package:frontendmobile/shared/widgets/app_action_buttons.dart';
import 'package:frontendmobile/shared/widgets/app_card.dart';
import 'package:frontendmobile/shared/widgets/app_status_badge.dart';
import '../../domain/entities/salaries_entity.dart';
class SalaryCard extends ConsumerWidget {
  final SalaryEntity salary;
  final VoidCallback onEdit;
  final VoidCallback onMarkPaid;
  final VoidCallback onDelete;

  
  // final VoidCallback? onAdjustments;

  const SalaryCard({
    super.key,
    required this.salary,
    required this.onEdit,
    required this.onMarkPaid,
    required this.onDelete,
    // required this.onAdjustments
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPaid = salary.paymentStatus == 'paid';
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // ── Resolve staff list ────────────────────────────────
    final staffList = ref.watch(staffNotifierProvider).valueOrNull ?? [];

    // ── Employee: match by staff.id ───────────────────────
    final staff = staffList.where((s) => s.id == salary.staffId).firstOrNull;

    // ── Manager: match by staff.userId ───────────────────
    // managed_by references users.user_id not staff.id
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
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${salary.netSalary.toStringAsFixed(2)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Pallets.gradient2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              AppStatusBadge(
                label: isPaid ? 'Paid' : 'Pending',
                type: isPaid ? AppStatusType.success : AppStatusType.warning,
              ),
            ],
          ),

          const SizedBox(height: 12),
          Divider(
            height: 1,
            color: isDark ? Pallets.borderDark : Pallets.borderLight,
          ),
          const SizedBox(height: 12),

          // ── Manager ──────────────────────────────────────
          SalaryStaffRow(
            label: 'Managed By',
            name: manager?.name ?? 'User #${salary.managedBy}',
            avatarUrl: manager?.avatarUrl,
            sub: manager?.staffRole?.roleName,
          ),
          const SizedBox(height: 8),

          // ── Employee ─────────────────────────────────────
          SalaryStaffRow(
            label: 'Employee',
            name: staff?.name ?? 'Staff #${salary.staffId}',
            avatarUrl: staff?.avatarUrl,
            sub: staff?.staffRole?.roleName,
          ),

          const SizedBox(height: 12),
          Divider(
            height: 1,
            color: isDark ? Pallets.borderDark : Pallets.borderLight,
          ),
          const SizedBox(height: 8),

          // ── Salary breakdown ─────────────────────────────
          SalaryRow(
            label: 'Base',
            value: salary.baseSalary,
            color: isDark
                ? Pallets.textSecondaryDark
                : Pallets.textSecondaryLight,
          ),
          const SizedBox(height: 4),
          SalaryRow(
            label: 'Bonus',
            value: salary.bonus,
            color: Pallets.success,
          ),
          const SizedBox(height: 4),
          SalaryRow(
            label: 'Deductions',
            value: -salary.deductions,
            color: Pallets.error,
          ),

          const SizedBox(height: 8),
          Divider(
            height: 1,
            color: isDark ? Pallets.borderDark : Pallets.borderLight,
          ),
          const SizedBox(height: 8),

          // ── Pay period ───────────────────────────────────
          Row(
            children: [
              Icon(
                Icons.date_range_outlined,
                size: 14,
                color: isDark
                    ? Pallets.textSecondaryDark
                    : Pallets.textSecondaryLight,
              ),
              const SizedBox(width: 4),
              Text(
                '${salary.payPeriodStart}  →  ${salary.payPeriodEnd}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? Pallets.textSecondaryDark
                      : Pallets.textSecondaryLight,
                ),
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
            // onAdjustments: onAdjustments,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SALARY ROW
// ─────────────────────────────────────────────
