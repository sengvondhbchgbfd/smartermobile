import 'package:flutter/material.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/widgets/invoice_theme_color.dart';

class TotalsSummary extends StatelessWidget {
  //////////////////////////////////////////////////////
  ///
  /////////////////////////////////////////////////////
  final double subtotal;
  final double discount;
  final double tax;
  final double total;

  const TotalsSummary({
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.total,
    super.key,
  });

  //////////////////////////////////////////////////////
  ///
  /////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    final colors = context.invoiceColors;
    final theme = Theme.of(context);

    //////////////////////////////////////////////////////
    ///
    /////////////////////////////////////////////////////

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          TotalRow(
            label: 'Subtotal',
            value: subtotal,
            theme: theme,
            color: colors.textPrimary,
          ),
          TotalRow(
            label: 'Discount',
            value: -discount,
            theme: theme,
            color: colors.error,
          ),
          TotalRow(
            label: 'Tax',
            value: tax,
            theme: theme,
            color: colors.textPrimary,
          ),
          Divider(height: 20, color: colors.border),
          TotalRow(
            label: 'Total',
            value: total,
            theme: theme,
            color: colors.textPrimary,
            bold: true,
          ),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////////
///
/////////////////////////////////////////////////////

class TotalRow extends StatelessWidget {
  final String label;
  final double value;
  final ThemeData theme;
  final Color color;
  final bool bold;

  const TotalRow({
    required this.label,
    required this.value,
    required this.theme,
    required this.color,
    this.bold = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final style =
        (bold
                ? theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  )
                : theme.textTheme.bodyMedium)
            ?.copyWith(color: color);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(
            '${value < 0 ? '-' : ''}\$${value.abs().toStringAsFixed(2)}',
            style: style,
          ),
        ],
      ),
    );
  }
}
