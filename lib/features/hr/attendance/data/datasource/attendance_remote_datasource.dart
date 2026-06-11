import 'package:frontendmobile/features/hr/attendance/data/model/attendance_setting_model.dart';

import '../model/attendance_model.dart';
import 'package:dio/dio.dart';

abstract class AttendanceRemoteDataSource {
  // ── Staff ──────────────────────────────────────────────────────────────────
  Future<List<AttendanceModel>> getMyAttendance({int? month, int? year});

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

  // ── Attendance Settings ────────────────────────────────────────────────────

  Future<AttendanceSettingsModel> getAttendanceSettings();
  Future<AttendanceSettingsModel> updateAttendanceSettings({
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
  Future<List<AttendanceModel>> getAllAttendance({
  String? filterDate,
  int? month,    // ← add
  int? year,     // ← add
  int? staffId,  // ← add
});

  Future<AttendanceModel> getAttendanceById(int attendanceId);

  Future<Map<String, dynamic>> getTodaySummary();

  Future<List<AttendanceModel>> getByDateRange({
    required String startDate,
    required String endDate,
    int? staffId,
  });
}
