import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/core/utils/date_formatter.dart';
import 'package:frontendmobile/features/company/presentation/widgets/card/info_row.dart';
import 'package:frontendmobile/features/inventory/quotations/domain/entities/quotation_entity.dart';
import 'package:frontendmobile/features/inventory/quotations/domain/entities/quotation_enums.dart';
import 'package:frontendmobile/features/inventory/quotations/presentation/widgets/quotation_status_badge.dart';

class QuotationHeaderCard extends StatelessWidget {
  final QuotationEntity quotation;
  const QuotationHeaderCard({super.key, required this.quotation});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final q = quotation;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? Pallets.surfaceCard : Pallets.surfaceLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Pallets.borderDark : Pallets.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                q.refNumber,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? Pallets.textPrimaryDark
                      : Pallets.textPrimaryLight,
                ),
              ),
              QuotationStatusBadge(status: q.status),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            q.customerName ?? 'Customer #${q.customerId}',
            style: TextStyle(color: Pallets.textSecondaryDark),
          ),
          const SizedBox(height: 16),
          if (q.expiryDate != null)
            InfoRow(
              icon: Icons.event_busy_outlined,
              label: 'Expiry date',
              value: DateFormatter.date.format(q.expiryDate!),
            ),
          if (q.productionDays != null)
            InfoRow(
              icon: Icons.timelapse_outlined,
              label: 'Production days',
              value: '${q.productionDays} days',
            ),
          if (q.artworkStatus != null)
            InfoRow(
              icon: Icons.brush_outlined,
              label: 'Artwork status',
              value: q.artworkStatus!.label,
            ),
          if (q.deliveryMethod != null)
            InfoRow(
              icon: Icons.local_shipping_outlined,
              label: 'Delivery method',
              value: q.deliveryMethod!.label,
            ),
          if (q.paymentTerms != null && q.paymentTerms!.isNotEmpty)
            InfoRow(
              icon: Icons.payments_outlined,
              label: 'Payment terms',
              value: q.paymentTerms!,
            ),
          if (q.note != null && q.note!.isNotEmpty)
            InfoRow(
              icon: Icons.sticky_note_2_outlined,
              label: 'Note',
              value: q.note!,
            ),
        ],
      ),
    );
  }
}
