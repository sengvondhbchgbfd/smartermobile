import 'package:flutter/material.dart';
import '../../domain/entities/supplier_product_price_entity.dart';

class SupplierProductPriceListItem extends StatelessWidget {
  final SupplierProductPriceEntity price;
  final String supplierName; // ✅
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF2C2C2E) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF3A3A3C)
        : const Color(0xFFE0DED8);
    final subText = isDark ? const Color(0xFF8E8E93) : const Color(0xFF6B6B6B);
    final variantLabel = (price.sku != null && price.sku!.isNotEmpty)
        ? '${price.productName} · ${price.sku}'
        : price.productName;
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
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.price_change_outlined,
                color: colors.onPrimaryContainer,
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
                    supplierName, // ✅ name not ID
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    variantLabel, // ✅ label not ID
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
                    color: colors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                if (isBusy)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else if (onDelete != null)
                  GestureDetector(
                    onTap: onDelete,
                    child: Icon(
                      Icons.delete_outline,
                      color: colors.error,
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
