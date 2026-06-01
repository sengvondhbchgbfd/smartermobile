import 'package:frontendmobile/features/hr/attendance/domain/entities/attendance_settings_entity.dart';

class AttendanceSettingsModel extends AttendanceSettingsEntity {
  const AttendanceSettingsModel({
    required super.settingId,
    required super.companyId,
    required super.officeLatitude,
    required super.officeLongitude,
    required super.allowedRadiusMeters,
    required super.officeOpenTime,
    required super.officeCloseTime,
    required super.timezone,
    required super.lateThresholdMinutes,
    required super.overtimeThresholdMinutes,
    super.updatedAt,
  });

  factory AttendanceSettingsModel.fromJson(Map<String, dynamic> json) {
    double _toDouble(dynamic v) {
      if (v == null) return 0;
      return (v is num) ? v.toDouble() : double.tryParse(v.toString()) ?? 0;
    }

    int _toInt(dynamic v, [int fallback = 0]) {
      if (v == null) return fallback;
      return (v is num) ? v.toInt() : int.tryParse(v.toString()) ?? fallback;
    }

    return AttendanceSettingsModel(
      settingId: _toInt(json['setting_id']),
      companyId: _toInt(json['company_id']),

      officeLatitude: _toDouble(json['office_latitude']),
      officeLongitude: _toDouble(json['office_longitude']),

      allowedRadiusMeters: _toInt(
        json['allowed_radius_meters'] ?? json['allowed_radius_metres'],
        100,
      ),

      officeOpenTime: json['office_open_time']?.toString() ?? '09:00:00',
      officeCloseTime: json['office_close_time']?.toString() ?? '17:00:00',
      timezone: json['timezone']?.toString() ?? 'UTC',

      lateThresholdMinutes: _toInt(json['late_threshold_minutes'], 15),
      overtimeThresholdMinutes: _toInt(json['overtime_threshold_minutes'], 480),

      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'setting_id': settingId,
      'company_id': companyId,
      'office_latitude': officeLatitude,
      'office_longitude': officeLongitude,
      'allowed_radius_meters': allowedRadiusMeters,
      'office_open_time': officeOpenTime,
      'office_close_time': officeCloseTime,
      'timezone': timezone,
      'late_threshold_minutes': lateThresholdMinutes,
      'overtime_threshold_minutes': overtimeThresholdMinutes,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  AttendanceSettingsModel copyWith({
    int? settingId,
    int? companyId,
    double? officeLatitude,
    double? officeLongitude,
    int? allowedRadiusMeters,
    String? officeOpenTime,
    String? officeCloseTime,
    String? timezone,
    int? lateThresholdMinutes,
    int? overtimeThresholdMinutes,
    DateTime? updatedAt,
  }) {
    return AttendanceSettingsModel(
      settingId: settingId ?? this.settingId,
      companyId: companyId ?? this.companyId,
      officeLatitude: officeLatitude ?? this.officeLatitude,
      officeLongitude: officeLongitude ?? this.officeLongitude,
      allowedRadiusMeters: allowedRadiusMeters ?? this.allowedRadiusMeters,
      officeOpenTime: officeOpenTime ?? this.officeOpenTime,
      officeCloseTime: officeCloseTime ?? this.officeCloseTime,
      timezone: timezone ?? this.timezone,
      lateThresholdMinutes: lateThresholdMinutes ?? this.lateThresholdMinutes,
      overtimeThresholdMinutes:
          overtimeThresholdMinutes ?? this.overtimeThresholdMinutes,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  AttendanceSettingsEntity toEntity() {
    return AttendanceSettingsEntity(
      settingId: settingId,
      companyId: companyId,
      officeLatitude: officeLatitude,
      officeLongitude: officeLongitude,
      allowedRadiusMeters: allowedRadiusMeters,
      officeOpenTime: officeOpenTime,
      officeCloseTime: officeCloseTime,
      timezone: timezone,
      lateThresholdMinutes: lateThresholdMinutes,
      overtimeThresholdMinutes: overtimeThresholdMinutes,
      updatedAt: updatedAt,
    );
  }
}
