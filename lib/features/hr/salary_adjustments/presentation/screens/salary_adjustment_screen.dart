import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/hr/salary_adjustments/presentation/widgets/adjustment_card.dart';
import 'package:frontendmobile/features/hr/salary_adjustments/presentation/widgets/adjustment_empty_widget.dart';
import 'package:frontendmobile/features/hr/salary_adjustments/presentation/widgets/create_adjustment_sheet.dart';
import '../../domain/entities/salary_adjustment_entity.dart';
import '../provider/salary_adjustment_provider.dart';
class SalaryAdjustmentsScreen extends ConsumerStatefulWidget {
  final int salaryId;
  const SalaryAdjustmentsScreen({super.key, required this.salaryId});
  @override
  ConsumerState<SalaryAdjustmentsScreen> createState() =>
      _SalaryAdjustmentsScreenState();
}

class _SalaryAdjustmentsScreenState
    extends ConsumerState<SalaryAdjustmentsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref
        .read(salaryAdjustmentNotifierProvider.notifier)
        .loadAdjustments(salaryId: widget.salaryId));
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  void _showCreateSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreateAdjustmentSheet(salaryId: widget.salaryId),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, SalaryAdjustmentEntity adjustment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Adjustment'),
        content: Text(
          'Remove this ${adjustment.adjustmentType.name} of '
          '\$${adjustment.amount.toStringAsFixed(2)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade600),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      ref
          .read(salaryAdjustmentNotifierProvider.notifier)
          .deleteAdjustment(adjustmentId: adjustment.adjustmentId);
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(salaryAdjustmentNotifierProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Show snackbars for feedback
    ref.listen(salaryAdjustmentNotifierProvider, (_, next) {
      if (next.successMessage != null) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: Colors.green.shade700,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ));
        ref
            .read(salaryAdjustmentNotifierProvider.notifier)
            .clearMessages();
      }
      if (next.error != null) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text(next.error!),
            backgroundColor: colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ));
        ref
            .read(salaryAdjustmentNotifierProvider.notifier)
            .clearMessages();
      }
    });

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Salary Adjustments',
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(
              'Salary #${widget.salaryId}',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: colorScheme.onSurface.withOpacity(0.5)),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref
                .read(salaryAdjustmentNotifierProvider.notifier)
                .loadAdjustments(salaryId: widget.salaryId),
          ),
        ],
      ),
      body: _buildBody(state, context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateSheet,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Adjustment'),
      ),
    );
  }

  Widget _buildBody(SalaryAdjustmentState state, BuildContext context) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.adjustments.isEmpty) {
      return AdjustmentEmptyWidget(onAdd: _showCreateSheet);
    }

    // Summary header
    final totalBonus = state.adjustments
        .where((a) => a.adjustmentType == AdjustmentType.bonus)
        .fold(0.0, (sum, a) => sum + a.amount);
    final totalDeduction = state.adjustments
        .where((a) => a.adjustmentType == AdjustmentType.deduction)
        .fold(0.0, (sum, a) => sum + a.amount);

    return RefreshIndicator(
      onRefresh: () => ref
          .read(salaryAdjustmentNotifierProvider.notifier)
          .loadAdjustments(salaryId: widget.salaryId),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _SummaryBanner(
              totalBonus: totalBonus,
              totalDeduction: totalDeduction,
              count: state.adjustments.length,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            sliver: SliverList.separated(
              itemCount: state.adjustments.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (ctx, i) {
                final adjustment = state.adjustments[i];
                return AdjustmentCardWidget(
                  adjustment: adjustment,
                  onDelete: () => _confirmDelete(ctx, adjustment),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Summary Banner ─────────────────────────────────────────────────────────────

class _SummaryBanner extends StatelessWidget {
  final double totalBonus;
  final double totalDeduction;
  final int count;

  const _SummaryBanner({
    required this.totalBonus,
    required this.totalDeduction,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          _Stat(
            label: 'Total',
            value: '$count',
            suffix: 'items',
            color: Colors.white,
          ),
          _divider(),
          _Stat(
            label: 'Bonuses',
            value: '\$${totalBonus.toStringAsFixed(2)}',
            color: Colors.greenAccent.shade100,
          ),
          _divider(),
          _Stat(
            label: 'Deductions',
            value: '\$${totalDeduction.toStringAsFixed(2)}',
            color: Colors.red.shade100,
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 40,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        color: Colors.white24,
      );
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final String? suffix;
  final Color color;

  const _Stat({
    required this.label,
    required this.value,
    this.suffix,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 11)),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  color: color, fontSize: 16, fontWeight: FontWeight.w700)),
          if (suffix != null)
            Text(suffix!,
                style:
                    const TextStyle(color: Colors.white54, fontSize: 10)),
        ],
      ),
    );
  }
}