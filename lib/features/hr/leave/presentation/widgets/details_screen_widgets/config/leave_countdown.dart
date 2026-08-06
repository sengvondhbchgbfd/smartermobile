import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

// ─────────────────────────────────────────────────────────────────────────────
// LeaveCountdown
//
// Self-contained countdown + progress widget. No LeaveEntity dependency —
// just pass start/end DateTimes so it can be dropped anywhere.
//
// Usage:
//   LeaveCountdown(
//     start: leave.startDate,
//     end:   leave.endDate,
//     accent: p.accent,
//     card:   p.card,
//     border: p.border,
//     textPrimary:   p.textPrimary,
//     textSecondary: p.textSecondary,
//   )
// ─────────────────────────────────────────────────────────────────────────────
class LeaveCountdown extends StatefulWidget {
  final DateTime? start;
  final DateTime? end;
  final Color accent;
  final Color card;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;

  const LeaveCountdown({
    super.key,
    required this.start,
    required this.end,
    required this.accent,
    required this.card,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  State<LeaveCountdown> createState() => _LeaveCountdownState();
}

class _LeaveCountdownState extends State<LeaveCountdown> {
  late Timer _timer;
  Duration _remaining = Duration.zero;
  double _progress = 0;

  // ── Status ────────────────────────────────────────────────────────────────
  _CDStatus get _status {
    final now = DateTime.now();
    final s = widget.start;
    final e = widget.end;
    if (s == null || e == null) return _CDStatus.unknown;
    if (now.isBefore(s)) return _CDStatus.upcoming;
    if (now.isAfter(e)) return _CDStatus.ended;
    if (_remaining.inHours < 24) return _CDStatus.endingSoon;
    return _CDStatus.active;
  }

  @override
  void initState() {
    super.initState();
    _recalc();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(_recalc);
    });
  }

  void _recalc() {
    final now = DateTime.now();
    final s = widget.start;
    final e = widget.end;
    if (s == null || e == null) return;

    final total = e.difference(s).inSeconds;
    final elapsed = now.difference(s).inSeconds.clamp(0, total);
    _progress = total > 0 ? elapsed / total : 0;
    _remaining = e.isAfter(now) ? e.difference(now) : Duration.zero;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // ── Countdown segments ────────────────────────────────────────────────────
  int get _days => _remaining.inDays;
  int get _hours => _remaining.inHours % 24;
  int get _mins => _remaining.inMinutes % 60;
  int get _secs => _remaining.inSeconds % 60;

  // ── Badge config ──────────────────────────────────────────────────────────
  ({String label, Color bg, Color fg, IconData icon, bool pulse}) get _badge {
    return switch (_status) {
      _CDStatus.active => (
        label: 'Active',
        bg: Pallets.successTint,
        fg: Pallets.success,
        icon: Icons.check_circle_outline_rounded,
        pulse: true,
      ),
      _CDStatus.endingSoon => (
        label: 'Ending soon',
        bg: Pallets.warningTint,
        fg: Pallets.warning,
        icon: Icons.hourglass_bottom_rounded,
        pulse: false,
      ),
      _CDStatus.ended => (
        label: 'Leave ended',
        bg: Pallets.errorTint,
        fg: Pallets.error,
        icon: Icons.cancel_outlined,
        pulse: false,
      ),
      _CDStatus.upcoming => (
        label: 'Upcoming',
        bg: Pallets.infoTint,
        fg: Pallets.info,
        icon: Icons.schedule_rounded,
        pulse: false,
      ),
      _CDStatus.unknown => (
        label: 'Unknown',
        bg: Pallets.borderDark,
        fg: Pallets.textMuted,
        icon: Icons.help_outline_rounded,
        pulse: false,
      ),
    };
  }

  Color get _barColor =>
      _status == _CDStatus.endingSoon ? Pallets.warning : widget.accent;

  @override
  Widget build(BuildContext context) {
    final b = _badge;
    final pct = (_progress * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Status badge ─────────────────────────────────────────────────
        _CDStatusBadge(
          label: b.label,
          bg: b.bg,
          fg: b.fg,
          icon: b.icon,
          pulse: b.pulse,
        ),
        const SizedBox(height: 12),

        // ── Progress bar ──────────────────────────────────────────────────
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: _progress.clamp(0.0, 1.0),
            minHeight: 5,
            backgroundColor: widget.border,
            valueColor: AlwaysStoppedAnimation<Color>(_barColor),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$pct% elapsed',
              style: TextStyle(color: widget.textSecondary, fontSize: 10),
            ),
            Text(switch (_status) {
              _CDStatus.ended => 'Ended',
              _CDStatus.upcoming => 'Not started',
              _CDStatus.unknown => '—',
              _ => '${_days}d ${_hours}h left',
            }, style: TextStyle(color: widget.textSecondary, fontSize: 10)),
          ],
        ),
        const SizedBox(height: 14),

