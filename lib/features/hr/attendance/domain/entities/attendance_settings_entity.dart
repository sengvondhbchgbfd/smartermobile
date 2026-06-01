class AttendanceSettingsEntity {
  final int settingId;
  final int companyId;

  // Geofence
  final double officeLatitude;
  final double officeLongitude;
  final int allowedRadiusMeters;

  // Schedule
  final String officeOpenTime;
  final String officeCloseTime;
  final String timezone;

  // Policy
  final int lateThresholdMinutes;
  final int overtimeThresholdMinutes;

  final DateTime? updatedAt;

  const AttendanceSettingsEntity({
    required this.settingId,
    required this.companyId,
    required this.officeLatitude,
    required this.officeLongitude,
    required this.allowedRadiusMeters,
    required this.officeOpenTime,
    required this.officeCloseTime,
    required this.timezone,
    required this.lateThresholdMinutes,
    required this.overtimeThresholdMinutes,
    this.updatedAt,
  });
}