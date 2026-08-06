import 'package:flutter/material.dart';
import '../../domain/entities/leave_entity.dart';

class LeaveStatusBadge extends StatelessWidget {
  final LeaveStatus status;
  final bool compact;
  const LeaveStatusBadge({
    super.key,
    required this.status,
    this.compact = false,
  });

  _Cfg get _cfg {
    switch (status) {
      case LeaveStatus.pending:
        return _Cfg(
          label: 'Pending',
          color: const Color(0xFFF59E0B),
          icon: Icons.hourglass_top_rounded,
        );
      case LeaveStatus.approved:
        return _Cfg(
          label: 'Approved',
          color: const Color(0xFF22C55E),
          icon: Icons.check_circle_rounded,
        );
      case LeaveStatus.rejected:
        return _Cfg(
          label: 'Rejected',
          color: const Color(0xFFEF4444),
          icon: Icons.cancel_rounded,
        );
      case LeaveStatus.cancelled:
        return _Cfg(
          label: 'Cancelled',
          color: const Color(0xFF94A3B8),
          icon: Icons.block_rounded,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cfg = _cfg;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: cfg.color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(cfg.icon, color: cfg.color, size: compact ? 11 : 13),
          const SizedBox(width: 4),
          Text(
            cfg.label,
            style: TextStyle(
              color: cfg.color,
              fontWeight: FontWeight.w600,
              fontSize: compact ? 11 : 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _Cfg {
  final String label;
  final Color color;
  final IconData icon;
  const _Cfg({required this.label, required this.color, required this.icon});
}
