import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:frontendmobile/core/themes/app_pallets.dart';

class QuotationSummaryCard extends StatelessWidget {
  final Map<String, dynamic> summary;

  const QuotationSummaryCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final total = summary['total_quotations'] ?? 0;
    final draft = summary['total_draft'] ?? 0;
    final sent = summary['total_sent'] ?? 0;
    final accepted = summary['total_accepted'] ?? 0;
    final totalAmount =
        double.tryParse('${summary['total_amount'] ?? 0}') ?? 0;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: Pallets.brandGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Quotation Value',
            style: TextStyle(
              color: Pallets.onAccent.withOpacity(0.85),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            NumberFormat.currency(symbol: '\$').format(totalAmount),
            style: TextStyle(
              color: Pallets.onAccent,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _StatChip(label: 'Total', value: '$total'),
              const SizedBox(width: 10),
              _StatChip(label: 'Draft', value: '$draft'),
              const SizedBox(width: 10),
              _StatChip(label: 'Sent', value: '$sent'),
              const SizedBox(width: 10),
              _StatChip(label: 'Accepted', value: '$accepted'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;

  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: Pallets.onAccent,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: Pallets.onAccent.withOpacity(0.8),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
