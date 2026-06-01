import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/hr/salaries/presentation/provider/salary_notifier.dart';
import 'package:frontendmobile/features/hr/salaries/presentation/screens/salary_create_screen.dart';
import 'package:frontendmobile/features/hr/salaries/presentation/screens/salary_details_screen.dart';
import 'package:frontendmobile/features/hr/salaries/presentation/widgets/salary_card.dart';
import 'package:frontendmobile/features/hr/salary_adjustments/presentation/screens/salary_adjustment_screen.dart';
import 'package:frontendmobile/features/hr/staff/presentation/providers/staff_notifier.dart';

class SalaryScreen extends ConsumerWidget {
  const SalaryScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ///////////////////////////////////////////////////////
    //
    ///////////////////////////////////////////////////////
    final salaryState = ref.watch(salaryNotifierProvider);
    ref.read(staffNotifierProvider);
    ///////////////////////////////////////////////////////
    //
    ///////////////////////////////////////////////////////
    return Scaffold(
      ////////////////////////////////////////////////////
      /// APPBAR
      ///////////////////////////////////////////////////
      appBar: AppBar(
        title: const Text('Salaries'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(salaryNotifierProvider.notifier).fetchAll(),
          ),
        ],
      ),

      //////////////////////////////////////////////////
      /// SalaryCreateScreen
      /////////////////////////////////////////////////
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SalaryCreateScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      //////////////////////////////////////////////////
      ///  Retry after not show
      /////////////////////////////////////////////////
      body: salaryState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        /////////////////////////////////////
        ///
        ////////////////////////////////////
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Error: $e', textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () =>
                    ref.read(salaryNotifierProvider.notifier).fetchAll(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),

        //////////////////////////////////////////////////
        /// default name data get map
        /////////////////////////////////////////////////
        data: (salaries) => salaries.isEmpty
            /////////////////////////////////////////////
            ///
            ////////////////////////////////////////////
            ? const Center(child: Text('No salaries found.'))
            ////////////////////////////////////////////
            ///
            ////////////////////////////////////////////
            : RefreshIndicator(
                onRefresh: () =>
                    ////////////////////////////////////////
                    ///
                    ////////////////////////////////////////
                    ref.read(salaryNotifierProvider.notifier).fetchAll(),
                ////////////////////////////////////////
                /// LIST INTO CART
                ////////////////////////////////////////
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: salaries.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final salary = salaries[index];

                    ///////////////////////////////////////////
                    /// STAFF CART Go EDITE
                    //////////////////////////////////////////
                    return SalaryCard(
                      /////////////////////////
                      ///
                      ////////////////////////
                      salary: salary,

                      //////////////////////////////////////////
                      ///
                      /////////////////////////////////////////

                      /////////////////////////////////////////
                      /// EDITED
                      /////////////////////////////////////////
                      onEdit: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SalaryDetailsScreen(salary: salary),
                        ),
                      ),

                      onAdjustments: () {
                        if (salary.salaryId == null) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SalaryAdjustmentScreen(
                              salaryId: salary.salaryId!,
                            ),
                          ),
                        );
                      },

                      ///////////////////////////////////////////
                      /// PAID MARK
                      //////////////////////////////////////////
                      onMarkPaid: () async {
                        final today = DateTime.now();
                        final date =
                            '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
                        await ref
                            .read(salaryNotifierProvider.notifier)
                            .markAsPaid(salary.salaryId!, date);
                      },
                      ///////////////////////////////////////////
                      ///  DELETED
                      //////////////////////////////////////////
                      onDelete: () async {
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
                          try {
                            await ref
                                .read(salaryNotifierProvider.notifier)
                                .delete(salary.salaryId!);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Salary deleted.'),
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    e.toString().replaceAll('Exception: ', ''),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        }
                      },
                      ///////////////////////////////////////////
                      ///
                      //////////////////////////////////////////
                    );
                  },
                ),
              ),
      ),
    );
  }
}
