import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/communication/notifications/presentation/providers/notification_provider.dart';

class NotificationBell extends ConsumerWidget {
  final VoidCallback? onTap;

  const NotificationBell({super.key, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = ref
            .watch(notificationNotifierProvider)
            .valueOrNull
            ?.summary
            ?.unread ??
        0;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: const Icon(
              Icons.notifications_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          if (unread > 0)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  unread > 99 ? '99+' : '$unread',
                  style: const TextStyle(color: Colors.white, fontSize: 8),
                ),
              ),
            ),
        ],
      ),
    );
  }
}