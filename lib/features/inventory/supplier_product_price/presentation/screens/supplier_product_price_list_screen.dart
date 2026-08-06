import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/inventory/product/presentation/providers/product_provider.dart';
import 'package:frontendmobile/features/inventory/supplier_product_price/presentation/screens/supplier_product_price_list_item.dart';
import '../../domain/entities/supplier_product_price_entity.dart';
import '../providers/supplier_product_price_provider.dart';
import 'supplier_product_price_form_screen.dart';

typedef SupplierName = String;
typedef VariantLabel = String;

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class SupplierProductPriceListScreen extends ConsumerStatefulWidget {
  /////////////////////////
  ///
  ////////////////////////

  final int? supplierId;
  final int? variantId;
  final Map<int, SupplierName> supplierNames;
  final Map<int, VariantLabel> variantLabels;

  /////////////////////////
  ///
  ////////////////////////

  const SupplierProductPriceListScreen({
    super.key,
    this.supplierId,
    this.variantId,
    this.supplierNames = const {},
    this.variantLabels = const {},
  });

  /////////////////////////
  ///
  ////////////////////////

  @override
  ConsumerState<SupplierProductPriceListScreen> createState() =>
      _SupplierProductPriceListScreenState();
}

////////////////////////////////////////////////////////////////////////////////
///  INITAILIZE
////////////////////////////////////////////////////////////////////////////////
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
  /// OPEN FORM CREATE
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
  //  DELETED METHOD
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
  //  DELETED METHOD
  //////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    ///////////////////////////
    ///
    //////////////////////////
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final bg = isDark ? Pallets.surfaceDark : Pallets.surfaceLight;
    final subText = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final state = ref.watch(supplierProductPriceNotifierProvider);
    ///////////////////////////
    ///
    //////////////////////////
    return Scaffold(
      backgroundColor: bg,
      ///////////////////////////
      ///
      //////////////////////////
      appBar: AppBar(
        backgroundColor: isDark ? Pallets.backgroundDark : Pallets.surfaceLight,
        elevation: 0,
        title: const Text(
          'Supplier Prices',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      ///////////////////////////
      ///
      //////////////////////////
      floatingActionButton: FloatingActionButton.extended(
        onPressed: state.isCreating ? null : () => _openForm(context),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        icon: const Icon(Icons.add),
        label: const Text('Add Price'),
      ),
      ///////////////////////////
      ///
      //////////////////////////
      body: state.isLoading && state.prices.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : state.prices.isEmpty
          ? Center(
              child: Text('No prices yet.', style: TextStyle(color: subText)),
            )
          ///////////////////
          ///
          ///////////////////
          : RefreshIndicator(
              //////////////
              ///
              /////////////
              onRefresh: () => ref
                  .read(supplierProductPriceNotifierProvider.notifier)
                  .loadAll(
                    supplierId: widget.supplierId,
                    variantId: widget.variantId,
                  ),

              //////////////
              ///
              /////////////
              child: ListView.separated(
                ////////////
                ///
                ///////////
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                itemCount: state.prices.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),

                ////////////
                ///
                ///////////
                itemBuilder: (_, i) {
                  final price = state.prices[i];
                  final isBusy = state.loadingIds.contains(price.priceId);
                  final supplier =
                      widget.supplierNames[price.supplierId] ??
                      'Supplier #${price.supplierId}';
                  ////////////
                  ///
                  ///////////
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
