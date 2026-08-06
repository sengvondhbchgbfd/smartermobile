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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final surfaceColor = isDark ? Pallets.surfaceCard : Pallets.surfaceLight;
    final borderColor = isDark ? Pallets.borderDark : Pallets.borderLight;
    final iconColor = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;

    return Row(
      children: [
        ////////////////////////////////////////////////////////////////////////
        // ── Company section (logo + name) ────────────────────────────────
        ////////////////////////////////////////////////////////////////////////
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
                            color: Pallets.onAccent,
                            size: 24,
                          ),
                        ),
                      )
                    : const Icon(
                        Icons.dashboard_rounded,
                        color: Pallets.onAccent,
                        size: 24,
                      ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    companyName,
                    style: TextStyle(
                      color: textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Unread Messages: $unreadCount',
                    style: TextStyle(color: textSecondary, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),

        const Spacer(),
        ////////////////////////////////////////////////////////////////////////
        // ── Notification bell ────────────────────────────────────────────
        ////////////////////////////////////////////////////////////////////////
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
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(color: borderColor),
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
                child: Icon(
                  Icons.notifications_rounded,
                  color: iconColor,
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
                      color: Pallets.error,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$unreadCount',
                      style: const TextStyle(
                        color: Pallets.onError,
                        fontSize: 8,
                      ),
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
