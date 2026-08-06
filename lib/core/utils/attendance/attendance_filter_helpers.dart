String fmtDate(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

String buildFilterLabel({
  String? filterDate,
  String? rangeStart,
  String? rangeEnd,
  int? filterStaffId,
}) {
  if (filterDate != null) return filterDate;
  if (rangeStart != null && rangeEnd != null) return '$rangeStart → $rangeEnd';
  if (filterStaffId != null) return 'Staff #$filterStaffId';
  return 'Filter by date';
}

bool hasActiveFilter({
  String? filterDate,
  String? rangeStart,
  int? filterStaffId,
}) => filterDate != null || rangeStart != null || filterStaffId != null;
