import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/core/utils/date_formatter.dart';
import 'package:frontendmobile/features/inventory/quotations/domain/entities/quotation_entity.dart';
import 'package:frontendmobile/features/inventory/quotations/presentation/widgets/total_row.dart';

class QuotationTotalsCard extends StatelessWidget {
  final QuotationEntity quotation;
  const QuotationTotalsCard({super.key, required this.quotation});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final q = quotation;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Pallets.surfaceElevated : Pallets.surfaceLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          TotalRow(
            label: 'Subtotal',
            value: DateFormatter.currency.format(q.subtotal),
          ),
          TotalRow(
            label: 'Discount',
            value: '- ${DateFormatter.currency.format(q.discount)}',
          ),
          TotalRow(label: 'Tax', value: DateFormatter.currency.format(q.tax)),
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(vertical: 8),
            color: isDark ? Pallets.dividerDark : Pallets.dividerLight,
          ),
          TotalRow(
            label: 'Total',
            value: DateFormatter.currency.format(q.totalAmount),
            isTotal: true,
          ),
        ],
      ),
    );
  }
}
