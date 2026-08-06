import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Model
// ─────────────────────────────────────────────────────────────────────────────

class AttendanceStat {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const AttendanceStat({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  static List<AttendanceStat> fromMap(Map<String, dynamic> m) {
    return [
      AttendanceStat(
        label: 'Present',
        value: m['total_present']?.toString() ?? '0',
        color: Pallets.success,
        icon: Icons.check_circle_outline,
      ),
      AttendanceStat(
        label: 'Checked Out',
        value: m['checked_out']?.toString() ?? '0',
        color: Pallets.info,
        icon: Icons.logout_outlined,
      ),
      AttendanceStat(
        label: 'Still In',
        value: m['still_in']?.toString() ?? '0',
        color: Pallets.warning,
        icon: Icons.meeting_room_outlined,
      ),
      if (m['absent'] != null)
        AttendanceStat(
          label: 'Absent',
          value: m['absent'].toString(),
          color: Pallets.error,
          icon: Icons.cancel_outlined,
        ),
      if (m['late'] != null)
        AttendanceStat(
          label: 'Late',
          value: m['late'].toString(),
          color: Pallets.warning,
          icon: Icons.watch_later_outlined,
        ),
    ];
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Widget — flat, no card backgrounds. Just icon + number + label, separated
// by a thin vertical rule.
// ─────────────────────────────────────────────────────────────────────────────

class AttendanceStatsRow extends StatelessWidget {
  final dynamic stats;
  const AttendanceStatsRow({super.key, required this.stats});

  List<AttendanceStat> get _resolved {
    if (stats is List<AttendanceStat>) return stats as List<AttendanceStat>;
    if (stats is Map<String, dynamic>) {
      return AttendanceStat.fromMap(stats as Map<String, dynamic>);
    }
    if (stats is Map) {
      return AttendanceStat.fromMap(Map<String, dynamic>.from(stats as Map));
    }
    return const [];
  }

  @override
  Widget build(BuildContext context) {
    final items = _resolved;
    if (items.isEmpty) return const SizedBox.shrink();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ruleColor = isDark ? Pallets.dividerDark : Pallets.dividerLight;

    return Row(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          if (i > 0) Container(width: 1, height: 32, color: ruleColor),
          Expanded(child: _StatItem(stat: items[i])),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _StatItem extends StatelessWidget {
  final AttendanceStat stat;
  const _StatItem({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(stat.icon, size: 14, color: stat.color),
            const SizedBox(width: 4),
            Text(
              stat.value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: stat.color,
                height: 1.1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          stat.label,
          style: TextStyle(
            fontSize: 11,
            color: stat.color.withOpacity(0.85),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
