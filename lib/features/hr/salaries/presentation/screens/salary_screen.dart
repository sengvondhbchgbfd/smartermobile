import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/extensions/user_info_extensions.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontendmobile/features/hr/salaries/presentation/provider/salary_notifier.dart';
import 'package:frontendmobile/features/hr/salaries/presentation/screens/salary_create_screen.dart';
import 'package:frontendmobile/features/hr/salaries/presentation/screens/salary_details_screen.dart';
import 'package:frontendmobile/features/hr/salaries/presentation/widgets/salaries_payroll_stats.dart';
import 'package:frontendmobile/features/hr/salaries/presentation/widgets/salary_card.dart';
import 'package:frontendmobile/features/hr/salary_adjustments/presentation/screens/salary_adjustment_screen.dart';
class SalaryScreen extends ConsumerWidget {
  const SalaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? Pallets.backgroundDark : Pallets.backgroundLight;
    final surface = isDark ? Pallets.surfaceDark : Pallets.surfaceLight;
    final textPrimary = isDark ? Pallets.textPrimaryDark : Pallets.textPrimaryLight;
    final textSecondary = isDark ? Pallets.textSecondaryDark : Pallets.textSecondaryLight;
    final border = isDark ? Pallets.borderDark : Pallets.borderLight;

    final salaryState = ref.watch(salaryNotifierProvider);
    final notifier = ref.read(salaryNotifierProvider.notifier);

    final currentUser = ref.watch(currentUserProvider);
    final canManageSalary = currentUser?.canManageSalary ?? false; // admin/superuser

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text('Salaries', style: TextStyle(color: textPrimary, fontWeight: FontWeight.w700, fontSize: 19, letterSpacing: -0.3)),
        centerTitle: false,
        backgroundColor: surface,
        surfaceTintColor: Pallets.transparent,
        elevation: 0,
        scrolledUnderElevation: 1,
        shape: Border(bottom: BorderSide(color: border, width: 1)),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      floatingActionButton: canManageSalary
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: Pallets.brandGradient,
                boxShadow: [BoxShadow(color: Pallets.blurple.withOpacity(0.35), blurRadius: 16, offset: const Offset(0, 6))],
              ),
              child: FloatingActionButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SalaryCreateScreen())),
                backgroundColor: Pallets.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            )
          : null, // staff/read-only users get no create button
      body: salaryState.when(
        loading: () => Center(child: CircularProgressIndicator(color: Pallets.blurple)),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, color: Pallets.error, size: 32),
              const SizedBox(height: 8),
              Text('Error: $e', textAlign: TextAlign.center, style: TextStyle(color: textSecondary)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: notifier.fetchAll,
                style: ElevatedButton.styleFrom(backgroundColor: Pallets.blurple),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (salaries) => salaries.isEmpty
            ? Center(child: Text('No salaries found.', style: TextStyle(color: textSecondary)))
            : RefreshIndicator(
                color: Pallets.blurple,
                backgroundColor: surface,
                onRefresh: notifier.fetchAll,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 90),
                  itemCount: salaries.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return PayrollStats(salaries: salaries, surface: surface, border: border, textPrimary: textPrimary, textSecondary: textSecondary);
                    }
                    final salary = salaries[index - 1];
                    return SalaryCard(
                      salary: salary,
                      // View-only for everyone: tapping still shows details
                      onEdit: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SalaryDetailsScreen(salary: salary))),
                      // Below actions gated — null hides the affordance in SalaryCard (adjust SalaryCard to treat null callback as "hide button")
                      onAdjustments: !canManageSalary
                          ? null
                          : () {
                              if (salary.salaryId == null) return;
                              Navigator.push(context, MaterialPageRoute(builder: (_) => SalaryAdjustmentScreen(salaryId: salary.salaryId!)));
                            },
                      onMarkPaid: !canManageSalary
                          ? null
                          : () async {
                              final today = DateTime.now();
                              final date = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
                              await notifier.markAsPaid(salary.salaryId!, date);
                            },
                      onDelete: !canManageSalary
                          ? null
                          : () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  backgroundColor: isDark ? Pallets.surfaceCard : Pallets.surfaceLight,
                                  title: const Text('Delete Salary'),
                                  content: const Text('Are you sure you want to delete this salary?'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                                    TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete', style: TextStyle(color: Pallets.error))),
                                  ],
                                ),
                              );
                              if (confirm == true && context.mounted) {
                                try {
                                  await notifier.delete(salary.salaryId!);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Salary deleted.')));
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString().replaceAll('Exception: ', '')), backgroundColor: Pallets.error),
                                    );
                                  }
                                }
                              }
                            },
                    );
                  },
                ),
              ),
      ),
    );
  }
}