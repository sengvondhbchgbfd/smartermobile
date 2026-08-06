import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/communication/notifications/presentation/providers/notification_provider.dart';
import 'package:frontendmobile/features/communication/notifications/presentation/providers/notification_state.dart';
import 'package:frontendmobile/features/communication/notifications/presentation/widgets/chip.dart';

class FilterBar extends ConsumerWidget {
  const FilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? Pallets.surfaceDark : Pallets.surfaceLight;

    final filter =
        ref.watch(notificationNotifierProvider).valueOrNull?.filter ??
        NotificationFilter.all;

    return Container(
      color: surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Chipes(
            label: 'All',
            selected: filter == NotificationFilter.all,
            onTap: () => ref
                .read(notificationNotifierProvider.notifier)
                .setFilter(NotificationFilter.all),
          ),
          const SizedBox(width: 8),
          Chipes(
            label: 'Unread',
            selected: filter == NotificationFilter.unread,
            onTap: () => ref
                .read(notificationNotifierProvider.notifier)
                .setFilter(NotificationFilter.unread),
          ),
        ],
      ),
    );
  }
}
