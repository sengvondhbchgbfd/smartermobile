import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/dashboard/presentation/providers/search_provider.dart';
import 'package:frontendmobile/features/dashboard/presentation/searching/leaderboard/leaderboard_row.dart';
import 'package:frontendmobile/features/dashboard/presentation/searching/search_item.dart';

class DynamicLeaderboard extends ConsumerWidget {
  final SearchCategory category;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final ValueChanged<SearchItem> onItemTap;

  const DynamicLeaderboard({
    super.key,
    required this.category,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    final allDynamic = ref.watch(searchDynamicItemsProvider);
    final items = allDynamic.where((i) => i.category == category).toList();
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.hourglass_empty_rounded, size: 32, color: textSecondary),
            const SizedBox(height: 8),
            Text(
              'No ${category.label} loaded yet',
              style: TextStyle(color: textSecondary, fontSize: 13),
            ),
          ],
        ),
      );
    }
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: items.length.clamp(0, 15),
      separatorBuilder: (_, __) =>
          Divider(height: 1, color: border.withValues(alpha: 0.4)),
      itemBuilder: (_, i) => LeaderboardRow(
        item: items[i],
        rank: i + 1,
        textPrimary: textPrimary,
        textSecondary: textSecondary,
        onTap: () => onItemTap(items[i]),
      ),
    );
  }
}
