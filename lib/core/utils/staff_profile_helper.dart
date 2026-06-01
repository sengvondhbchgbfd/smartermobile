import 'package:frontendmobile/features/hr/attendance/domain/entities/attendance_entity.dart';
import 'package:frontendmobile/features/hr/attendance/domain/entities/attendance_settings_entity.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/widgets/staff_profile_sheet.dart';
import 'package:frontendmobile/features/hr/leave/domain/entities/leave_entity.dart';

const int kTotalLeaveDaysPerYear = 18;

StaffProfile buildStaffProfile({
  required AttendanceEntity record,
  required List<AttendanceEntity> allRecords,
  required AttendanceSettingsEntity? settings,
  required List<LeaveEntity> leaves,
}) {
  final staffRecords = allRecords
      .where((r) => r.staffId == record.staffId)
      .toList();
  final openTime = settings?.officeOpenTime ?? '09:00:00';
  final lateThreshold = settings?.lateThresholdMinutes ?? 15;
  final openParts = openTime.split(':');
  final openMinutes = int.parse(openParts[0]) * 60 + int.parse(openParts[1]);

  // ── Leave balance calculation ──────────────────────────────────────────────
  final staffLeaves = leaves.where(
    (l) => l.staffId == record.staffId && l.status == LeaveStatus.approved,
  );

  final usedDays = staffLeaves.fold<int>(0, (sum, l) {
    return sum + l.endDate.difference(l.startDate).inDays + 1;
  });

  final remaining = (kTotalLeaveDaysPerYear - usedDays).clamp(
    0,
    kTotalLeaveDaysPerYear,
  );

  return StaffProfile(
    id: record.staffId,
    name: record.displayName,
    photoUrl: record.staffAvatarUrl,
    phone: record.staffPhone,
    email: record.staffEmail,
    presentDays: staffRecords.where((r) => r.isCheckedIn).length,
    absentDays: staffRecords.where((r) => !r.isCheckedIn).length,
    lateDays: staffRecords.where((r) {
      if (r.checkInTime == null) return false;
      final parts = r.checkInTime!.split(':');
      if (parts.length < 2) return false;
      final checkInMinutes = int.parse(parts[0]) * 60 + int.parse(parts[1]);
      return checkInMinutes > openMinutes + lateThreshold;
    }).length,
    leaveBalance: remaining,
    totalLeaveDays: kTotalLeaveDaysPerYear,
  );
}
