import 'package:flutter/material.dart';
import 'package:frontendmobile/features/inventory/quotations/domain/entities/quotation_item_entity.dart';
import 'package:frontendmobile/features/inventory/quotations/presentation/widgets/quotation_item_tile.dart';
import 'package:intl/intl.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'section_card.dart';

class ItemsSection extends StatelessWidget {
  final List<QuotationItemEntity> items;
  final double subtotal;
  final double totalAmount;
  final VoidCallback onAdd;
  final void Function(int index) onEdit;
  final void Function(int index) onDelete;

  const ItemsSection({
    super.key,
    required this.items,
    required this.subtotal,
    required this.totalAmount,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(symbol: '\$');

    return SectionCard(
      title: 'Items (${items.length})',
      trailing: TextButton.icon(
        icon: const Icon(Icons.add, size: 18),
        label: const Text('Add'),
        onPressed: onAdd,
      ),
      children: [
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Text(
                'Add at least one item',
                style: TextStyle(color: Pallets.textMuted),
              ),
            ),
          )
        else
          ...items.asMap().entries.map(
            (entry) => QuotationItemTile(
              item: entry.value,
              onEdit: () => onEdit(entry.key),
              onDelete: () => onDelete(entry.key),
            ),
          ),
        if (items.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Subtotal',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(currency.format(subtotal)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total (after discount/tax)',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              Text(
                currency.format(totalAmount),
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Pallets.blurple,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
