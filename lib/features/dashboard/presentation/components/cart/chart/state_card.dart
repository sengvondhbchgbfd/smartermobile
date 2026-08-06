import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/dashboard/presentation/components/cart/chart/spark_line_painter.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String value;
  final String? stockIn;   // optional now
  final String? stockOut;  // optional now
  final String sub;
  final bool isUp;
  final bool isLive;
  final String badge;
  final List<double> sparkData;
  final Color sparkColor;

  const StatCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.value,
    this.stockIn,
    this.stockOut,
    required this.sub,
    required this.isUp,
    required this.isLive,
    required this.badge,
    required this.sparkData,
    required this.sparkColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? Pallets.surfaceCard : Pallets.surfaceLight;
    final cardBorder = isDark ? Pallets.borderDark : Pallets.borderLight;
    final labelColor = isDark ? Pallets.textMuted : Pallets.textSecondaryLight;
    final valueColor = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;

    final chipColor = isLive
        ? Pallets.blurple
        : isUp
        ? Pallets.success
        : Pallets.error;
    final chipBg = isLive
        ? Pallets.blurple.withOpacity(0.15)
        : isUp
        ? Pallets.success.withOpacity(0.12)
        : Pallets.error.withOpacity(0.12);

    final cardWidth = (MediaQuery.sizeOf(context).width - 36 - 10) / 2;
    final hasInOut = stockIn != null && stockOut != null;

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border.all(color: cardBorder, width: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Icon(icon, size: 14, color: iconColor),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: chipBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: chipColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 11, color: labelColor)),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: valueColor,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 1),
          Text(sub, style: TextStyle(fontSize: 10, color: labelColor)),
          //////////////////////////////////////////////////////////////////
          /// Stock in/out row — only rendered when both values are present
          //////////////////////////////////////////////////////////////////
          if (hasInOut) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.arrow_upward_rounded, size: 11, color: Pallets.success),
                const SizedBox(width: 2),
                Text(
                  stockIn!,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: labelColor,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_downward_rounded, size: 11, color: Pallets.error),
                const SizedBox(width: 2),
                Text(
                  stockOut!,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: labelColor,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 6),
          SizedBox(
            height: 28,
            width: double.infinity,
            child: CustomPaint(
              painter: SparklinePainter(data: sparkData, color: sparkColor),
            ),
          ),
        ],
      ),
    );
  }
}