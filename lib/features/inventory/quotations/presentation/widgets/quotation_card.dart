import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:frontendmobile/core/themes/app_pallets.dart';

import '../../domain/entities/quotation_entity.dart';
import 'quotation_status_badge.dart';

class QuotationCard extends StatelessWidget {
  final QuotationEntity quotation;
  final VoidCallback onTap;

  const QuotationCard({
    super.key,
    required this.quotation,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dateFmt = DateFormat('dd MMM yyyy');
    final isExpiringSoon =
        quotation.expiryDate != null &&
        quotation.expiryDate!.difference(DateTime.now()).inDays <= 3;

    return Material(
      color: isDark ? Pallets.surfaceCard : Pallets.surfaceLight,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Pallets.borderDark : Pallets.borderLight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      quotation.refNumber,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? Pallets.textPrimaryDark
                            : Pallets.textPrimaryLight,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  QuotationStatusBadge(status: quotation.status, compact: true),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                quotation.customerName ??
                    'Customer #${quotation.customerId ?? '-'}',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? Pallets.textSecondaryDark
                      : Pallets.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.event_outlined,
                    size: 14,
                    color: isDark
                        ? Pallets.textSecondaryDark
                        : Pallets.textSecondaryLight,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    dateFmt.format(quotation.quotationDate),
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? Pallets.textSecondaryDark
                          : Pallets.textSecondaryLight,
                    ),
                  ),
                  if (quotation.expiryDate != null) ...[
                    const SizedBox(width: 14),
                    Icon(
                      Icons.hourglass_bottom_outlined,
                      size: 14,
                      color: isExpiringSoon
                          ? Pallets.warning
                          : (isDark
                                ? Pallets.textSecondaryDark
                                : Pallets.textSecondaryLight),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Expires ${dateFmt.format(quotation.expiryDate!)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isExpiringSoon
                            ? Pallets.warning
                            : (isDark
                                  ? Pallets.textSecondaryDark
                                  : Pallets.textSecondaryLight),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 10),
              Container(
                height: 1,
                color: isDark ? Pallets.dividerDark : Pallets.dividerLight,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${quotation.items.length} item${quotation.items.length == 1 ? '' : 's'}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? Pallets.textSecondaryDark
                          : Pallets.textSecondaryLight,
                    ),
                  ),
                  Text(
                    NumberFormat.currency(
                      symbol: '\$',
                    ).format(quotation.totalAmount),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Pallets.blurple,
                    ),
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
