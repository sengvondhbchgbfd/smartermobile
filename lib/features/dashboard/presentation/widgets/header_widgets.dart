import 'package:flutter/material.dart';
import '../../../../core/themes/app_pallets.dart';

class HeaderWidget extends StatelessWidget {
  final String companyName;
  final int unreadCount;
  final String? logoUrl;
  final VoidCallback? onCompanyTap;
  final VoidCallback? onNotificationTap;

  const HeaderWidget({
    super.key,
    required this.companyName,
    required this.unreadCount,
    this.logoUrl,
    this.onCompanyTap,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ── Company section (logo + name) ─────────────────────────────────

        GestureDetector(
          onTap: onCompanyTap,
          behavior: HitTestBehavior.opaque,
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: Pallets.brandGradient,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: logoUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          logoUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.dashboard_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      )
                    : const Icon(
                        Icons.dashboard_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    companyName,
                    style: const TextStyle(color: Pallets.textSecondaryLight),
                  ),
                  Text(
                    'Unread Messages: $unreadCount',
                    style: const TextStyle(
                      color: Pallets.textSecondaryLight,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const Spacer(),

        // ── Notification bell ─────────────────────────────────────────────
        GestureDetector(
          onTap: onNotificationTap,
          behavior: HitTestBehavior.opaque,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Pallets.surfaceDark,
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(color: Pallets.borderDark),
                ),
                child: const Icon(
                  Icons.notifications_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              if (unreadCount > 0)
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
                      '$unreadCount',
                      style: const TextStyle(color: Colors.white, fontSize: 8),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
