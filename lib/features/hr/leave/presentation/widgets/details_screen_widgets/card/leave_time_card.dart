import 'package:flutter/material.dart';
import 'package:frontendmobile/features/hr/leave/domain/entities/leave_entity.dart';
import 'package:frontendmobile/features/hr/leave/presentation/widgets/details_screen_widgets/config/leave_countdown.dart';

// ─────────────────────────────────────────────────────────────────────────────
// TimelineCard — date row + delegates countdown to LeaveCountdown
// ─────────────────────────────────────────────────────────────────────────────
class TimelineCard extends StatelessWidget {
  final LeaveEntity leave;
  final Color card, border, textPrimary, textSecondary, accent;
  final String Function(DateTime?) fmtDate;
  final int days;

  const TimelineCard({
    super.key,
    required this.leave,
    required this.card,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.accent,
    required this.fmtDate,
    required this.days,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Date row ───────────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: _DateColumn(
                  label: 'Start Date',
                  date: fmtDate(leave.startDate),
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  accent: accent,
                  icon: Icons.flight_takeoff_rounded,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: textSecondary,
                      size: 18,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$days d',
                      style: TextStyle(
                        color: accent,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _DateColumn(
                  label: 'End Date',
                  date: fmtDate(leave.endDate),
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  accent: accent,
                  icon: Icons.flight_land_rounded,
                  alignEnd: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Countdown (reusable component) ─────────────────────────────
          LeaveCountdown(
            start: leave.startDate,
            end: leave.endDate,
            accent: accent,
            card: card,
            border: border,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _DateColumn — private, only used by TimelineCard
// ─────────────────────────────────────────────────────────────────────────────
class _DateColumn extends StatelessWidget {
  final String label, date;
  final Color textPrimary, textSecondary, accent;
  final IconData icon;
  final bool alignEnd;

  const _DateColumn({
    required this.label,
    required this.date,
    required this.textPrimary,
    required this.textSecondary,
    required this.accent,
    required this.icon,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: alignEnd
              ? [
                  Text(
                    label,
                    style: TextStyle(color: textSecondary, fontSize: 11),
                  ),
                  const SizedBox(width: 4),
                  Icon(icon, color: accent, size: 14),
                ]
              : [
                  Icon(icon, color: accent, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: TextStyle(color: textSecondary, fontSize: 11),
                  ),
                ],
        ),
        const SizedBox(height: 4),
        Text(
          date,
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
        ),
      ],
    );
  }
}
