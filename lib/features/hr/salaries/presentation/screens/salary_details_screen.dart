import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/hr/salaries/domain/entities/salaries_entity.dart';
import 'package:frontendmobile/features/hr/salaries/presentation/provider/salary_notifier.dart';
import 'package:frontendmobile/features/hr/salaries/presentation/screens/salary_edit_screen.dart';
import 'package:frontendmobile/features/hr/salaries/presentation/widgets/salaries_item_row.dart';
import 'package:frontendmobile/features/hr/salaries/presentation/widgets/salary_profile_tile.dart';
import 'package:frontendmobile/features/hr/salaries/presentation/widgets/salary_section.dart';
import 'package:frontendmobile/features/hr/staff/presentation/providers/staff_notifier.dart';

class SalaryDetailsScreen extends ConsumerWidget {
  final SalaryEntity salary;
  const SalaryDetailsScreen({super.key, required this.salary});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPaid = salary.paymentStatus == 'paid';
    /////////////////////////////////////////////////////////////////////
    // ── Resolve names from staff list ──
    /////////////////////////////////////////////////////////////////////
    final staffList = ref.watch(staffNotifierProvider).valueOrNull ?? [];
    final staff = staffList.where((s) => s.id == salary.staffId).firstOrNull;
    final manager = staffList
        .where((s) => s.id == salary.managedBy)
        .firstOrNull;
    //////////////////////////////////////////////////////////////////
    /// UI
    //////////////////////////////////////////////////////////////////
    return Scaffold(
      appBar: AppBar(
        title: Text('Salary #${salary.salaryId}'),
        actions: [
          ////////////////////////////////////////////////////
          ///  EDITED
          ///////////////////////////////////////////////////
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => SalaryEditScreen(salary: salary),
              ),
            ),
          ),
          ///////////////////////////////////////////////////
          ///
          //////////////////////////////////////////////////
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Delete Salary'),
                  content: const Text(
                    'Are you sure you want to delete this salary?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
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
          ///////////////////////////////////////////////////
          ///
          //////////////////////////////////////////////////
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          //////////////////////////////////////////////////////
          // ── Staff profile card ──
          ////////////////////////////////////////////////////
          SalarySection(
            title: 'Employee',
            child: SalaryProfileTile(
              name: staff?.name ?? 'Staff #${salary.staffId}',
              avatarUrl: staff?.avatarUrl,
              role: staff?.staffRole?.roleName,
              email: staff?.email,
              phone: staff?.phone,
            ),
          ),
          const SizedBox(height: 12),

          ////////////////////////////////////////////////////
          // ── Manager profile card ──
          ////////////////////////////////////////////////////
          SalarySection(
            title: 'Managed By',
            child: SalaryProfileTile(
              name: manager?.name ?? 'Staff #${salary.managedBy}',
              avatarUrl: manager?.avatarUrl,
              role: manager?.staffRole?.roleName,
              email: manager?.email,
              phone: manager?.phone,
            ),
          ),
          const SizedBox(height: 12),

          ////////////////////////////////////////////////////
          // ── Status ──
          ////////////////////////////////////////////////////
          SalarySection(
            title: 'Status',
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isPaid
                        ? Colors.green.shade100
                        : Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isPaid ? 'Paid' : 'Pending',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isPaid
                          ? Colors.green.shade800
                          : Colors.orange.shade800,
                    ),
                  ),
                ),
                const Spacer(),
                if (!isPaid)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.payments_outlined),
                    label: const Text('Mark as Paid'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      final today = DateTime.now();
                      final date =
                          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
                      await ref
                          .read(salaryNotifierProvider.notifier)
                          .markAsPaid(salary.salaryId!, date);
                      if (context.mounted) Navigator.pop(context);
                    },
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          ////////////////////////////////////////////////////
          // ── Salary breakdown ──
          ////////////////////////////////////////////////////
          SalarySection(
            title: 'Salary Breakdown',
            child: Column(
              children: [
                SalaryItemRow(
                  label: 'Base Salary',
                  value: '\$${salary.baseSalary.toStringAsFixed(2)}',
                  valueColor: Colors.green,
                ),
                SalaryItemRow(
                  label: 'Bonus',
                  value: '\$${salary.bonus.toStringAsFixed(2)}',
                  valueColor: Colors.green,
                ),
                SalaryItemRow(
                  label: 'Deductions',
                  value: '-\$${salary.deductions.toStringAsFixed(2)}',
                  valueColor: Colors.red,
                ),
                const Divider(height: 24),
                SalaryItemRow(
                  label: 'Net Salary',
                  value: '\$${salary.netSalary.toStringAsFixed(2)}',
                  bold: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          ////////////////////////////////////////////////////
          // ── Pay period ──
          ////////////////////////////////////////////////////
          SalarySection(
            title: 'Pay Period',
            child: Column(
              children: [
                SalaryItemRow(label: 'Start', value: salary.payPeriodStart),
                SalaryItemRow(label: 'End', value: salary.payPeriodEnd),
                SalaryItemRow(
                  label: 'Payment Date',
                  value: salary.paymentDate ?? '—',
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          ////////////////////////////////////////////////////
          // ── Meta ──
          ////////////////////////////////////////////////////
          SalarySection(
            title: 'Meta',
            child: Column(
              children: [
                SalaryItemRow(label: 'Salary ID', value: '${salary.salaryId}'),
                SalaryItemRow(
                  label: 'Created At',
                  value: salary.createdAt ?? '—',
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
