import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'header_icon_button.dart';
import 'stat_pill.dart';

class InvoicesHeader extends StatelessWidget {
  final VoidCallback onClose;
  final int invoiceCount;
  final double totalRevenue;

  const InvoicesHeader({
    super.key,
    required this.onClose,
    required this.invoiceCount,
    required this.totalRevenue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + 10,
        16,
        22,
      ),
      decoration: const BoxDecoration(
        gradient: Pallets.bannerGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              HeaderIconButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: onClose,
              ),
              const Spacer(),
              const HeaderIconButton(
                icon: Icons.receipt_long_rounded,
                onTap: null,
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Invoices',
            style: TextStyle(
              color: Pallets.onAccent,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Track sales and manage billing',
            style: TextStyle(
              color: Pallets.onAccent.withValues(alpha: 0.85),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: StatPill(label: 'Invoices', value: '$invoiceCount'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatPill(
                  label: 'Revenue',
                  value: '\$${totalRevenue.toStringAsFixed(2)}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
