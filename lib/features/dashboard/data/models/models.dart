import 'package:flutter/material.dart';

// ─── Dashboard Module ───────────────────────────────────────
class DashboardModule {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String? route; 

  const DashboardModule({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.route,
  });
}

// ─── Dashboard Stat ─────────────────────────────────────────
class DashboardStat {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const DashboardStat({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
}

// ─── User ───────────────────────────────────────────────────

// ─── Chat Message ────────────────────────────────────────────
class ChatMessage {
  final String name;
  final String message;
  final String time;

  const ChatMessage({
    required this.name,
    required this.message,
    required this.time,
  });
}

// ─── Activity Item ───────────────────────────────────────────
class ActivityItem {
  final String label;
  final String time;

  const ActivityItem({required this.label, required this.time});
}