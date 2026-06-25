import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/hr/salaries/domain/entities/salaries_entity.dart';
import 'package:frontendmobile/features/hr/salaries/presentation/provider/salary_notifier.dart';
import 'package:frontendmobile/features/hr/salaries/presentation/screens/salary_edit_screen.dart';
import 'package:frontendmobile/features/hr/staff/presentation/providers/staff_notifier.dart';
import 'package:intl/intl.dart';

class SalaryDetailsScreen extends ConsumerWidget {
  final SalaryEntity salary;
  const SalaryDetailsScreen({super.key, required this.salary});

  String _fmt(DateTime? dt) =>
      dt != null ? DateFormat('dd MMM yyyy').format(dt) : '—';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colors = theme.colorScheme;

    final bg = isDark ? const Color(0xFF0F0F10) : const Color(0xFFF6F6F7);
    final cardBg = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final border = isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA);
    final subText = isDark ? const Color(0xFF8E8E93) : const Color(0xFF6C6C70);

    final staffList = ref.watch(staffNotifierProvider).valueOrNull ?? [];
    final staff = staffList.where((s) => s.id == salary.staffId).firstOrNull;
    final manager = staffList
        .where((s) => s.userId == salary.managedBy)
        .firstOrNull;

    final netSalary = salary.netSalary ?? 0.0;
    final isPaid = salary.isPaid;
    final isCancelled = salary.isCancelled;

    Color statusColor = isPaid
        ? Colors.green
        : isCancelled
            ? Colors.red
            : Colors.orange;
    Color statusBg = statusColor.withOpacity(0.12);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Salary #${salary.salaryId}',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => SalaryEditScreen(salary: salary),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: colors.error),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: const Text('Delete Salary'),
                  content: const Text(
                    'This action cannot be undone.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: colors.error,
                      ),
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
              if (confirm == true && context.mounted) {
                await ref
                    .read(salaryNotifierProvider.notifier)
                    .delete(salary.salaryId!);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // ── Net salary hero ───────────────────────────────
          _SalaryHeroCard(
            netSalary: netSalary,
            statusLabel: salary.statusLabel,
            statusColor: statusColor,
            statusBg: statusBg,
            cardBg: cardBg,
            border: border,
            subText: subText,
            onMarkPaid: isPaid
                ? null
                : () async {
                    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
                    await ref
                        .read(salaryNotifierProvider.notifier)
                        .markAsPaid(salary.salaryId!, today);
                    if (context.mounted) Navigator.pop(context);
                  },
          ),

          const SizedBox(height: 12),

          // ── People ────────────────────────────────────────
          _SectionCard(
            title: 'People',
            cardBg: cardBg,
            border: border,
            subText: subText,
            children: [
              _PersonTile(
                label: 'Employee',
                name: staff?.name ?? 'Staff #${salary.staffId}',
                role: staff?.staffRole?.roleName,
                avatarUrl: staff?.avatarUrl,
                subText: subText,
              ),
              _Divider(border: border),
              _PersonTile(
                label: 'Managed by',
                name: manager?.name ?? 'User #${salary.managedBy}',
                role: manager?.staffRole?.roleName,
                avatarUrl: manager?.avatarUrl,
                subText: subText,
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ── Salary breakdown ──────────────────────────────
          _SectionCard(
            title: 'Breakdown',
            cardBg: cardBg,
            border: border,
            subText: subText,
            children: [
              _AmountRow(
                label: 'Base Salary',
                amount: salary.baseSalary,
                color: null,
                subText: subText,
              ),
              _Divider(border: border),
              _AmountRow(
                label: 'Bonus',
                amount: salary.bonus,
                color: Colors.green,
                prefix: '+',
                subText: subText,
              ),
              _Divider(border: border),
              _AmountRow(
                label: 'Deductions',
                amount: salary.deductions,
                color: Colors.red,
                prefix: '-',
                subText: subText,
              ),
              _Divider(border: border),
              _AmountRow(
                label: 'Net Salary',
                amount: netSalary,
                color: Colors.green,
                bold: true,
                subText: subText,
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ── Pay period ────────────────────────────────────
          _SectionCard(
            title: 'Pay Period',
            cardBg: cardBg,
            border: border,
            subText: subText,
            children: [
              _InfoRow(
                label: 'Start',
                value: _fmt(salary.payPeriodStart),
                subText: subText,
              ),
              _Divider(border: border),
              _InfoRow(
                label: 'End',
                value: _fmt(salary.payPeriodEnd),
                subText: subText,
              ),
              _Divider(border: border),
              _InfoRow(
                label: 'Payment Date',
                value: _fmt(salary.paymentDate),
                subText: subText,
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ── Meta ──────────────────────────────────────────
          _SectionCard(
            title: 'Meta',
            cardBg: cardBg,
            border: border,
            subText: subText,
            children: [
              _InfoRow(
                label: 'Salary ID',
                value: '#${salary.salaryId}',
                subText: subText,
              ),
              _Divider(border: border),
              _InfoRow(
                label: 'Created',
                value: _fmt(salary.createdAt),
                subText: subText,
              ),
            ],
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ── Hero card ─────────────────────────────────────────────
class _SalaryHeroCard extends StatelessWidget {
  final double netSalary;
  final String statusLabel;
  final Color statusColor;
  final Color statusBg;
  final Color cardBg;
  final Color border;
  final Color subText;
  final VoidCallback? onMarkPaid;

  const _SalaryHeroCard({
    required this.netSalary,
    required this.statusLabel,
    required this.statusColor,
    required this.statusBg,
    required this.cardBg,
    required this.border,
    required this.subText,
    this.onMarkPaid,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Net Salary',
                  style: theme.textTheme.bodySmall?.copyWith(color: subText),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${netSalary.toStringAsFixed(2)}',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (onMarkPaid != null)
            FilledButton.icon(
              onPressed: onMarkPaid,
              icon: const Icon(Icons.payments_outlined, size: 16),
              label: const Text('Mark Paid'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Section card wrapper ──────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Color cardBg;
  final Color border;
  final Color subText;

  const _SectionCard({
    required this.title,
    required this.children,
    required this.cardBg,
    required this.border,
    required this.subText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: subText,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: border),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

// ── Person tile ───────────────────────────────────────────
class _PersonTile extends StatelessWidget {
  final String label;
  final String name;
  final String? role;
  final String? avatarUrl;
  final Color subText;

  const _PersonTile({
    required this.label,
    required this.name,
    this.role,
    this.avatarUrl,
    required this.subText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage:
                avatarUrl != null ? NetworkImage(avatarUrl!) : null,
            backgroundColor: subText.withOpacity(0.15),
            child: avatarUrl == null
                ? Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: TextStyle(
                      color: subText,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(color: subText),
                ),
                Text(
                  name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (role != null)
                  Text(
                    role!,
                    style: theme.textTheme.bodySmall?.copyWith(color: subText),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Amount row ────────────────────────────────────────────
class _AmountRow extends StatelessWidget {
  final String label;
  final double amount;
  final Color? color;
  final String prefix;
  final bool bold;
  final Color subText;

  const _AmountRow({
    required this.label,
    required this.amount,
    this.color,
    this.prefix = '',
    this.bold = false,
    required this.subText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: bold ? null : subText,
              fontWeight: bold ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
          const Spacer(),
          Text(
            '$prefix\$${amount.toStringAsFixed(2)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Info row ──────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color subText;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.subText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(color: subText),
          ),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  final Color border;
  const _Divider({required this.border});

  @override
  Widget build(BuildContext context) =>
      Divider(height: 1, color: border, indent: 16, endIndent: 16);
}