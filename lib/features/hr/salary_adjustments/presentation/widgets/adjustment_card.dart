import 'package:flutter/material.dart';
import 'package:frontendmobile/features/hr/salary_adjustments/domain/entities/salary_adjustment_entity.dart';

class AdjustmentCard extends StatelessWidget {
  final SalaryAdjustmentEntity adjustment;
  final VoidCallback onDelete;
  const AdjustmentCard({super.key, required this.adjustment, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final isBonus = adjustment.type == 'bonus';
    return Card(
      child: ListTile(
        leading: Icon(
          isBonus ? Icons.arrow_upward : Icons.arrow_downward,
          color: isBonus ? Colors.green : Colors.red,
        ),
        title: Text(
          '${isBonus ? '+' : '-'}\$${adjustment.amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isBonus ? Colors.green : Colors.red,
          ),
        ),
        subtitle: adjustment.note != null ? Text(adjustment.note!) : null,
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}