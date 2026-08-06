import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class QuotationDetailShimmer extends StatelessWidget {
  final int itemCount;
  const QuotationDetailShimmer({this.itemCount = 3, super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? Pallets.surfaceElevated : Pallets.borderLight;
    final highlight = isDark ? Pallets.surfaceCard : Pallets.backgroundLight;
    final cardBg = isDark ? Pallets.surfaceCard : Pallets.surfaceLight;
    final border = isDark ? Pallets.borderDark : Pallets.borderLight;

    Widget block({
      required double width,
      required double height,
      double radius = 4,
    }) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      );
    }

    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        children: [
          // ---------------------------------------------------------
          // QuotationHeaderCard: ref number + badge, customer name,
          // then a handful of InfoRow lines
          // ---------------------------------------------------------
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    block(width: 110, height: 20),
                    block(width: 60, height: 20, radius: 10),
                  ],
                ),
                const SizedBox(height: 10),
                block(width: 140, height: 13),
                const SizedBox(height: 18),
                for (var i = 0; i < 4; i++) ...[
                  Row(
                    children: [
                      block(width: 16, height: 16, radius: 4),
                      const SizedBox(width: 10),
                      block(width: 90, height: 11),
                      const SizedBox(width: 8),
                      block(width: 70, height: 11),
                    ],
                  ),
                  if (i != 3) const SizedBox(height: 12),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Items header
          block(width: 90, height: 15),
          const SizedBox(height: 10),

          // ---------------------------------------------------------
          // QuotationItemTile: itemName/specs/qty on the left,
          // total price + edit/delete icons on the right
          // ---------------------------------------------------------
          for (var i = 0; i < itemCount; i++)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        block(width: 130, height: 14),
                        const SizedBox(height: 6),
                        block(width: 170, height: 12),
                        const SizedBox(height: 8),
                        block(width: 90, height: 12),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      block(width: 60, height: 14),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          block(width: 18, height: 18, radius: 4),
                          const SizedBox(width: 8),
                          block(width: 18, height: 18, radius: 4),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),

          // ---------------------------------------------------------
          // QuotationTotalsCard: Subtotal, Discount, Tax, divider, Total
          // ---------------------------------------------------------
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Pallets.surfaceElevated : Pallets.surfaceLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                for (var i = 0; i < 3; i++) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      block(width: 70, height: 12),
                      block(width: 60, height: 12),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  color: isDark ? Pallets.dividerDark : Pallets.dividerLight,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    block(width: 60, height: 15),
                    block(width: 80, height: 15),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