        // ── Divider ───────────────────────────────────────────────────────
        Divider(color: widget.border, height: 1),
        const SizedBox(height: 14),

        // ── Countdown boxes ───────────────────────────────────────────────
        if (_status == _CDStatus.active || _status == _CDStatus.endingSoon)
          Row(
            children: [
              _CDBox(
                value: _days,
                label: 'days',
                textPrimary: widget.textPrimary,
                textSecondary: widget.textSecondary,
                bg: widget.border.withValues(alpha: 0.4),
              ),
              const SizedBox(width: 8),
              _CDBox(
                value: _hours,
                label: 'hours',
                textPrimary: widget.textPrimary,
                textSecondary: widget.textSecondary,
                bg: widget.border.withValues(alpha: 0.4),
              ),
              const SizedBox(width: 8),
              _CDBox(
                value: _mins,
                label: 'mins',
                textPrimary: widget.textPrimary,
                textSecondary: widget.textSecondary,
                bg: widget.border.withValues(alpha: 0.4),
              ),
              const SizedBox(width: 8),
              _CDBox(
                value: _secs,
                label: 'secs',
                textPrimary: widget.accent, // ticking accent
                textSecondary: widget.textSecondary,
                bg: widget.accent.withValues(alpha: 0.08),
              ),
            ],
          )
        else
          Center(
            child: Text(
              _status == _CDStatus.ended
                  ? 'This leave has ended'
                  : _status == _CDStatus.upcoming
                  ? 'Starts ${widget.start != null ? _fmtDate(widget.start!) : "—"}'
                  : '—',
              style: TextStyle(color: widget.textSecondary, fontSize: 12),
            ),
          ),
      ],
    );
  }

  String _fmtDate(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

  static const _months = [
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
  ];
}

// ─────────────────────────────────────────────────────────────────────────────
// _CDStatusBadge — animated pulsing dot for active state
// ─────────────────────────────────────────────────────────────────────────────
class _CDStatusBadge extends StatefulWidget {
  final String label;
  final Color bg, fg;
  final IconData icon;
  final bool pulse;

  const _CDStatusBadge({
    required this.label,
    required this.bg,
    required this.fg,
    required this.icon,
    required this.pulse,
  });

  @override
  State<_CDStatusBadge> createState() => _CDStatusBadgeState();
}

class _CDStatusBadgeState extends State<_CDStatusBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = Tween<double>(
      begin: 1.0,
      end: 0.3,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: widget.bg,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.pulse)
            FadeTransition(
              opacity: _anim,
              child: Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(right: 6),
                decoration: BoxDecoration(
                  color: widget.fg,
                  shape: BoxShape.circle,
                ),
              ),
            )
          else ...[
            Icon(widget.icon, color: widget.fg, size: 13),
            const SizedBox(width: 4),
          ],
          Text(
            widget.label,
            style: TextStyle(
              color: widget.fg,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _CDBox — single countdown unit cell
// ─────────────────────────────────────────────────────────────────────────────
class _CDBox extends StatelessWidget {
  final int value;
  final String label;
  final Color textPrimary, textSecondary, bg;

  const _CDBox({
    required this.value,
    required this.label,
    required this.textPrimary,
    required this.textSecondary,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              value.toString().padLeft(2, '0'),
              style: TextStyle(
                color: textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(color: textSecondary, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Internal status enum
// ─────────────────────────────────────────────────────────────────────────────
enum _CDStatus { upcoming, active, endingSoon, ended, unknown }
