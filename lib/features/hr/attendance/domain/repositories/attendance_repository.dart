import 'package:dio/dio.dart';
import 'package:frontendmobile/features/hr/attendance/domain/entities/attendance_settings_entity.dart';
import '../entities/attendance_entity.dart';

abstract class AttendanceRepository {
  // ── Staff ──────────────────────────────────────────────────────────────────
  Future<List<AttendanceEntity>> getMyAttendance({int? month, int? year});

  Future<Map<String, dynamic>> getMonthlyStats({
    required int month,
    required int year,
  });

  // ── Scan Auth ──────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> scanAuthenticate({required String password});

  // ── Check In ───────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> checkIn({
    required String scanToken,
    required String officeQrToken,
    required String latitude,
    required String longitude,
    required String companyId,
  });

  // ── Check Out ──────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> checkOut({
    required String scanToken,
    required String officeQrToken,
    required String latitude,
    required String longitude,
    required String companyId,
  });

  // ── Office QR ──────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> getOfficeQr();

  Future<Response<dynamic>> downloadOfficeQrImage();

  // ── settings  ──────────────────────────────────────────────────────────────
  Future<AttendanceSettingsEntity> getAttendanceSettings();

  Future<AttendanceSettingsEntity> updateAttendanceSettings({
    double? officeLatitude,
    double? officeLongitude,
    int? allowedRadiusMeters,
    int? lateThresholdMinutes,
    int? overtimeThresholdMinutes,
    String? officeOpenTime,
    String? officeCloseTime,
    String? timezone,
  });

  // ── Manager ────────────────────────────────────────────────────────────────
  Future<List<AttendanceEntity>> getAllAttendance({
    String? filterDate,
    int? month, // ← add
    int? year, // ← add
    int? staffId, // ← add
  });

  Future<AttendanceEntity> getAttendanceById(int attendanceId);

  Future<Map<String, dynamic>> getTodaySummary();

  Future<List<AttendanceEntity>> getByDateRange({
    required String startDate,
    required String endDate,
    int? staffId,
  });
}
