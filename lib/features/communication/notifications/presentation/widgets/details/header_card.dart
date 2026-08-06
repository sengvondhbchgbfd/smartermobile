import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/communication/notifications/domain/entities/notification_entity.dart';
import 'package:frontendmobile/features/communication/notifications/presentation/widgets/details/status_config.dart';
import 'package:frontendmobile/features/communication/notifications/presentation/widgets/details/type_config.dart';
import 'package:frontendmobile/features/communication/notifications/presentation/widgets/palette.dart';

class HeaderCard extends StatelessWidget {
  const HeaderCard({
    super.key,
    required this.notif,
    required this.cfg,
    required this.statusCfg,
  });
  final NotificationEntity notif;
  final TypeConfig cfg;
  final StatusConfig statusCfg;

  @override
  Widget build(BuildContext context) {
    /////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final p = Palette.of(isDark);

    ////////////////////////////////////////////////////////////
    ///
    /////////////////////////////////////////////////////////////

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: p.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: statusCfg.color.withOpacity(0.35),
          width: 0.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: cfg.color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(cfg.icon, color: cfg.color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!notif.isRead) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Pallets.gradient2.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'New',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: p.textPrimary,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
                Text(
                  notif.title,
                  style: TextStyle(
                    color: p.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // Business category badge (referenceType)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: cfg.color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        cfg.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: cfg.color,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    // Severity badge (NotificationType)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: statusCfg.color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            statusCfg.icon,
                            size: 10,
                            color: statusCfg.color,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            statusCfg.label,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: statusCfg.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
