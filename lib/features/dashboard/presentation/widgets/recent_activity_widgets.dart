import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/communication/notifications/domain/entities/notification_entity.dart';
import 'package:frontendmobile/features/communication/notifications/presentation/providers/notification_provider.dart';

Widget buildRecentActivity(BuildContext context, WidgetRef ref) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final notificationState = ref.watch(notificationNotifierProvider);
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: isDark ? Pallets.surfaceCard : Pallets.surfaceLight,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(
        color: isDark ? Pallets.borderDark : Pallets.borderLight,
      ),
      boxShadow: isDark
          ? null
          : [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: TextStyle(
            color: isDark ? Pallets.textPrimaryDark : Pallets.textPrimaryLight,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 14),
        notificationState.when(
          data: (state) {
            final items = state.notifications.take(5).toList();

            if (items.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'No recent activity',
                  style: TextStyle(
                    color: isDark
                        ? Pallets.textSecondaryDark
                        : Pallets.textSecondaryLight,
                    fontSize: 13,
                  ),
                ),
              );
            }

            return Column(
              children: List.generate(items.length, (i) {
                final n = items[i];
                final isLast = i == items.length - 1;
                return Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _dotColor(n.type, n.isRead),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          n.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isDark
                                ? Pallets.textPrimaryDark
                                : Pallets.textPrimaryLight,
                            fontSize: 13,
                            fontWeight: n.isRead
                                ? FontWeight.normal
                                : FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _relativeTime(n.createdAt),
                        style: TextStyle(
                          color: isDark
                              ? Pallets.textSecondaryDark
                              : Pallets.textSecondaryLight,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
          error: (e, _) => Text(
            'Couldn\'t load activity',
            style: TextStyle(color: Pallets.error, fontSize: 13),
          ),
        ),
      ],
    ),
  );
}

////////////////////////////////////////////////////////////////////////////
///  Helpers
////////////////////////////////////////////////////////////////////////////

Color _dotColor(NotificationType type, bool isRead) {
  if (!isRead) {
    switch (type) {
      case NotificationType.success:
        return Pallets.success;
      case NotificationType.warning:
        return Pallets.warning;
      case NotificationType.error:
        return Pallets.error;
      case NotificationType.info:
        return Pallets.info;
    }
  }
  return Pallets.inactive;
}

String _relativeTime(DateTime time) {
  final diff = DateTime.now().difference(time);

  if (diff.inSeconds < 60) return 'Now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';
  return '${time.day}/${time.month}/${time.year}';
}
