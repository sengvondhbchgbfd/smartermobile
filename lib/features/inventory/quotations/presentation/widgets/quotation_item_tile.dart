import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import '../../domain/entities/quotation_item_entity.dart';

class QuotationItemTile extends StatelessWidget {
  final QuotationItemEntity item;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const QuotationItemTile({
    super.key,
    required this.item,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currency = NumberFormat.currency(symbol: '\$');

    final specs = [
      item.size,
      if (item.pages != null) '${item.pages} pages',
      item.printSide,
      item.colorSpec,
      item.paperCover,
      item.paperInside,
      item.finishing,
      item.language,
    ].whereType<String>().where((s) => s.isNotEmpty).join(' • ');

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Pallets.surfaceElevated : Pallets.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Pallets.borderDark : Pallets.borderLight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.itemName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: isDark
                        ? Pallets.textPrimaryDark
                        : Pallets.textPrimaryLight,
                  ),
                ),
                if (specs.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    specs,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? Pallets.textSecondaryDark
                          : Pallets.textSecondaryLight,
                    ),
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  '${item.quantity} × ${currency.format(item.unitPrice)}',
                  style: TextStyle(fontSize: 12, color: Pallets.textMuted),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                currency.format(item.totalPrice),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Pallets.blurple,
                ),
              ),
              if (onEdit != null || onDelete != null)
                Row(
                  children: [
                    if (onEdit != null)
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        color: Pallets.textMuted,
                        onPressed: onEdit,
                      ),
                    if (onDelete != null)
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.delete_outline, size: 18),
                        color: Pallets.error,
                        onPressed: onDelete,
                      ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
