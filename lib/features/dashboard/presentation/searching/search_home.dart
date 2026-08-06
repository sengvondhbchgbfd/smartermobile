import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/dashboard/presentation/searching/leaderboard/dynamic_leaderboard.dart';
import 'package:frontendmobile/features/dashboard/presentation/searching/search_item.dart';

class SearchHome extends StatelessWidget {
  final TabController tabController;
  final List<(String, bool)> tabs;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final ValueChanged<SearchItem> onItemTap;

  const SearchHome({
    super.key,
    required this.tabController,
    required this.tabs,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Text(
            'what is hiden you?',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
        ),
        ////////////////////////////////////////////////////////////////////////
        // ── Horizontally draggable tab bar ─────────────────────────────────
        ////////////////////////////////////////////////////////////////////////
        ScrollConfiguration(
          behavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {...PointerDeviceKind.values},
          ),
          child: TabBar(
            controller: tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: Pallets.gradient2,
            indicatorWeight: 2,
            labelColor: textPrimary,
            unselectedLabelColor: textSecondary,
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            dividerColor: border,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            tabs: tabs
                .map(
                  (t) => Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(t.$1),
                        if (t.$2) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Pallets.warning
                                  : Pallets.warning.withOpacity(0.85),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Hot',
                              style: TextStyle(
                                fontSize: 9,
                                color: isDark
                                    ? Pallets.onWarning
                                    : Pallets.onWarning,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        ////////////////////////////////////////////////////////////////////////
        const SizedBox(height: 8),
        ////////////////////////////////////////////////////////////////////////
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              DynamicLeaderboard(
                category: SearchCategory.staff,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                border: border,
                onItemTap: onItemTap,
              ),
              DynamicLeaderboard(
                category: SearchCategory.product,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                border: border,
                onItemTap: onItemTap,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
