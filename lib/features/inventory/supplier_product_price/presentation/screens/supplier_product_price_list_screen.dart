import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/inventory/product/presentation/providers/product_provider.dart';
import 'package:frontendmobile/features/inventory/supplier_product_price/presentation/screens/supplier_product_price_list_item.dart';

import '../../domain/entities/supplier_product_price_entity.dart';
import '../providers/supplier_product_price_provider.dart';
import 'supplier_product_price_form_screen.dart';

// pass these in from parent so we can show names instead of IDs
typedef SupplierName = String;
typedef VariantLabel = String;

class SupplierProductPriceListScreen extends ConsumerStatefulWidget {
  final int? supplierId;
  final int? variantId;
  final Map<int, SupplierName> supplierNames;
  final Map<int, VariantLabel> variantLabels;

  const SupplierProductPriceListScreen({
    super.key,
    this.supplierId,
    this.variantId,
    this.supplierNames = const {},
    this.variantLabels = const {},
  });

  @override
  ConsumerState<SupplierProductPriceListScreen> createState() =>
      _SupplierProductPriceListScreenState();
}

//////////////////////////////////////////////////////////////////////////////
///
//////////////////////////////////////////////////////////////////////////////
class _SupplierProductPriceListScreenState
    extends ConsumerState<SupplierProductPriceListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(supplierProductPriceNotifierProvider.notifier)
          .loadAll(supplierId: widget.supplierId, variantId: widget.variantId);
      ref.read(variantLabelsProvider.future);
    });
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  void _openForm(
    BuildContext context, {
    SupplierProductPriceEntity? existing,
  }) async {
    final variantLabels = await ref.read(variantLabelsProvider.future);

    if (!mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SupplierProductPriceFormScreen(
          existing: existing,
          defaultSupplierId: widget.supplierId,
          defaultVariantId: widget.variantId,
          supplierNames: widget.supplierNames,
          variantLabels: variantLabels,
        ),
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  void _confirmDelete(BuildContext context, int priceId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete price?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await ref
                  .read(supplierProductPriceNotifierProvider.notifier)
                  .delete(priceId);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    final state = ref.watch(supplierProductPriceNotifierProvider);
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF5F5F4);
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    return Scaffold(
      backgroundColor: bg,

      //////////////////////////////////////////////////////////////////////////
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF2C2C2E) : Colors.white,
        elevation: 0,
        title: const Text(
          'Supplier Prices',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      ////////////////////////////////////////////////////////////////////////////////
      floatingActionButton: FloatingActionButton.extended(
        onPressed: state.isCreating ? null : () => _openForm(context),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        icon: const Icon(Icons.add),
        label: const Text('Add Price'),
      ),

      body: state.isLoading && state.prices.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : state.prices.isEmpty
          ? Center(
              child: Text(
                'No prices yet.',
                style: TextStyle(
                  color: isDark
                      ? const Color(0xFF8E8E93)
                      : const Color(0xFF6B6B6B),
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: () => ref
                  .read(supplierProductPriceNotifierProvider.notifier)
                  .loadAll(
                    supplierId: widget.supplierId,
                    variantId: widget.variantId,
                  ),
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                itemCount: state.prices.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),

                itemBuilder: (_, i) {
                  final price = state.prices[i];
                  final isBusy = state.loadingIds.contains(price.priceId);

                  // Supplier name still needs an external lookup (entity has no nested supplier yet)
                  final supplier =
                      widget.supplierNames[price.supplierId] ??
                      'Supplier #${price.supplierId}';

                  return SupplierProductPriceListItem(
                    price: price,
                    supplierName: supplier,
                    isBusy: isBusy,
                    onTap: isBusy
                        ? null
                        : () => _openForm(context, existing: price),
                    onDelete: isBusy
                        ? null
                        : () => _confirmDelete(context, price.priceId),
                  );
                },
              ),
            ),
    );
  }
}
