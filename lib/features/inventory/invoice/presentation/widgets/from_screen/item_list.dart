import 'package:flutter/material.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/widgets/invoice_theme_color.dart';
import 'draft_item.dart';

class ItemsList extends StatelessWidget {
  /////////////////////////////////////////
  ///
  ////////////////////////////////////////

  final List<DraftItem> items;
  final ValueChanged<int> onIncrement;
  final ValueChanged<int> onDecrementOrRemove;

  const ItemsList({
    required this.items,
    required this.onIncrement,
    required this.onDecrementOrRemove,
    super.key,
  });

  /////////////////////////////////////////
  ///
  ////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final colors = context.invoiceColors;

    /////////////////////////////////////////
    ///
    ////////////////////////////////////////

    if (items.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colors.border),
        ),
        child: Column(
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 30,
              color: colors.textSecondary,
            ),

            /////////////////////////////////////////
            ///
            ////////////////////////////////////////
            const SizedBox(height: 8),
            Text(
              'No items yet',
              style: TextStyle(
                color: colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),

            /////////////////////////////////////////
            ///
            ////////////////////////////////////////
            const SizedBox(height: 2),
            Text(
              'Tap "Add Product" to get started',
              style: TextStyle(color: colors.textSecondary, fontSize: 12),
            ),
          ],
        ),
      );
    }

    /////////////////////////////////////////
    ///
    ////////////////////////////////////////

    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        itemCount: items.length,
        separatorBuilder: (_, __) => Divider(height: 1, color: colors.border),
        itemBuilder: (_, i) => _itemTile(context, items[i], i),
      ),
    );
  }

  /////////////////////////////////////////
  ///
  ////////////////////////////////////////

  Widget _itemTile(BuildContext context, DraftItem item, int index) {
    final colors = context.invoiceColors;
    return ListTile(
      dense: true,
      leading: CircleAvatar(
        radius: 16,
        backgroundColor: colors.accent.withOpacity(0.12),
        child: Icon(Icons.inventory_2_outlined, size: 15, color: colors.accent),
      ),

      /////////////////////////////////////////
      ///
      ////////////////////////////////////////
      title: Text(
        item.variant.sku?.isNotEmpty == true
            ? item.variant.sku!
            : 'Variant #${item.variant.variantId}',
        style: TextStyle(color: colors.textPrimary),
      ),

      /////////////////////////////////////////
      ///
      ////////////////////////////////////////
      subtitle: Text(
        '\$${item.variant.price.toStringAsFixed(2)} × ${item.quantity} = \$${item.total.toStringAsFixed(2)}',
        style: TextStyle(color: colors.textSecondary),
      ),

      /////////////////////////////////////////
      ///
      ////////////////////////////////////////
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colors.border),
        ),

        /////////////////////////////////////////
        ///
        ////////////////////////////////////////
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: Icon(Icons.remove, size: 16, color: colors.error),
              onPressed: () => onDecrementOrRemove(index),
            ),

            /////////////////////////////////////////
            ///
            ////////////////////////////////////////
            SizedBox(
              width: 18,
              child: Text(
                '${item.quantity}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            /////////////////////////////////////////
            ///
            ////////////////////////////////////////
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: Icon(Icons.add, size: 16, color: colors.accent),
              onPressed: () => onIncrement(index),
            ),
          ],
        ),
      ),
    );
  }
}
