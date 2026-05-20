import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/salary_adjustment_entity.dart';

class AdjustmentCardWidget extends StatelessWidget {
  final SalaryAdjustmentEntity adjustment;
  final VoidCallback onDelete;

  const AdjustmentCardWidget({
    super.key,
    required this.adjustment,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isBonus = adjustment.adjustmentType == AdjustmentType.bonus;

    final accentColor = isBonus ? Colors.green.shade600 : Colors.red.shade600;
    final bgColor =
        isBonus ? Colors.green.shade50 : Colors.red.shade50;
    final icon = isBonus ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Type icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: accentColor, size: 22),
            ),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _TypeChip(
                        label: isBonus ? 'Bonus' : 'Deduction',
                        color: accentColor,
                        bg: bgColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '#${adjustment.adjustmentId}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    adjustment.reason?.isNotEmpty == true
                        ? adjustment.reason!
                        : 'No reason provided',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: adjustment.reason?.isNotEmpty == true
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurface.withOpacity(0.4),
                      fontStyle: adjustment.reason?.isNotEmpty == true
                          ? FontStyle.normal
                          : FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM d, yyyy • h:mm a')
                        .format(adjustment.createdAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.45),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            // Amount + delete
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isBonus ? '+' : '-'}\$${adjustment.amount.toStringAsFixed(2)}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.delete_outline_rounded,
                        size: 18, color: Colors.red.shade400),
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

class _TypeChip extends StatelessWidget {
  final String label;
  final Color color;
  final Color bg;

  const _TypeChip(
      {required this.label, required this.color, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}