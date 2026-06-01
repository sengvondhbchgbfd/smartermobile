import '../../domain/entities/attendance_entity.dart';

class AttendanceModel {
  final int attendanceId;
  final int companyId;
  final int staffId;
  final String date;
  final String? checkInTime;
  final String? checkOutTime;
  final String? latitude;
  final String? longitude;
  final String createdAt;

  // nested staff
  final String? staffName;
  final String? staffAvatarUrl;
  final String? staffEmail;
  final String? staffPhone;

  const AttendanceModel({
    required this.attendanceId,
    required this.companyId,
    required this.staffId,
    required this.date,
    this.checkInTime,
    this.checkOutTime,
    this.latitude,
    this.longitude,
    required this.createdAt,
    this.staffName,
    this.staffAvatarUrl,
    this.staffEmail,
    this.staffPhone,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    final staff = json['staff'] as Map<String, dynamic>?;

    return AttendanceModel(
      attendanceId: json['attendance_id'] ?? 0,
      companyId: json['company_id'] ?? 0,
      staffId: json['staff_id'] ?? 0,
      date: json['date'] ?? '',
      checkInTime: json['check_in_time'],
      checkOutTime: json['check_out_time'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      createdAt: json['created_at'] ?? '',

      // nested staff data
      staffName: staff?['name'],
      staffAvatarUrl: staff?['avatar_url'],
      staffEmail: staff?['email'],
      staffPhone: staff?['phone'],
    );
  }

  AttendanceEntity toEntity() {
    return AttendanceEntity(
      attendanceId: attendanceId,
      companyId: companyId,
      staffId: staffId,
      date: DateTime.parse(date),
      checkInTime: checkInTime,
      checkOutTime: checkOutTime,
      latitude: latitude,
      longitude: longitude,
      createdAt: DateTime.parse(createdAt),
      staffName: staffName,
      staffAvatarUrl: staffAvatarUrl,
      staffPhone: staffPhone,
      staffEmail: staffEmail,
    );
  }
}
