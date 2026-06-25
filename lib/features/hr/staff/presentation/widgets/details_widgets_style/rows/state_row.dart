import 'package:flutter/material.dart';
import 'package:frontendmobile/features/hr/staff/domain/entities/staff_entity.dart';

class StatsRow extends StatelessWidget {
  final StaffEntity staff;
  const StatsRow({super.key, required this.staff});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tile = isDark ? const Color(0xFF2C2C2E) : const Color(0xFFEDEDEB);
    final muted = isDark ? const Color(0xFF9A9A9C) : const Color(0xFF6B6B68);

    return Row(
      children: [
        Expanded(
          child: _StatTile(
            tile: tile,
            muted: muted,
            label: 'Base salary',
            value: staff.staffRole != null
                ? '\$${staff.staffRole!.baseSalary.toStringAsFixed(0)}'
                : 'N/A',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatTile(
            tile: tile,
            muted: muted,
            label: 'Joined',
            value: staff.createdAt != null
                ? '${_month(staff.createdAt!.month)} ${staff.createdAt!.year}'
                : 'N/A',
          ),
        ),
      ],
    );
  }

  String _month(int m) => const [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ][m];
}

class _StatTile extends StatelessWidget {
  final Color tile;
  final Color muted;
  final String label;
  final String value;
  const _StatTile({
    required this.tile,
    required this.muted,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tile,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: muted)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
