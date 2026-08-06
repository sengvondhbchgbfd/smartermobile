import 'package:flutter/material.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/widgets/invoice_theme_color.dart';
import 'package:frontendmobile/features/inventory/quotations/domain/entities/quotation_entity.dart';

class QuotationCard extends StatelessWidget {
  final QuotationEntity quotation;
  final bool expanded;
  final bool converting;
  final VoidCallback onToggleExpanded;
  final VoidCallback onConvert;

  const QuotationCard({
    required this.quotation,
    required this.expanded,
    required this.converting,
    required this.onToggleExpanded,
    required this.onConvert,
    super.key,
  });

  ///////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////
    ///
    ///////////////////////////////////////////////////
    final colors = context.invoiceColors;
    final q = quotation;

    ////////////////////////////////////////////////////
    ///
    ///////////////////////////////////////////////////

    return Container(
      margin: const EdgeInsets.only(bottom: 10),

      ////////////////////////////////////////////////////
      ///
      ///////////////////////////////////////////////////
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border),
      ),

      ////////////////////////////////////////////////////
      ///
      ///////////////////////////////////////////////////
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onToggleExpanded,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colors.accent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.description_outlined,
                      color: colors.accent,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  ////////////////////////////////////////////////////
                  ///
                  ///////////////////////////////////////////////////
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          q.refNumber,
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),

                        ////////////////////////////////////////////////////
                        ///
                        ///////////////////////////////////////////////////
                        Text(
                          '${q.customerName ?? 'No customer'} • ${q.items.length} item(s)',
                          style: TextStyle(
                            color: colors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${q.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ////////////////////////////////////////////////////
                      ///
                      ///////////////////////////////////////////////////
                      Icon(
                        expanded ? Icons.expand_less : Icons.expand_more,
                        size: 18,
                        color: colors.textSecondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (expanded) ...[
            Divider(height: 1, color: colors.border),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final item in q.items)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.size != null
                                  ? '${item.itemName} • ${item.size}'
                                  : item.itemName,
                              style: TextStyle(
                                color: colors.textPrimary,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Text(
                            '×${item.quantity}  \$${item.totalPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: colors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 10),

                  ////////////////////////////////////////////////////
                  ///
                  ///////////////////////////////////////////////////
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: converting ? null : onConvert,
                      style: FilledButton.styleFrom(
                        backgroundColor: colors.accent,
                        foregroundColor: colors.onAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: converting
                          ? SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colors.onAccent,
                              ),
                            )
                          : const Icon(Icons.arrow_forward_rounded, size: 16),
                      label: const Text('Convert to Invoice'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
