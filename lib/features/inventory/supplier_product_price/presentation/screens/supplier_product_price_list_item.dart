import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import '../../domain/entities/supplier_product_price_entity.dart';

class SupplierProductPriceListItem extends StatelessWidget {
  final SupplierProductPriceEntity price;
  final String supplierName;
  final bool isBusy;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const SupplierProductPriceListItem({
    super.key,
    required this.price,
    required this.supplierName,
    this.isBusy = false,
    this.onTap,
    this.onDelete,
  });

  ////////////////////////////////////////////////////////////////////////////
  /// Confirmation dialog shown before actually deleting a price.
  ////////////////////////////////////////////////////////////////////////////
  Future<void> _confirmDelete(BuildContext context) async {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = isDark ? Pallets.surfaceCard : Pallets.surfaceLight;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final subText = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final variantLabel = (price.sku != null && price.sku!.isNotEmpty)
        ? '${price.productName} · ${price.sku}'
        : price.productName;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete price?',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        content: Text(
          'This will remove the price for "$supplierName · $variantLabel". '
          'This action cannot be undone.',
          style: TextStyle(color: subText, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(color: subText, fontWeight: FontWeight.w600),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: Pallets.error),
            child: const Text(
              'Delete',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      onDelete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = isDark ? Pallets.surfaceCard : Pallets.surfaceLight;
    final borderColor = isDark ? Pallets.borderDark : Pallets.borderLight;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final subText = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final iconBg = isDark ? Pallets.surfaceElevated : Pallets.infoTint;
    final variantLabel = (price.sku != null && price.sku!.isNotEmpty)
        ? '${price.productName} · ${price.sku}'
        : price.productName;

    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 0.5),
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.price_change_outlined,
                color: Pallets.blurple,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    supplierName,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    variantLabel,
                    style: TextStyle(fontSize: 13, color: subText),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (price.note != null && price.note!.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      price.note!,
                      style: TextStyle(fontSize: 12, color: subText),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Price + actions
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${price.unitPrice.toStringAsFixed(2)}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Pallets.blurple,
                  ),
                ),
                const SizedBox(height: 4),
                if (isBusy)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Pallets.blurple,
                    ),
                  )
                else if (onDelete != null)
                  GestureDetector(
                    onTap: () => _confirmDelete(context),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Pallets.error,
                      size: 20,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
