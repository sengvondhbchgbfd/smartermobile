import 'package:flutter/material.dart';
import 'package:frontendmobile/features/hr/attendance/domain/entities/attendance_entity.dart';
import 'package:frontendmobile/core/utils/date_formatter.dart';

class AttendanceRecordTile extends StatelessWidget {
  final AttendanceEntity record;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool selected;
  final String? avatarUrl;
  const AttendanceRecordTile({
    super.key,
    required this.record,
    this.onTap,
    this.onLongPress,
    this.selected = false,
    this.avatarUrl,
  });

  // ── Status ─────────────────────────────────────────────────────────────────
  _StatusStyle get _status {
    if (record.isCheckedIn && record.isCheckedOut) {
      return const _StatusStyle(
        label: 'Present',
        color: Colors.green,
        icon: Icons.check_circle_outline,
      );
    }
    if (record.isCheckedIn) {
      return const _StatusStyle(
        label: 'In Office',
        color: Colors.blue,
        icon: Icons.login_rounded,
      );
    }
    return const _StatusStyle(
      label: 'Absent',
      color: Colors.red,
      icon: Icons.cancel_outlined,
    );
  }

  // ── Date helpers ───────────────────────────────────────────────────────────
  String get _formattedDate => DateFormatter.fmt(record.date);

  bool get _isWeekend {
    final w = record.date.weekday;
    return w == DateTime.saturday || w == DateTime.sunday;
  }

  bool get _isToday {
    final now = DateTime.now();
    final d = record.date;
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final style = _status;
    final statusColor = style.color;

    final checkInDisplay = fmtKhmerTime(record.checkInTime);
    final checkOutDisplay = fmtKhmerTime(record.checkOutTime);
    final dur = calcDuration(record.checkInTime, record.checkOutTime);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        decoration: BoxDecoration(
          color: selected
              ? statusColor.withOpacity(0.06)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? statusColor.withOpacity(0.5)
                : _isWeekend
                ? Colors.grey.shade200
                : statusColor.withOpacity(0.18),
            width: selected ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Leading icon / avatar ──────────────────────────────────
              _buildLeading(statusColor),

              const SizedBox(width: 10),

              // ── Main content ───────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Staff name (manager view only)
                    if (record.staffName != null)
                      Text(
                        record.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                    // ── Date + pills row ─────────────────────────────────
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            _formattedDate,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: record.staffName != null ? 11 : 13,
                              fontWeight: record.staffName != null
                                  ? FontWeight.normal
                                  : FontWeight.w600,
                              color: _isWeekend
                                  ? Colors.grey.shade400
                                  : record.staffName != null
                                  ? Colors.grey.shade600
                                  : null,
                            ),
                          ),
                        ),
                        if (_isToday) ...[
                          const SizedBox(width: 4),
                          _Pill(
                            label: 'Today',
                            bgColor: Colors.orange.shade50,
                            textColor: Colors.orange.shade700,
                          ),
                        ],
                        if (_isWeekend) ...[
                          const SizedBox(width: 4),
                          _Pill(
                            label: 'Off',
                            bgColor: Colors.grey.shade100,
                            textColor: Colors.grey.shade500,
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 4),

                    // ── Times + duration row ─────────────────────────────
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _TimeChip(
                          icon: Icons.login_rounded,
                          time:
                              checkInDisplay, // ← Khmer 12h format e.g. "9:00 AM"
                          color: Colors.green.shade600,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(
                            Icons.arrow_forward,
                            size: 10,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        _TimeChip(
                          icon: Icons.logout_rounded,
                          time:
                              checkOutDisplay, // ← Khmer 12h format e.g. "5:00 PM"
                          color: Colors.red.shade600,
                        ),
                        if (dur != null) ...[
                          const SizedBox(width: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              dur,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 6),

              // ── Status badge ───────────────────────────────────────────
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (!_isWeekend)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: statusColor.withOpacity(0.25),
                        ),
                      ),
                      child: Text(
                        style.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ),
                  if (onTap != null) ...[
                    const SizedBox(height: 4),
                    Icon(
                      Icons.chevron_right,
                      size: 14,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////
  /// Helper
  //////////////////////////////////////////////////////////////////////
  Widget _buildLeading(Color statusColor) {
    final url = record.staffAvatarUrl;

    if (url != null && url.isNotEmpty) {
      return CircleAvatar(radius: 18, backgroundImage: NetworkImage(url));
    }

    if (record.staffName != null) {
      return CircleAvatar(
        radius: 18,
        backgroundColor: _isWeekend
            ? Colors.grey.shade100
            : statusColor.withValues(alpha: 0.12),
        child: Text(
          record.displayName.isNotEmpty
              ? record.displayName[0].toUpperCase()
              : '?',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: _isWeekend ? Colors.grey : statusColor,
          ),
        ),
      );
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: _isWeekend
            ? Colors.grey.shade100
            : statusColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        _isWeekend ? Icons.weekend_outlined : _status.icon,
        size: 17,
        color: _isWeekend ? Colors.grey : statusColor,
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////
///
//////////////////////////////////////////////////////////////////////
class _TimeChip extends StatelessWidget {
  final IconData icon;
  final String time;
  final Color color;

  const _TimeChip({
    required this.icon,
    required this.time,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final missing = time == '--:--';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: missing ? Colors.grey.shade400 : color),
        const SizedBox(width: 2),
        Text(
          time,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: missing ? Colors.grey.shade400 : color,
          ),
        ),
      ],
    );
  }
}
///////////////////////////////////////////////////////////////////////
///
//////////////////////////////////////////////////////////////////////

class _Pill extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color textColor;

  const _Pill({
    required this.label,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label, style: TextStyle(fontSize: 9, color: textColor)),
    );
  }
}

//////////////////////////////////////////////////////////////////////
///
//////////////////////////////////////////////////////////////////////

class _StatusStyle {
  final String label;
  final Color color;
  final IconData icon;
  const _StatusStyle({
    required this.label,
    required this.color,
    required this.icon,
  });
}
