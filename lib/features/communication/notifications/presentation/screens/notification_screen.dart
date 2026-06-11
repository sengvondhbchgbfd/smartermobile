import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/communication/notifications/presentation/providers/notification_provider.dart';
import 'package:frontendmobile/features/communication/notifications/presentation/providers/notification_state.dart';
import 'package:frontendmobile/features/communication/notifications/presentation/widgets/notification_tile.dart';
import 'package:go_router/go_router.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(notificationNotifierProvider.notifier).loadMyNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifAsync = ref.watch(notificationNotifierProvider);
    final data = notifAsync.valueOrNull;
    final isSelecting = data?.isSelecting ?? false;
    final selectedIds = data?.selectedIds ?? {};
    final unread = data?.summary?.unread ?? 0;

    return Scaffold(
      backgroundColor: Pallets.backgroundDark,
      appBar: AppBar(
        backgroundColor: Pallets.surfaceDark,
        elevation: 0,
        leading: isSelecting
            ? IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => ref
                    .read(notificationNotifierProvider.notifier)
                    .clearSelection(),
              )
            // ── Custom arrowhead back button ──────────────────────────
            : const _BackButton(),
        title: isSelecting
            ? Text(
                '${selectedIds.length} selected',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  if (unread > 0)
                    Text(
                      '$unread unread',
                      style: TextStyle(
                        color: Pallets.textSecondaryDark,
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
        actions: [
          if (isSelecting) ...[
            TextButton(
              onPressed: () =>
                  ref.read(notificationNotifierProvider.notifier).selectAll(),
              child: Text('All', style: TextStyle(color: Pallets.gradient2)),
            ),
            IconButton(
              icon: const Icon(Icons.done_all, color: Colors.white),
              tooltip: 'Mark selected read',
              onPressed: () => ref
                  .read(notificationNotifierProvider.notifier)
                  .bulkMarkRead(),
            ),
          ] else ...[
            if (unread > 0)
              IconButton(
                icon: const Icon(Icons.done_all, color: Colors.white),
                tooltip: 'Mark all read',
                onPressed: () => ref
                    .read(notificationNotifierProvider.notifier)
                    .markAllRead(),
              ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              color: Pallets.surfaceDark,
              onSelected: (value) {
                switch (value) {
                  case 'select':
                    ref
                        .read(notificationNotifierProvider.notifier)
                        .toggleSelectionMode();
                    break;
                  case 'delete_read':
                    ref
                        .read(notificationNotifierProvider.notifier)
                        .deleteAllRead();
                    break;
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'select',
                  child: Row(
                    children: [
                      Icon(Icons.checklist, color: Colors.white70, size: 18),
                      SizedBox(width: 8),
                      Text('Select', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete_read',
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_sweep,
                        color: Colors.redAccent,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Delete all read',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          const _FilterBar(),
          Expanded(
            child: notifAsync.when(
              loading: () => Center(
                child: CircularProgressIndicator(color: Pallets.gradient2),
              ),
              error: (e, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.redAccent,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      e.toString(),
                      style: TextStyle(color: Pallets.textSecondaryDark),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => ref
                          .read(notificationNotifierProvider.notifier)
                          .loadMyNotifications(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Pallets.gradient2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (data) {
                final notifications = data.notifications;
                if (notifications.isEmpty) return const _EmptyState();

                return RefreshIndicator(
                  color: Pallets.gradient2,
                  backgroundColor: Pallets.surfaceDark,
                  onRefresh: () => ref
                      .read(notificationNotifierProvider.notifier)
                      .loadMyNotifications(),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: notifications.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: Pallets.borderDark),
                    itemBuilder: (context, index) {
                      final n = notifications[index];
                      final isSelected = data.selectedIds.contains(
                        n.notificationId,
                      );
                      return NotificationTile(
                        notification: n,
                        isSelecting: data.isSelecting,
                        isSelected: isSelected,
                        onTap: () {
                          if (data.isSelecting) {
                            if (n.notificationId != null) {
                              ref
                                  .read(notificationNotifierProvider.notifier)
                                  .toggleSelect(n.notificationId!);
                            }
                          } else {
                            if (n.notificationId != null) {
                              ref
                                  .read(notificationNotifierProvider.notifier)
                                  .markOneRead(n.notificationId!);
                            }
                          }
                        },
                        onLongPress: () {
                          if (!data.isSelecting) {
                            ref
                                .read(notificationNotifierProvider.notifier)
                                .toggleSelectionMode();
                            if (n.notificationId != null) {
                              ref
                                  .read(notificationNotifierProvider.notifier)
                                  .toggleSelect(n.notificationId!);
                            }
                          }
                        },
                        onDismissed: () {
                          if (n.notificationId != null) {
                            ref
                                .read(notificationNotifierProvider.notifier)
                                .deleteOne(n.notificationId!);
                          }
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Custom arrowhead back button ──────────────────────────────────────────────

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.pop(),
      child: Center(
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Pallets.surfaceDark,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: Pallets.borderDark),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 16,
          ),
        ),
      ),
    );
  }
}

// ── Filter bar ────────────────────────────────────────────────────────────────

class _FilterBar extends ConsumerWidget {
  const _FilterBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter =
        ref.watch(notificationNotifierProvider).valueOrNull?.filter ??
        NotificationFilter.all;

    return Container(
      color: Pallets.surfaceDark,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          _Chip(
            label: 'All',
            selected: filter == NotificationFilter.all,
            onTap: () => ref
                .read(notificationNotifierProvider.notifier)
                .setFilter(NotificationFilter.all),
          ),
          const SizedBox(width: 8),
          _Chip(
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

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? Pallets.gradient2 : Pallets.backgroundDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? Pallets.gradient2 : Pallets.borderDark,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Pallets.textSecondaryDark,
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Pallets.surfaceDark,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.notifications_off_outlined,
              color: Pallets.textSecondaryDark,
              size: 36,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No notifications',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "You're all caught up!",
            style: TextStyle(color: Pallets.textSecondaryDark, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
