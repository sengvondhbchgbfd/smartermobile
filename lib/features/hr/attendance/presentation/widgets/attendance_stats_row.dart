import 'package:flutter/material.dart';

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
        color: Colors.green.shade600,
        icon: Icons.check_circle_outline,
      ),
      AttendanceStat(
        label: 'Checked Out',
        value: m['checked_out']?.toString() ?? '0',
        color: Colors.blue.shade600,
        icon: Icons.logout_outlined,
      ),
      AttendanceStat(
        label: 'Still In',
        value: m['still_in']?.toString() ?? '0',
        color: Colors.orange.shade600,
        icon: Icons.meeting_room_outlined,
      ),

      if (m['absent'] != null)
        AttendanceStat(
          label: 'Absent',
          value: m['absent'].toString(),
          color: Colors.red.shade600,
          icon: Icons.cancel_outlined,
        ),
      if (m['late'] != null)
        AttendanceStat(
          label: 'Late',
          value: m['late'].toString(),
          color: Colors.orange.shade600,
          icon: Icons.watch_later_outlined,
        ),

        
    ];
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Widget
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

    return Container(
      height: 84,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) => _StatCard(stat: items[i]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final AttendanceStat stat;

  const _StatCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      decoration: BoxDecoration(
        color: stat.color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: stat.color.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(stat.icon, size: 13, color: stat.color),
              const SizedBox(width: 3),
              Text(
                stat.value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: stat.color,
                  height: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            stat.label,
            style: TextStyle(
              fontSize: 10,
              color: stat.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
