import 'package:flutter/material.dart';

class NotificationTypeBadge extends StatelessWidget {
  final String type;

  const NotificationTypeBadge({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final config = _typeConfig(type);
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: config.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(config.icon, color: config.color, size: 20),
    );
  }

  _TypeConfig _typeConfig(String type) {
    switch (type.toLowerCase()) {
      case 'chat':
      case 'message':
        return _TypeConfig(Icons.chat_bubble_outline, const Color(0xFF6366F1));
      case 'alert':
      case 'warning':
        return _TypeConfig(
          Icons.warning_amber_rounded,
          const Color(0xFFF59E0B),
        );
      case 'success':
        return _TypeConfig(Icons.check_circle_outline, const Color(0xFF10B981));
      case 'error':
        return _TypeConfig(Icons.error_outline, const Color(0xFFEF4444));
      case 'info':
        return _TypeConfig(Icons.info_outline, const Color(0xFF3B82F6));
      case 'task':
        return _TypeConfig(Icons.task_alt, const Color(0xFF8B5CF6));
      case 'system':
        return _TypeConfig(Icons.settings_outlined, const Color(0xFF64748B));
      default:
        return _TypeConfig(
          Icons.notifications_outlined,
          const Color(0xFF6366F1),
        );
    }
  }
}

class _TypeConfig {
  final IconData icon;
  final Color color;
  const _TypeConfig(this.icon, this.color);
}
