import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/inventory/supplier_product_price/presentation/providers/supplier_product_price_provider.dart';

class SupplierPriceInlineList extends ConsumerStatefulWidget {
  final int supplierId;
  final String supplierName;
  final VoidCallback onManage;

  const SupplierPriceInlineList({
    super.key,
    required this.supplierId,
    required this.supplierName,
    required this.onManage,
  });

  @override
  ConsumerState<SupplierPriceInlineList> createState() =>
      _SupplierPriceInlineListState();
}

class _SupplierPriceInlineListState
    extends ConsumerState<SupplierPriceInlineList> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref
          .read(supplierProductPriceNotifierProvider.notifier)
          .loadAll(supplierId: widget.supplierId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(supplierProductPriceNotifierProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardBg = isDark ? Pallets.surfaceCard : Pallets.surfaceLight;
    final border = isDark ? Pallets.borderDark : Pallets.borderLight;
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;

    if (state.isLoading && state.prices.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: CircularProgressIndicator(
            color: Pallets.blurple,
            strokeWidth: 2,
          ),
        ),
      );
    }

    final prices = state.prices
        .where((p) => p.supplierId == widget.supplierId)
        .toList();

    if (prices.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 28),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: border),
          ),
          child: Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Pallets.infoTint,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.price_change_outlined,
                  size: 24,
                  color: Pallets.blurple,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'No prices yet',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tap Add to set a supplier price',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: border),
        ),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: prices.length,
          separatorBuilder: (_, __) =>
              Divider(height: 1, color: border, indent: 16, endIndent: 16),
          itemBuilder: (_, i) {
            final price = prices[i];
            final isBusy = state.loadingIds.contains(price.priceId);

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 6,
              ),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Pallets.infoTint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.inventory_2_outlined,
                  size: 20,
                  color: Pallets.blurple,
                ),
              ),
              title: Text(
                price.productName,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: price.sku != null
                  ? Text(
                      price.sku!,
                      style: TextStyle(color: textSecondary, fontSize: 12),
                    )
                  : price.note != null
                  ? Text(
                      price.note!,
                      style: TextStyle(color: textSecondary, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  : null,
              trailing: isBusy
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      '\$${price.unitPrice.toStringAsFixed(2)}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Pallets.blurple,
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }
}
