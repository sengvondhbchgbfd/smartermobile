import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/leave_pallets.dart';
import 'package:frontendmobile/features/hr/leave/domain/entities/leave_entity.dart';
import 'package:frontendmobile/features/hr/leave/presentation/widgets/details_screen_widgets/config/leave_countdown.dart';
import 'package:frontendmobile/features/hr/leave/presentation/widgets/leave_status_badge.dart';

class LeaveCard extends StatelessWidget {
  final LeaveEntity leave;
  final int days;
  final Color card, border, textPrimary, textSecondary, accent;
  final String Function(DateTime) fmtDate;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool showCountdown;

  const LeaveCard({
    super.key,
    required this.leave,
    required this.days,
    required this.card,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.accent,
    required this.fmtDate,
    required this.onTap,
    this.trailing,
    this.showCountdown = false, // ← opt-in
  });

  Color get _typeColor => LeaveTypeColor.of(leave.leaveType);

  bool get _isOngoing {
    final now = DateTime.now();
    final s = leave.startDate;
    final e = leave.endDate;
    return s != null && e != null && now.isAfter(s) && now.isBefore(e);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top row ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: _typeColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text(
                    '${leave.leaveType.name[0].toUpperCase()}'
                    '${leave.leaveType.name.substring(1)} Leave',
                    style: TextStyle(
                      color: textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  LeaveStatusBadge(status: leave.status, compact: true),
                ],
              ),
            ),

            Divider(height: 1, color: border),

            // ── Date row + days ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 14,
                    color: textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${fmtDate(leave.startDate!)}  →  ${fmtDate(leave.endDate!)}',
                    style: TextStyle(color: textSecondary, fontSize: 13),
                  ),
                  const Spacer(),
                  Text(
                    '$days ${days == 1 ? 'day' : 'days'}',
                    style: TextStyle(
                      color: accent,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // ── Countdown (opt-in, active leaves only) ────────────────────
            if (showCountdown && _isOngoing) ...[
              Divider(height: 1, color: border),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: LeaveCountdown(
                  start: leave.startDate,
                  end: leave.endDate,
                  accent: accent,
                  card: card,
                  border: border,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                ),
              ),
            ],

            // ── Staff name (manager view) ──────────────────────────────────
            if (leave.staffName != null) ...[
              Divider(height: 1, color: border),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.person_outline_rounded,
                      size: 14,
                      color: textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      leave.displayName,
                      style: TextStyle(color: textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],

            // ── Trailing actions ───────────────────────────────────────────
            if (trailing != null) ...[
              Divider(height: 1, color: border),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [trailing!],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
