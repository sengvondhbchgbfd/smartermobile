import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

enum ShimmerItemStyle { card, listRow, quotationCard }

class AppListShimmer extends StatelessWidget {
  final int itemCount;
  final ShimmerItemStyle style;
  final double? itemHeight;

  const AppListShimmer({
    this.itemCount = 6,
    this.style = ShimmerItemStyle.card,
    this.itemHeight,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? Pallets.surfaceElevated : Pallets.borderLight;
    final highlight = isDark ? Pallets.surfaceCard : Pallets.backgroundLight;
    final cardBg = isDark ? Pallets.surfaceCard : Pallets.surfaceLight;
    final border = isDark ? Pallets.borderDark : Pallets.borderLight;

    return ListView.builder(
      itemCount: itemCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      itemBuilder: (_, __) {
        switch (style) {
          case ShimmerItemStyle.quotationCard:
            return _quotationCardItem(
              cardBg: cardBg,
              border: border,
              base: base,
              highlight: highlight,
            );
          case ShimmerItemStyle.listRow:
            return _listRowItem(
              border: border,
              base: base,
              highlight: highlight,
            );
          case ShimmerItemStyle.card:
            return _cardItem(
              cardBg: cardBg,
              border: border,
              base: base,
              highlight: highlight,
            );
        }
      },
    );
  }

  // ---------------------------------------------------------------------
  // Matches QuotationCard: ref number + badge, customer name, date row,
  // divider, footer (item count / total price)
  // ---------------------------------------------------------------------
  Widget _quotationCardItem({
    required Color cardBg,
    required Color border,
    required Color base,
    required Color highlight,
  }) {
    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        height: itemHeight,
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 15,
                  width: 90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const Spacer(),
                Container(
                  height: 18,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 13,
              width: 130,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 12,
              width: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 10),
            Container(height: 1, color: border),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 12,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  height: 15,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Generic bordered card: avatar circle + 3 text lines + 2 square actions
  // ---------------------------------------------------------------------
  Widget _cardItem({
    required Color cardBg,
    required Color border,
    required Color base,
    required Color highlight,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      height: itemHeight,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border, width: 1),
      ),
      child: Shimmer.fromColors(
        baseColor: base,
        highlightColor: highlight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 13,
                    width: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 10,
                    width: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 10,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Plain row: avatar + 2 lines, bottom divider, no card chrome
  // (placeholder proportions — adjust once matched to a real widget)
  // ---------------------------------------------------------------------
  Widget _listRowItem({
    required Color border,
    required Color base,
    required Color highlight,
  }) {
    return Container(
      height: itemHeight ?? 64,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: border, width: 0.5)),
      ),
      child: Shimmer.fromColors(
        baseColor: base,
        highlightColor: highlight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 13,
                    width: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 10,
                    width: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
