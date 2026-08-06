import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/inventory/product/presentation/widgets/placeholder_thumb.dart';
import '../../domain/entities/product_entity.dart';

class ProductTile extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;
  final bool isWorking;

  const ProductTile({
    required this.product,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
    this.isWorking = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardBg = isDark ? Pallets.surfaceCard : Pallets.surfaceLight;
    final borderColor = isDark ? Pallets.borderDark : Pallets.borderLight;
    final subText = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final searchBg = isDark ? Pallets.surfaceElevated : Pallets.backgroundLight;
    final primary = Pallets.blurple;
    final error = Pallets.error;

    final price = product.price;
    final stockQty = product.stockQuantity;
    final lowStock = (stockQty ?? 0) <= 5;
    final hasVariants = product.variants.isNotEmpty;

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
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 56,
                height: 56,
                child: product.primaryImageUrl != null
                    ? Image.network(
                        product.primaryImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            PlaceholderThumb(bg: searchBg, sub: subText),
                      )
                    : PlaceholderThumb(bg: searchBg, sub: subText),
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),

                  Text(
                    price != null
                        ? '\$${price.toStringAsFixed(2)}'
                        : 'No variants yet',
                    style: TextStyle(
                      fontSize: 14,
                      color: price != null ? subText : error,
                      fontStyle: price != null
                          ? FontStyle.normal
                          : FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 7),

                  Row(
                    children: [
                      if (hasVariants) ...[
                        StockBadge(qty: stockQty ?? 0, low: lowStock),
                        const SizedBox(width: 6),
                        if (product.variants.length > 1)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${product.variants.length} variants',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: primary,
                              ),
                            ),
                          ),
                      ] else
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: error.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Add variant',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: error,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Actions
            if (isWorking)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: primary,
                ),
              )
            else
              Column(
                children: [
                  ActionBtn(
                    icon: Icons.edit_outlined,
                    color: primary,
                    onTap: onEdit,
                  ),
                  const SizedBox(height: 4),
                  ActionBtn(
                    icon: Icons.delete_outline,
                    color: error,
                    onTap: onDelete,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
