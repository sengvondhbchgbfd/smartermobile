import 'package:flutter/material.dart';
import '../../../domain/entities/stock_movement_report_entity.dart';

class ClosingStockSummary extends StatelessWidget {
  final StockMovementReportEntity report;
  final Color card;
  final Color border;
  final Color sub;
  final Color textPrimary;
  final bool isDark;

  const ClosingStockSummary({
    super.key,
    required this.report,
    required this.card,
    required this.border,
    required this.sub,
    required this.textPrimary,
    required this.isDark,
  });

  String _money(double v) => '\$${v.toStringAsFixed(2)}';
  @override
  Widget build(BuildContext context) {
    final withBalance = report.buckets
        .where((b) => b.closingBalance != null)
        .toList();

    if (withBalance.isEmpty) return const SizedBox.shrink();

    final totalOpening = withBalance.fold<int>(
      0,
      (a, b) => a + (b.openingBalance ?? 0),
    );
    final totalClosing = withBalance.fold<int>(
      0,
      (a, b) => a + (b.closingBalance ?? 0),
    );
    final delta = totalClosing - totalOpening;
    final deltaColor = delta > 0
        ? const Color(0xFF12B886)
        : delta < 0
        ? const Color(0xFFE8555A)
        : sub;

    // Prefer the backend-computed total; fall back to summing buckets
    // in case an older API response doesn't include it yet.
    final closingStockValue =
        report.totalClosingStockValue ??
        withBalance.fold<double>(0, (a, b) => a + (b.closingStockValue ?? 0));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border, width: 0.6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Closing Stock',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: sub,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$totalClosing',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'across ${withBalance.length} variant${withBalance.length == 1 ? '' : 's'}',
                      style: TextStyle(fontSize: 11, color: sub),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Opening', style: TextStyle(fontSize: 11, color: sub)),
                  const SizedBox(height: 2),
                  Text(
                    '$totalOpening',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        delta > 0
                            ? Icons.arrow_upward_rounded
                            : delta < 0
                            ? Icons.arrow_downward_rounded
                            : Icons.horizontal_rule_rounded,
                        size: 14,
                        color: deltaColor,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${delta.abs()}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: deltaColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(height: 1, color: border),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Closing Stock Value',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: sub,
                ),
              ),
              Text(
                _money(closingStockValue),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
