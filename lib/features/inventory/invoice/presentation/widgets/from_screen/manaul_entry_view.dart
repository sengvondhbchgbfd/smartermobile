import 'package:flutter/material.dart';
import 'package:frontendmobile/features/inventory/customer/domain/entities/customer_entity.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/widgets/from_screen/item_list.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/widgets/from_screen/payment_chip.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/widgets/invoice_theme_color.dart';
import 'draft_item.dart';
import 'totals_summary.dart';

class ManualEntryView extends StatelessWidget {
  ///////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////
  final List<CustomerEntity> customers;
  final int? customerId;
  final ValueChanged<int?> onCustomerChanged;

  final String paymentType;
  final ValueChanged<String> onPaymentTypeChanged;

  final List<DraftItem> items;
  final VoidCallback onAddProduct;
  final ValueChanged<int> onIncrement;
  final ValueChanged<int> onDecrementOrRemove;

  final TextEditingController discountCtrl;
  final TextEditingController taxCtrl;
  final VoidCallback onTotalsChanged;

  final double subtotal;
  final double discount;
  final double tax;
  final double total;

  ///////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////
  const ManualEntryView({
    required this.customers,
    required this.customerId,
    required this.onCustomerChanged,
    required this.paymentType,
    required this.onPaymentTypeChanged,
    required this.items,
    required this.onAddProduct,
    required this.onIncrement,
    required this.onDecrementOrRemove,
    required this.discountCtrl,
    required this.taxCtrl,
    required this.onTotalsChanged,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.total,
    super.key,
  });

  ///////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////
  Widget _sectionLabel(Color color, String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 0.3,
      ),
    ),
  );

  ///////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    ///////////////////////////////////////////////////////
    ///
    //////////////////////////////////////////////////////
    final colors = context.invoiceColors;
    final theme = Theme.of(context);
    final inputBorder = colors.inputBorder(colors.border);

    ///////////////////////////////////////////////////////
    ///
    //////////////////////////////////////////////////////

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel(colors.textSecondary, 'Customer'),
          DropdownButtonFormField<int?>(
            value: customerId,
            dropdownColor: colors.card,
            style: TextStyle(color: colors.textPrimary),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: inputBorder,
              enabledBorder: inputBorder,
              focusedBorder: inputBorder.copyWith(
                borderSide: BorderSide(color: colors.accent, width: 1.5),
              ),
            ),
            items: [
              const DropdownMenuItem(
                value: null,
                child: Text('Walk-in customer'),
              ),
              ...customers.map(
                (c) =>
                    DropdownMenuItem(value: c.customerId, child: Text(c.name)),
              ),
            ],
            onChanged: onCustomerChanged,
          ),
          const SizedBox(height: 18),

          ///////////////////////////////////////////////////////
          ///
          //////////////////////////////////////////////////////
          _sectionLabel(colors.textSecondary, 'Payment Type'),
          PaymentChips(selected: paymentType, onChanged: onPaymentTypeChanged),
          const SizedBox(height: 22),

          ///////////////////////////////////////////////////////
          ///
          //////////////////////////////////////////////////////
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Items (${items.length})',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              TextButton.icon(
                onPressed: onAddProduct,
                style: TextButton.styleFrom(foregroundColor: colors.accent),
                icon: const Icon(Icons.add_circle_outline, size: 18),
                label: const Text('Add Product'),
              ),
            ],
          ),
          const SizedBox(height: 4),

          ///////////////////////////////////////////////////////
          ///
          //////////////////////////////////////////////////////
          ItemsList(
            items: items,
            onIncrement: onIncrement,
            onDecrementOrRemove: onDecrementOrRemove,
          ),
          const SizedBox(height: 22),

          ///////////////////////////////////////////////////////
          ///
          //////////////////////////////////////////////////////
          _sectionLabel(colors.textSecondary, 'Discount & Tax'),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: discountCtrl,
                  style: TextStyle(color: colors.textPrimary),
                  cursorColor: colors.accent,
                  decoration: InputDecoration(
                    labelText: 'Discount',
                    labelStyle: TextStyle(color: colors.textSecondary),
                    prefixText: '\$ ',
                    prefixStyle: TextStyle(color: colors.textPrimary),
                    border: inputBorder,
                    enabledBorder: inputBorder,
                    focusedBorder: inputBorder.copyWith(
                      borderSide: BorderSide(color: colors.accent, width: 1.5),
                    ),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (_) => onTotalsChanged(),
                ),
              ),
              const SizedBox(width: 12),

              ///////////////////////////////////////////////////////
              ///
              //////////////////////////////////////////////////////
              Expanded(
                child: TextFormField(
                  controller: taxCtrl,
                  style: TextStyle(color: colors.textPrimary),
                  cursorColor: colors.accent,
                  decoration: InputDecoration(
                    labelText: 'Tax',
                    labelStyle: TextStyle(color: colors.textSecondary),
                    prefixText: '\$ ',
                    prefixStyle: TextStyle(color: colors.textPrimary),
                    border: inputBorder,
                    enabledBorder: inputBorder,
                    focusedBorder: inputBorder.copyWith(
                      borderSide: BorderSide(color: colors.accent, width: 1.5),
                    ),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (_) => onTotalsChanged(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),

          ///////////////////////////////////////////////////////
          ///
          //////////////////////////////////////////////////////
          TotalsSummary(
            subtotal: subtotal,
            discount: discount,
            tax: tax,
            total: total,
          ),
        ],
      ),
    );
  }
}
