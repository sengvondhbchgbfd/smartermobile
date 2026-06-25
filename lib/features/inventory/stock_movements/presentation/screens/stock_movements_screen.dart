import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/utils/confirm_delete_dialog.dart';
import 'package:frontendmobile/features/inventory/product/presentation/providers/product_provider.dart';
import 'package:frontendmobile/core/utils/emty_state.dart' show EmptyState;
import 'package:frontendmobile/core/utils/error_banner.dart';

import '../providers/stock_movement_provider.dart';
import '../widgets/stock_movement_widgets.dart';

class StockMovementsScreen extends ConsumerStatefulWidget {
  final int? variantId;

  const StockMovementsScreen({this.variantId, super.key});

  @override
  ConsumerState<StockMovementsScreen> createState() =>
      _StockMovementsScreenState();
}

class _StockMovementsScreenState extends ConsumerState<StockMovementsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      ref
          .read(stockMovementNotifierProvider.notifier)
          .loadAll(variantId: widget.variantId);
      await ref.read(productNotifierProvider.notifier).loadAll();
    });
  }

  Future<void> _openCreate() async {
    final products = ref.read(productNotifierProvider).products;

    final allVariants = products
        .expand((p) => p.variants.map((v) => (product: p, variant: v)))
        .toList();

    if (allVariants.isEmpty) {
      _snack('Add a product variant first.');
      return;
    }

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => StockMovementFormDialog(variants: allVariants),
    );
    if (result == null || !mounted) return;

    final ok = await ref
        .read(stockMovementNotifierProvider.notifier)
        .create(
          variantId: result['variant_id'] as int,
          productId: result['product_id'] as int,
          qtyIn: result['qty_in'] as int,
          qtyOut: result['qty_out'] as int,
          movementType: result['movement_type'] as String,
          date: result['date'] as DateTime,
        );

    if (mounted) {
      _snack(ok ? 'Stock movement recorded.' : 'Failed to record movement.');
      if (ok) ref.read(productNotifierProvider.notifier).loadAll();
    }
  }

  Future<void> _confirmDelete(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const ConfirmDeleteDialog(
        title: 'Delete Movement',
        message: 'Are you sure you want to delete this stock movement record?',
      ),
    );
    if (confirmed != true || !mounted) return;

    final ok = await ref
        .read(stockMovementNotifierProvider.notifier)
        .delete(id);
    if (mounted) {
      _snack(ok ? 'Movement deleted.' : 'Failed to delete movement.');
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(stockMovementNotifierProvider);
    final notifier = ref.read(stockMovementNotifierProvider.notifier);
    final products = ref.watch(productNotifierProvider).products;

    String variantLabel(int variantId) {
      for (final p in products) {
        for (final v in p.variants) {
          if (v.variantId == variantId) {
            final sku = v.sku != null ? ' (${v.sku})' : '';
            return '${p.name}$sku';
          }
        }
      }
      return 'Variant #$variantId';
    }

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        leading: const BackButton(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Stock Movements',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
              ),
            ),
            if (state.movements.isNotEmpty)
              Text(
                '${state.movements.length} records',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh_outlined,
              color: state.isLoading ? colors.outline : colors.onSurface,
            ),
            tooltip: 'Refresh',
            onPressed: state.isLoading
                ? null
                : () => notifier.loadAll(variantId: widget.variantId),
          ),
          const SizedBox(width: 4),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: colors.outlineVariant),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreate,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Movement'),
        elevation: 2,
      ),
      body: Column(
        children: [
          if (state.error != null)
            ErrorBanner(message: state.error!, onDismiss: notifier.clearError),
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.movements.isEmpty
                ? EmptyState(
                    icon: Icons.swap_vert_outlined,
                    title: 'No movements yet',
                    message: 'Record stock in/out to track inventory changes.',
                    actionLabel: 'New Movement',
                    onAction: _openCreate,
                  )
                : RefreshIndicator(
                    onRefresh: () =>
                        notifier.loadAll(variantId: widget.variantId),
                    child: ListView.builder(
                      padding: const EdgeInsets.only(
                        top: 8,
                        bottom: 100,
                        left: 16,
                        right: 16,
                      ),
                      itemCount: state.movements.length,
                      itemBuilder: (_, i) {
                        final m = state.movements[i];
                        return StockMovementTile(
                          movement: m,
                          variantLabel: variantLabel(m.variantId),
                          onDelete: () => _confirmDelete(m.movementId),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
