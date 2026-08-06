import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/inventory/quotations/domain/entities/quotation_item_entity.dart';
import 'package:frontendmobile/features/inventory/quotations/presentation/widgets/quotation_item_tile.dart';

class QuotationItemsSection extends StatelessWidget {
  final List<QuotationItemEntity> items;
  final void Function(QuotationItemEntity item) onEdit;
  final void Function(QuotationItemEntity item) onDelete;

  const QuotationItemsSection({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Items (${items.length})',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: isDark ? Pallets.textPrimaryDark : Pallets.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 10),
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                'No items yet',
                style: TextStyle(color: Pallets.textMuted),
              ),
            ),
          )
        else
          ...items.map(
            (item) => QuotationItemTile(
              item: item,
              onEdit: () => onEdit(item),
              onDelete: () => onDelete(item),
            ),
          ),
      ],
    );
  }
}
