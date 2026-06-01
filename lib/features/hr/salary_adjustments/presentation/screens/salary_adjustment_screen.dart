import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/hr/salary_adjustments/presentation/provider/salary_adjustment_provider.dart';
import 'package:frontendmobile/features/hr/salary_adjustments/presentation/widgets/adjustment_loading_widget.dart';
import '../widgets/adjustment_card.dart';
import '../widgets/adjustment_empty_widget.dart';
import '../widgets/create_adjustment_sheet.dart';

class SalaryAdjustmentScreen extends ConsumerWidget {
  final int salaryId;
  const SalaryAdjustmentScreen({super.key, required this.salaryId});

  void _openSheet(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        useSafeArea: true,
        backgroundColor: Colors.transparent,
        builder: (_) => CreateAdjustmentSheet(salaryId: salaryId),
      );
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adjustmentNotifierProvider(salaryId));

    return Scaffold(
      appBar: AppBar(title: const Text('Adjustments')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openSheet(context),
        child: const Icon(Icons.add),
      ),
      body: state.when(
        loading: () => const AdjustmentLoadingWidget(),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (adjustments) => adjustments.isEmpty
            ? AdjustmentEmptyWidget(onAdd: () => _openSheet(context))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: adjustments.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) => AdjustmentCard(
                  adjustment: adjustments[i],
                  onDelete: () => ref
                      .read(adjustmentNotifierProvider(salaryId).notifier)
                      .delete(adjustments[i].id),
                ),
              ),
      ),
    );
  }
}
