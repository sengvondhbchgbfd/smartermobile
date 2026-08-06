import 'package:flutter/material.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/widgets/invoice_theme_color.dart';

class PaymentChips extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const PaymentChips({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  //////////////////////////////////
  ///
  /////////////////////////////////
  static const _options = [
    ('Cash', 'cash', Icons.payment_outlined),
    ('Card', 'card', Icons.credit_card_outlined),
    ('Trabsfer', 'transfer', Icons.account_balance_outlined),
  ];

  ////////////////////////////////
  ///
  ////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final (label, value, icon) in _options)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: value == _options.last.$2 ? 0 : 8,
              ),
              child: _chip(context, label, value, icon),
            ),
          ),
      ],
    );
  }

  //////////////////////////
  ///
  /////////////////////////

  Widget _chip(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final isSelected = value == selected;
    final colors = context.invoiceColors;

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? colors.accent.withOpacity(0.12) : colors.card,
          border: Border.all(color: isSelected ? colors.accent : colors.border),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? colors.accent : colors.textSecondary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? colors.accent : colors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
