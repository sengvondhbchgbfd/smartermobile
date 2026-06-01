import 'package:equatable/equatable.dart';

class AttendanceEntity extends Equatable {
  final int attendanceId;
  final int companyId;
  final int staffId;
  final DateTime date;
  final String? checkInTime;
  final String? checkOutTime;
  final String? latitude;
  final String? longitude;
  final DateTime createdAt;
  final String? staffName;
  final String? staffAvatarUrl;
  final String? staffPhone; 
  final String? staffEmail;

  const AttendanceEntity({
    required this.attendanceId,
    required this.companyId,
    required this.staffId,
    required this.date,
    this.staffPhone,
    this.staffEmail,
    this.checkInTime,
    this.checkOutTime,
    this.latitude,
    this.longitude,
    required this.createdAt,
    this.staffName,
    this.staffAvatarUrl,
   
  });

  String get displayName => staffName ?? 'Staff #$staffId';

  bool get isCheckedIn => checkInTime != null;
  bool get isCheckedOut => checkOutTime != null;

  @override
  List<Object?> get props => [
    attendanceId,
    companyId,
    staffId,
    date,
    checkInTime,
    checkOutTime,
    latitude,
    longitude,
    createdAt,
    staffName,
    staffAvatarUrl,
    staffPhone,
    staffEmail,
  ];
}
