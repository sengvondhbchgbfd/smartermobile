import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/communication/notifications/presentation/providers/notification_provider.dart';

class NotificationBell extends ConsumerWidget {
  final VoidCallback? onTap;
  const NotificationBell({super.key, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? Pallets.surfaceDark : Pallets.surfaceLight;
    final border = isDark ? Pallets.borderDark : Pallets.borderLight;
    final iconColor = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;

    final unread =
        ref.watch(notificationNotifierProvider).valueOrNull?.summary?.unread ??
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
              color: surface,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: border),
            ),
            child: Icon(
              Icons.notifications_rounded,
              color: iconColor,
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
                  color: Pallets.gradient2,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  unread > 99 ? '99+' : '$unread',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
