import 'package:flutter/material.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/widgets/invoice_theme_color.dart';

Future<String?> showPaymentTypeSheet(BuildContext context) {
  final colors = context.invoiceColors;
  const options = [
    ('Cash', 'cash', Icons.payments_outlined),
    ('Card', 'card', Icons.credit_card_outlined),
    ('Bank Transfer', 'transfer', Icons.account_balance_outlined),
  ];

  return showModalBottomSheet<String>(
    /////////////////////////////////////
    ///
    /////////////////////////////////////
    context: context,
    backgroundColor: colors.overlay,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),

    /////////////////////////////////////
    ///
    /////////////////////////////////////
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ///////////////////////////////
          ///
          ///////////////////////////////
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "How was this paid?",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: colors.textPrimary,
                  ),
                ),
              ),
            ),
          ),

          ///////////////////////////////
          ///
          ///////////////////////////////
          for (final (label, value, icon) in options)
            ListTile(
              leading: Icon(icon, color: colors.accent),
              title: Text(label, style: TextStyle(color: colors.textPrimary)),
              onTap: () => Navigator.pop(ctx, value),
            ),

          //////////////////////////////
          ///
          //////////////////////////////
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}
