import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontendmobile/features/communication/notifications/domain/entities/notification_entity.dart';
import 'package:frontendmobile/features/communication/notifications/presentation/providers/notification_provider.dart';
import 'package:frontendmobile/features/communication/notifications/presentation/screens/notification_details.dart';
import 'package:frontendmobile/features/communication/notifications/presentation/widgets/admin_create_notification_sheet.dart';
import 'package:frontendmobile/features/communication/notifications/presentation/widgets/empty_state.dart';
import 'package:frontendmobile/features/communication/notifications/presentation/widgets/filter_bar.dart';
import 'package:frontendmobile/features/communication/notifications/presentation/widgets/notification_tile.dart';
import 'package:frontendmobile/features/communication/notifications/presentation/widgets/palette.dart';
import 'package:frontendmobile/features/hr/leave/presentation/providers/notifiers/leave_notifier.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () =>
          ref.read(notificationNotifierProvider.notifier).loadMyNotifications(),
    );
  }

  // ── Admin sheet ───────────────────────────────────────────────────────────
  void _openAdminSheet(bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? Pallets.surfaceDark : Pallets.surfaceLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const AdminCreateNotificationSheet(),
    );
  }

  // ── Navigate to detail ────────────────────────────────────────────────────
  Future<void> _openDetail(NotificationEntity notification) async {
    final currentState = ref.read(notificationNotifierProvider).valueOrNull;
    final latest =
        currentState?.notifications.firstWhereOrNull(
          (n) => n.notificationId == notification.notificationId,
        ) ??
        notification;
    final toOpen = latest.isRead ? latest : latest.copyWith(isRead: true);
    if (!latest.isRead) {
      ref
          .read(notificationNotifierProvider.notifier)
          .markOneRead(latest.notificationId);
    }
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NotificationDetailPage(notification: toOpen),
      ),
    );
  }

  // ── Approve leave from tile ───────────────────────────────────────────────
  Future<void> _approveLeave(NotificationEntity n) async {
    final refId = n.referenceId;
    if (refId == null) return;
    try {
      await ref.read(managerLeaveProvider.notifier).approveLeave(refId);
      if (!mounted) return;

      ref
          .read(notificationNotifierProvider.notifier)
          .updateReferenceStatus(
            notificationId: n.notificationId,
            referenceStatus: 'approved',
          );

      ref
          .read(notificationNotifierProvider.notifier)
          .markOneRead(n.notificationId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Leave approved'),
          backgroundColor: Pallets.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      ref
          .read(notificationNotifierProvider.notifier)
          .markOneRead(n.notificationId);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Pallets.error),
      );
    }
  }

  Future<void> _rejectLeave(NotificationEntity n) async {
    final refId = n.referenceId;
    if (refId == null) return;
    try {
      await ref
          .read(managerLeaveProvider.notifier)
          .rejectLeave(refId, reason: 'Rejected by Manager');
      if (!mounted) return;

      ref
          .read(notificationNotifierProvider.notifier)
          .updateReferenceStatus(
            notificationId: n.notificationId,
            referenceStatus: 'rejected',
          );
      ref
          .read(notificationNotifierProvider.notifier)
          .markOneRead(n.notificationId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Leave rejected'),
          backgroundColor: Pallets.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      ref
          .read(notificationNotifierProvider.notifier)
          .markOneRead(n.notificationId);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Pallets.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final p = PaletteScreen.of(isDark);
    final currentUser = ref.watch(currentUserProvider);
    final isAdmin =
        currentUser?.role == 'superuser' || currentUser?.role == 'admin';
    final isManager = currentUser?.role == 'manager' || isAdmin;

    final notifAsync = ref.watch(notificationNotifierProvider);
    final data = notifAsync.valueOrNull;
    final isSelecting = data?.isSelecting ?? false;
    final selectedIds = data?.selectedIds ?? {};
    final unread = data?.summary?.unread ?? 0;

    return Scaffold(
      backgroundColor: p.bg,

      // ── FAB (admin only) ─────────────────────────────────────────────
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              backgroundColor: Pallets.gradient2,
              onPressed: () => _openAdminSheet(isDark),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,

      appBar: AppBar(
        backgroundColor: p.card,
        elevation: 0,
        leading: isSelecting
            ? IconButton(
                icon: Icon(Icons.close, color: p.text),
                onPressed: () => ref
                    .read(notificationNotifierProvider.notifier)
                    .clearSelection(),
              )
            : GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: p.bg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: p.text,
                    size: 18,
                  ),
                ),
              ),
        title: isSelecting
            ? Text(
                '${selectedIds.length} selected',
                style: TextStyle(color: p.text, fontWeight: FontWeight.w600),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notifications',
                    style: TextStyle(
                      color: p.text,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  if (unread > 0)
                    Text(
                      '$unread unread',
                      style: TextStyle(color: p.subText, fontSize: 11),
                    ),
                ],
              ),
        actions: [
          if (isSelecting) ...[
            TextButton(
              onPressed: () =>
                  ref.read(notificationNotifierProvider.notifier).selectAll(),
              child: Text('All', style: TextStyle(color: p.accent)),
            ),
            IconButton(
              icon: Icon(Icons.done_all, color: p.text),
              tooltip: 'Mark selected read',
              onPressed: () => ref
                  .read(notificationNotifierProvider.notifier)
                  .bulkMarkRead(),
            ),
          ] else ...[
            if (unread > 0)
              IconButton(
                icon: Icon(Icons.done_all, color: p.text),
                tooltip: 'Mark all read',
                onPressed: () => ref
                    .read(notificationNotifierProvider.notifier)
                    .markAllRead(),
              ),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: p.text),
              color: p.card,
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
                PopupMenuItem(
                  value: 'select',
                  child: Row(
                    children: [
                      Icon(Icons.checklist, color: p.subText, size: 18),
                      const SizedBox(width: 8),
                      Text('Select', style: TextStyle(color: p.text)),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete_read',
                  child: Row(
                    children: [
                      Icon(Icons.delete_sweep, color: Pallets.error, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Delete all read',
                        style: TextStyle(color: Pallets.error),
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
          const FilterBar(),
          Expanded(
            child: notifAsync.when(
              loading: () =>
                  Center(child: CircularProgressIndicator(color: p.accent)),
              error: (e, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Pallets.error, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      e.toString(),
                      style: TextStyle(color: p.subText),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => ref
                          .read(notificationNotifierProvider.notifier)
                          .loadMyNotifications(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: p.accent,
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
                if (notifications.isEmpty) return const EmptyState();
                return RefreshIndicator(
                  color: p.accent,
                  backgroundColor: p.card,
                  onRefresh: () => ref
                      .read(notificationNotifierProvider.notifier)
                      .loadMyNotifications(),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: notifications.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: p.border),
                    itemBuilder: (context, index) {
                      final n = notifications[index];
                      final isSelected = data.selectedIds.contains(
                        n.notificationId,
                      );

                      final needsAction =
                          isManager &&
                          n.referenceType?.toLowerCase() == 'leave_request' &&
                          n.referenceId != null &&
                          n.referenceStatus?.toLowerCase() == 'pending';

                      return NotificationTile(
                        notification: n,
                        isSelecting: data.isSelecting,
                        isSelected: isSelected,
                        onTap: () {
                          if (data.isSelecting) {
                            if (n.notificationId != 0) {
                              ref
                                  .read(notificationNotifierProvider.notifier)
                                  .toggleSelect(n.notificationId);
                            }
                          } else {
                            _openDetail(n); // ✅ restored
                          }
                        },
                        onLongPress: () {
                          if (!data.isSelecting) {
                            ref
                                .read(notificationNotifierProvider.notifier)
                                .toggleSelectionMode();
                            if (n.notificationId != 0) {
                              ref
                                  .read(notificationNotifierProvider.notifier)
                                  .toggleSelect(n.notificationId);
                            }
                          }
                        },
                        onDismissed: () {
                          if (n.notificationId != 0) {
                            ref
                                .read(notificationNotifierProvider.notifier)
                                .deleteOne(n.notificationId);
                          }
                        },
                        // ── Action buttons (managers only) ─────────────
                        onConfirm: needsAction ? () => _approveLeave(n) : null,
                        onReject: needsAction ? () => _rejectLeave(n) : null,
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
