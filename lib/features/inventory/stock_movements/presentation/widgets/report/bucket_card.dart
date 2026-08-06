import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/inventory/stock_movements/domain/entities/stock_movement_report_entity.dart';
import 'package:frontendmobile/features/inventory/stock_movements/presentation/widgets/report/mini_state.dart';

class BucketCard extends StatelessWidget {
  final StockMovementReportBucket bucket;
  final Color card;
  final Color border;
  final Color sub;
  final Color textPrimary;
  final bool isDark;
  final String Function(double) money;
  final Color inColor;
  final Color outColor;

  const BucketCard({
    super.key,
    required this.bucket,
    required this.card,
    required this.border,
    required this.sub,
    required this.textPrimary,
    required this.isDark,
    required this.money,
    required this.inColor,
    required this.outColor,
  });

  @override
  Widget build(BuildContext context) {
    final hasBalance =
        bucket.openingBalance != null && bucket.closingBalance != null;
    final netPositive = bucket.netChange >= 0;
    final accent = netPositive ? inColor : outColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border, width: 0.6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.16 : 0.03),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 4, color: accent),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
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
                                  bucket.displayName,
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w700,
                                    color: textPrimary,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                if (bucket.categoryName != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: Text(
                                      [
                                        bucket.periodLabel,
                                        bucket.categoryName!,
                                      ].join(' · '),
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: sub,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Pallets.blurple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${bucket.movementCount} moves',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: Pallets.blurple,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: MiniStat(
                              label: 'In',
                              value: '${bucket.qtyIn}',
                              sub: sub,
                              valueColor: inColor,
                            ),
                          ),
                          Expanded(
                            child: MiniStat(
                              label: 'Out',
                              value: '${bucket.qtyOut}',
                              sub: sub,
                              valueColor: outColor,
                            ),
                          ),
                          Expanded(
                            child: MiniStat(
                              label: 'Net',
                              value: '${bucket.netChange}',
                              sub: sub,
                              valueColor: textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: MiniStat(
                              label: 'Value in',
                              value: money(bucket.valueIn),
                              sub: sub,
                              valueColor: inColor,
                            ),
                          ),
                          Expanded(
                            child: MiniStat(
                              label: 'Value out',
                              value: money(bucket.valueOut),
                              sub: sub,
                              valueColor: outColor,
                            ),
                          ),
                          Expanded(
                            child: MiniStat(
                              label: 'Net value',
                              value: money(bucket.netValue),
                              sub: sub,
                              valueColor: textPrimary,
                            ),
                          ),
                        ],
                      ),
                      if (hasBalance) ...[
                        const SizedBox(height: 12),
                        Container(height: 1, color: border),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Pallets.blurple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.swap_horiz_rounded,
                                size: 13,
                                color: Pallets.blurple,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Opening ${bucket.openingBalance}  →  Closing ${bucket.closingBalance}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
