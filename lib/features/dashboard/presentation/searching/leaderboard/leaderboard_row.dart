import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/dashboard/presentation/searching/search_item.dart';

class LeaderboardRow extends StatelessWidget {
  final SearchItem item;
  final int rank;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback onTap;

  const LeaderboardRow({
    super.key,
    required this.item,
    required this.rank,
    required this.textPrimary,
    required this.textSecondary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final rankColor = rank == 1
        ? Pallets
              .warning // gold/amber
        : rank == 2
        ? Pallets
              .error // red
        : rank == 3
        ? Pallets
              .gradient1 // purple
        : textSecondary;

    final badge = rank == 1
        ? 'NEW'
        : rank == 2
        ? 'HOT'
        : null;

    final badgeColor = rank == 1 ? Pallets.warning : Pallets.error;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              child: Text(
                '$rank',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: rankColor,
                ),
              ),
            ),
            const SizedBox(width: 12),
            _iconBox(item.icon, item.iconColor),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: rank <= 3 ? FontWeight.w600 : FontWeight.w400,
                      color: textPrimary,
                    ),
                  ),
                  Text(
                    item.subtitle,
                    style: TextStyle(fontSize: 11, color: textSecondary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: badgeColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _iconBox(IconData icon, Color color) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, color: color, size: 16),
    );
  }
}
