import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/dashboard/presentation/components/cart/chart/state_card.dart'
    show StatCard;
import 'package:frontendmobile/features/dashboard/presentation/providers/dashboard_provider.dart';

class ProfileRow extends ConsumerWidget {
  const ProfileRow({super.key, required this.profileAsync});
  final AsyncValue<dynamic> profileAsync;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsNotifierProvider());
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      clipBehavior: Clip.none,
      child: statsAsync.when(
        loading: () => const _StatRowSkeleton(),
        error: (err, st) => _StatRowError(
          onRetry: () =>
              ref.read(dashboardStatsNotifierProvider().notifier).refresh(),
        ),

        data: (stats) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatCard(
              width: 150,
              height: 170,
              icon: Icons.trending_up_rounded,
              iconColor: Pallets.success,
              iconBg: Pallets.success.withOpacity(0.10),
              label: 'Stock',
              value: stats.stock.value.toStringAsFixed(0),
              stockIn: stats.stock.stockIn?.toStringAsFixed(0),
              stockOut: stats.stock.stockOut?.toStringAsFixed(0),
              sub: stats.stock.sub,
              isUp: (stats.stock.badgePct ?? 0) >= 0,
              isLive: false,
              badge: _formatPct(stats.stock.badgePct),
              sparkData: stats.stock.spark,
              sparkColor: Pallets.success,
              allTime: stats.stock.allTimeValue != null
                  ? 'All: ${_compact(stats.stock.allTimeValue!)}'
                  : null,
            ),

            const SizedBox(width: 10),
            StatCard(
              width: 150,
              height: 170,
              icon: Icons.inventory_2_outlined,
              iconColor: Pallets.blurple,
              iconBg: Pallets.blurple.withOpacity(0.10),
              label: 'Stock value',
              value: '\$${_compact(stats.stockValue.value)}',
              sub: stats.stockValue.sub,
              isUp: (stats.stockValue.badgePct ?? 0) >= 0,
              isLive: false,
              badge: _formatPct(stats.stockValue.badgePct),
              sparkData: stats.stockValue.spark,
              sparkColor: Pallets.blurple,
            ),

            const SizedBox(width: 10),
            StatCard(
              width: 150,
              height: 170,
              icon: Icons.receipt_long_outlined,
              iconColor: Pallets.warning,
              iconBg: Pallets.warning.withOpacity(0.10),
              label: 'Expenses',
              value: '\$${_compact(stats.expenses.value)}',
              sub: stats.expenses.sub,
              isUp: (stats.expenses.badgePct ?? 0) >= 0,
              isLive: false,
              badge: _formatPct(stats.expenses.badgePct),
              sparkData: stats.expenses.spark,
              sparkColor: Pallets.warning,
              allTime: stats.expenses.allTimeValue != null
                  ? 'All: \$${_compact(stats.expenses.allTimeValue!)}'
                  : null,
            ),

            const SizedBox(width: 10),
            StatCard(
              width: 150,
              height: 170,
              icon: Icons.account_balance_wallet_outlined,
              iconColor: Pallets.info,
              iconBg: Pallets.info.withOpacity(0.10),
              label: 'Revenue',
              value: '\$${_compact(stats.revenue.value)}',
              sub: stats.revenue.sub,
              isUp: (stats.revenue.badgePct ?? 0) >= 0,
              isLive: false,
              badge: _formatPct(stats.revenue.badgePct),
              sparkData: stats.revenue.spark,
              sparkColor: Pallets.info,
              allTime: stats.revenue.allTimeValue != null
                  ? 'All: \$${_compact(stats.revenue.allTimeValue!)}'
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  static String _formatPct(double? pct) {
    if (pct == null) return '0%';
    final sign = pct >= 0 ? '+' : '';
    return '$sign${pct.toStringAsFixed(1)}%';
  }

  static String _compact(double value) {
    final s = value.toStringAsFixed(0);
    return s.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');
  }
}

////////////////////////////////////////////////////////////////////////////
/// Loading skeleton — 4 ghost cards in a row
////////////////////////////////////////////////////////////////////////////

class _StatRowSkeleton extends StatelessWidget {
  const _StatRowSkeleton();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(4, (i) {
        return Padding(
          padding: EdgeInsets.only(right: i == 3 ? 0 : 10),
          child: Container(
            width: 140,
            height: 110,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      }),
    );
  }
}

////////////////////////////////////////////////////////////////////////////
/// Error state — small retry chip
////////////////////////////////////////////////////////////////////////////

class _StatRowError extends StatelessWidget {
  const _StatRowError({required this.onRetry});
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 18, color: Colors.redAccent),
          const SizedBox(width: 8),
          const Text('Failed to load stats'),
          const SizedBox(width: 8),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
