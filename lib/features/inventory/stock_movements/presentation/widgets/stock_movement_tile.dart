import 'package:flutter/material.dart';
import 'package:frontendmobile/features/inventory/stock_movements/presentation/widgets/type_chip.dart';
import '../../domain/entities/stock_movement_entity.dart';

class StockMovementTile extends StatelessWidget {
  final StockMovementEntity movement;
  final String variantLabel;
  final VoidCallback onDelete;

  const StockMovementTile({
    required this.movement,
    required this.variantLabel,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isIn = movement.qtyIn > 0;
    final qty = isIn ? movement.qtyIn : movement.qtyOut;
    final accentColor = isIn ? const Color(0xFF22C55E) : colors.error;
    final accentBg = isIn
        ? const Color(0xFF22C55E).withOpacity(0.10)
        : colors.error.withOpacity(0.10);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.outlineVariant.withOpacity(0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: accentBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isIn ? Icons.south_rounded : Icons.north_rounded,
                color: accentColor,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    variantLabel,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (movement.movementType != null) ...[
                        TypeChip(label: movement.movementType!),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        _formatDate(movement.date),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isIn ? '+' : '−'}$qty',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'bal ${movement.balanceQuantity}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: onDelete,
                  child: Icon(
                    Icons.delete_outline_rounded,
                    size: 18,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}
