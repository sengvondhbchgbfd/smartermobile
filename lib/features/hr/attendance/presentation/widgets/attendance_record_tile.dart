import 'package:flutter/material.dart';
import 'package:frontendmobile/features/hr/attendance/domain/entities/attendance_entity.dart';
import 'package:frontendmobile/core/utils/date_formatter.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

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
        color: Pallets.success,
        icon: Icons.check_circle_outline,
      );
    }
    if (record.isCheckedIn) {
      return const _StatusStyle(
        label: 'In Office',
        color: Pallets.info,
        icon: Icons.login_rounded,
      );
    }
    return const _StatusStyle(
      label: 'Absent',
      color: Pallets.error,
      icon: Icons.cancel_outlined,
    );
  }

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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final dividerColor = isDark ? Pallets.dividerDark : Pallets.dividerLight;
    final weekendColor = isDark ? Pallets.textMuted : Colors.grey.shade400;

    final style = _status;
    final statusColor = style.color;

    final checkInDisplay = fmtKhmerTime(record.checkInTime);
    final checkOutDisplay = fmtKhmerTime(record.checkOutTime);
    final dur = calcDuration(record.checkInTime, record.checkOutTime);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? statusColor.withOpacity(0.05) : null,
          border: Border(bottom: BorderSide(color: dividerColor, width: 1)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Leading icon / avatar ──────────────────────────────────
            _buildLeading(statusColor, weekendColor, isDark),

            const SizedBox(width: 12),

            // ── Main content ───────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (record.staffName != null)
                    Text(
                      record.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                    ),

                  // ── Date + status words row ──────────────────────────
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
                                ? weekendColor
                                : record.staffName != null
                                ? textSecondary
                                : textPrimary,
                          ),
                        ),
                      ),
                      if (_isToday) ...[
                        const SizedBox(width: 6),
                        Text(
                          'Today',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: Pallets.warning,
                          ),
                        ),
                      ],
                      if (_isWeekend) ...[
                        const SizedBox(width: 6),
                        Text(
                          'Off',
                          style: TextStyle(fontSize: 10.5, color: weekendColor),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 5),

                  // ── Times + duration row ─────────────────────────────
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _TimeText(
                        icon: Icons.login_rounded,
                        time: checkInDisplay,
                        color: Pallets.success,
                        mutedColor: textSecondary,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Icon(
                          Icons.arrow_forward,
                          size: 10,
                          color: textSecondary,
                        ),
                      ),
                      _TimeText(
                        icon: Icons.logout_rounded,
                        time: checkOutDisplay,
                        color: Pallets.error,
                        mutedColor: textSecondary,
                      ),
                      if (dur != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          dur,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w500,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // ── Status word + chevron ────────────────────────────────────
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!_isWeekend)
                  Text(
                    style.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                if (onTap != null) ...[
                  const SizedBox(height: 4),
                  Icon(Icons.chevron_right, size: 16, color: textSecondary),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeading(Color statusColor, Color weekendColor, bool isDark) {
    final url = record.staffAvatarUrl;

    if (url != null && url.isNotEmpty) {
      return CircleAvatar(radius: 18, backgroundImage: NetworkImage(url));
    }

    if (record.staffName != null) {
      return CircleAvatar(
        radius: 18,
        backgroundColor: _isWeekend
            ? weekendColor.withOpacity(0.12)
            : statusColor.withOpacity(0.12),
        child: Text(
          record.displayName.isNotEmpty
              ? record.displayName[0].toUpperCase()
              : '?',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: _isWeekend ? weekendColor : statusColor,
          ),
        ),
      );
    }

    return CircleAvatar(
      radius: 18,
      backgroundColor: _isWeekend
          ? weekendColor.withOpacity(0.1)
          : statusColor.withOpacity(0.1),
      child: Icon(
        _isWeekend ? Icons.weekend_outlined : _status.icon,
        size: 17,
        color: _isWeekend ? weekendColor : statusColor,
      ),
    );
  }
}

class _TimeText extends StatelessWidget {
  final IconData icon;
  final String time;
  final Color color;
  final Color mutedColor;

  const _TimeText({
    required this.icon,
    required this.time,
    required this.color,
    required this.mutedColor,
  });

  @override
  Widget build(BuildContext context) {
    final missing = time == '--:--';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: missing ? mutedColor : color),
        const SizedBox(width: 3),
        Text(
          time,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: missing ? mutedColor : color,
          ),
        ),
      ],
    );
  }
}

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
