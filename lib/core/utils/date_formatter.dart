class DateFormatter {
  DateFormatter._();
  static String fmt(DateTime d) =>
      '${weekday(d.weekday)}, ${d.day} ${month(d.month)} ${d.year}';

  static String fmtApi(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static String weekday(int w) =>
      ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][w - 1];

  static String month(int m) => [
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
  ][m - 1];
}

///////////////////////////////////////////////////////////////////////////////
/// Khmer format time
///////////////////////////////////////////////////////////////////////////////

String fmtKhmerTime(String? raw) {
  if (raw == null || raw.isEmpty) return '--:--';
  try {
    final parts = raw.split(':');
    if (parts.length < 2) return '--:--';

    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    final period = hour < 12 ? 'AM' : 'PM';
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    final minuteStr = minute.toString().padLeft(2, '0');

    return '$hour12:$minuteStr $period';
  } catch (_) {
    return '--:--';
  }
}

String fmtKhmerDateTime(DateTime? dt) {
  if (dt == null) return '--:--';
  return fmtKhmerTime(
    '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:00',
  );
}

String? calcDuration(String? checkIn, String? checkOut) {
  if (checkIn == null || checkOut == null) return null;
  try {
    final inParts = checkIn.split(':');
    final outParts = checkOut.split(':');
    final inMin = int.parse(inParts[0]) * 60 + int.parse(inParts[1]);
    final outMin = int.parse(outParts[0]) * 60 + int.parse(outParts[1]);
    final diff = outMin - inMin;
    if (diff <= 0) return null;
    final h = diff ~/ 60;
    final m = diff % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}m';
  } catch (_) {
    return null;
  }
}
