import 'package:flutter/material.dart';
import 'package:frontendmobile/features/communication/notifications/domain/entities/notification_entity.dart';

class StatusConfig {
  const StatusConfig({
    required this.icon,
    required this.color,
    required this.label,
  });
  final IconData icon;
  final Color color;
  final String label;
}

StatusConfig statusConfigFor(NotificationType type) {
  switch (type) {
    case NotificationType.info:
      return const StatusConfig(
        icon: Icons.info_outline,
        color: Color(0xFF4FC3F7),
        label: 'Info',
      );
    case NotificationType.success:
      return const StatusConfig(
        icon: Icons.check_circle_outline,
        color: Color(0xFF81C784),
        label: 'Success',
      );
    case NotificationType.warning:
      return const StatusConfig(
        icon: Icons.warning_amber_outlined,
        color: Color(0xFFFFD54F),
        label: 'Warning',
      );
    case NotificationType.error:
      return const StatusConfig(
        icon: Icons.error_outline,
        color: Color(0xFFEF5350),
        label: 'Error',
      );
  }
}
