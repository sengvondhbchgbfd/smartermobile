import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class InvoiceSummaryCard extends StatelessWidget {
  final dynamic invoice;
  final bool productsLoading;
  final String Function(int) variantLabel;
  final String customerName;

  const InvoiceSummaryCard({
    super.key,
    required this.invoice,
    required this.productsLoading,
    required this.variantLabel,
    required this.customerName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = isDark ? Pallets.surfaceCard : Pallets.surfaceLight;
    final borderColor = isDark ? Pallets.borderDark : Pallets.borderLight;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final dividerColor = isDark ? Pallets.dividerDark : Pallets.dividerLight;
    final accent = Pallets.blurple;
    final errorColor = Pallets.error;

    final totalAmount = invoice.totalAmount ?? 0.0;
    final discount = invoice.discount ?? 0.0;
    final tax = invoice.tax ?? 0.0;
    final subtotal = totalAmount + discount - tax;

    return Card(
      elevation: 0,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Chip(
                    label: Text(
                      invoice.paymentType?.value ?? '-',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Pallets.onAccent),
                    ),
                    backgroundColor: accent,
                    side: BorderSide.none,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDate(invoice.createdAt),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              customerName,
              style: theme.textTheme.bodySmall?.copyWith(color: textSecondary),
            ),
            const SizedBox(height: 12),
            if (productsLoading)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: accent,
                    ),
                  ),
                ),
              )
            else
              ...invoice.items.map((item) {
                final String name = item.variantId != null
                    ? variantLabel(item.variantId as int)
                    : (item.itemName ?? 'Item');
                final String? subtitle =
                    item.variantId == null && item.size != null
                    ? item.size as String
                    : null;
                final isCustom = item.variantId == null;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                      color: textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (isCustom) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      color: accent.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'Custom',
                                      style: TextStyle(
                                        color: accent,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            if (subtitle != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 1),
                                child: Text(
                                  subtitle,
                                  style: TextStyle(
                                    color: textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 1),
                            Text(
                              '×${item.quantity}  •  \$${(item.unitPrice ?? 0.0).toStringAsFixed(2)} each',
                              style: TextStyle(
                                color: textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '\$${(item.totalPrice ?? 0.0).toStringAsFixed(2)}',
                        style: TextStyle(
                          color: textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            Divider(height: 20, color: dividerColor),
            _row('Subtotal', subtotal, theme, textPrimary),
            _row('Discount', -discount, theme, errorColor),
            _row('Tax', tax, theme, textPrimary),
            Divider(height: 20, color: dividerColor),
            _row('Total', totalAmount, theme, textPrimary, bold: true),
          ],
        ),
      ),
    );
  }

  Widget _row(
    String label,
    double value,
    ThemeData theme,
    Color textColor, {
    bool bold = false,
  }) {
    final style =
        (bold
                ? theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  )
                : theme.textTheme.bodyMedium)
            ?.copyWith(color: textColor);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
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

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
