import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import '../../domain/entities/invoice_entity.dart';

// ---------------------------------------------------------------------------
// Invoice tile
//
// ⚠️ NOTE: this renders bare (no Card/margin of its own) because
// InvoicesScreen already wraps each tile in a rounded, shadowed Container.
// If you use InvoiceTile anywhere else without that wrapper, wrap it in a
// Container/Card there instead of re-adding one here.
//
// ⚠️ The "New Invoice" form used to live here as InvoiceFormDialog. It has
// moved to invoice_form_screen.dart as a full-screen page (InvoiceFormScreen)
// — delete any leftover references to InvoiceFormDialog in your codebase.
// ---------------------------------------------------------------------------

class InvoiceTile extends StatelessWidget {
  final InvoiceEntity invoice;
  final String customerName;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const InvoiceTile({
    required this.invoice,
    required this.customerName,
    required this.onTap,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color textPrimary =
        isDark ? Pallets.textPrimaryDark : Pallets.textPrimaryLight;
    final Color textSecondary =
        isDark ? Pallets.textSecondaryDark : Pallets.textSecondaryLight;
    final Color accent = Pallets.blurple;
    final Color accentTint = Pallets.infoTint;
    final Color errorColor = Pallets.error;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: accentTint,
                child: Icon(
                  Icons.receipt_long_outlined,
                  color: accent,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Invoice #${invoice.invoiceId}',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      customerName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: textSecondary,
                      ),
                    ),
                    Text(
                      '${invoice.items.length} item${invoice.items.length == 1 ? '' : 's'}   •   ${invoice.paymentType}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '\$${(invoice.totalAmount ?? 0).toStringAsFixed(2)}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: errorColor,
                      size: 20,
                    ),
                    onPressed: onDelete,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}