import 'package:flutter/material.dart';

class TypeConfig {
  const TypeConfig({
    required this.icon,
    required this.color,
    required this.label,
    required this.ctaLabel,
  });
  final IconData icon;
  final Color color;
  final String label;
  final String ctaLabel;
}

TypeConfig refConfigFor(String? referenceType) {
  switch (referenceType?.toLowerCase()) {
    case 'invoice':
      return const TypeConfig(
        icon: Icons.receipt_long_outlined,
        color: Color(0xFF4FC3F7),
        label: 'Invoice',
        ctaLabel: 'View invoice',
      );
    case 'quotation':
      return const TypeConfig(
        icon: Icons.request_quote_outlined,
        color: Color(0xFFFFB74D),
        label: 'Quotation',
        ctaLabel: 'View quotation',
      );
    case 'leave_request':
      return const TypeConfig(
        icon: Icons.calendar_month_outlined,
        color: Color(0xFF81C784),
        label: 'Leave request',
        ctaLabel: 'View leave request',
      );
    case 'salary':
      return const TypeConfig(
        icon: Icons.payments_outlined,
        color: Color(0xFFFFD54F),
        label: 'Salary',
        ctaLabel: 'View salary details',
      );
    case 'attendance':
      return const TypeConfig(
        icon: Icons.fingerprint,
        color: Color(0xFF80CBC4),
        label: 'Attendance',
        ctaLabel: 'View attendance',
      );
    default:
      // no referenceType — generic notification
      return const TypeConfig(
        icon: Icons.notifications_outlined,
        color: Color(0xFFB39DDB),
        label: 'Notification',
        ctaLabel: 'View details',
      );
  }
}
