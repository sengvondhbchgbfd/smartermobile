import 'package:dio/dio.dart';
import 'package:frontendmobile/features/hr/attendance/domain/entities/attendance_settings_entity.dart';
import '../../domain/entities/attendance_entity.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasource/attendance_remote_datasource.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDataSource _remote;
  const AttendanceRepositoryImpl(this._remote);

  // ── Staff ──────────────────────────────────────────────────────────────────

  @override
  Future<List<AttendanceEntity>> getMyAttendance({
    int? month,
    int? year,
  }) async {
    final models = await _remote.getMyAttendance(month: month, year: year);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Map<String, dynamic>> getMonthlyStats({
    required int month,
    required int year,
  }) => _remote.getMonthlyStats(month: month, year: year);

  // ── Scan Auth ──────────────────────────────────────────────────────────────

  @override
  Future<Map<String, dynamic>> scanAuthenticate({required String password}) =>
      _remote.scanAuthenticate(password: password);

  // ── Check In ───────────────────────────────────────────────────────────────

  @override
  Future<Map<String, dynamic>> checkIn({
    required String scanToken,
    required String officeQrToken,
    required String latitude,
    required String longitude,
    required String companyId,
  }) => _remote.checkIn(
    scanToken: scanToken,
    officeQrToken: officeQrToken,
    latitude: latitude,
    longitude: longitude,
    companyId: companyId,
  );

  // ── Check Out ──────────────────────────────────────────────────────────────

  @override
  Future<Map<String, dynamic>> checkOut({
    required String scanToken,
    required String officeQrToken,
    required String latitude,
    required String longitude,
    required String companyId,
  }) => _remote.checkOut(
    scanToken: scanToken,
    officeQrToken: officeQrToken,
    latitude: latitude,
    longitude: longitude,
    companyId: companyId,
  );

  // ── Office QR ──────────────────────────────────────────────────────────────

  @override
  Future<Map<String, dynamic>> getOfficeQr() => _remote.getOfficeQr();

  @override
  Future<Response<dynamic>> downloadOfficeQrImage() =>
      _remote.downloadOfficeQrImage();

  // ── Settings ───────────────────────────────────────────────────────────────
  @override
  Future<AttendanceSettingsEntity> getAttendanceSettings() async {
    final model = await _remote.getAttendanceSettings();

    return model.toEntity();
  }

@override
Future<AttendanceSettingsEntity> updateAttendanceSettings({
  double? officeLatitude,
  double? officeLongitude,
  int? allowedRadiusMeters,
  int? lateThresholdMinutes,
  int? overtimeThresholdMinutes,
  String? officeOpenTime,
  String? officeCloseTime,
  String? timezone,
}) async {
  final model = await _remote.updateAttendanceSettings(
    officeLatitude: officeLatitude,
    officeLongitude: officeLongitude,
    allowedRadiusMeters: allowedRadiusMeters,
    lateThresholdMinutes: lateThresholdMinutes,
    overtimeThresholdMinutes: overtimeThresholdMinutes,
    officeOpenTime: officeOpenTime,
    officeCloseTime: officeCloseTime,
    timezone: timezone,
  );

  return model.toEntity();
}

  // ── Manager ────────────────────────────────────────────────────────────────

  @override
  Future<List<AttendanceEntity>> getAllAttendance({
    String? filterDate,
    int? month, // ← add
    int? year, // ← add
    int? staffId, // ← add
  }) async {
    final models = await _remote.getAllAttendance(
      filterDate: filterDate,
      month: month, // ← pass through
      year: year, // ← pass through
      staffId: staffId, // ← pass through
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<AttendanceEntity> getAttendanceById(int attendanceId) async {
    final model = await _remote.getAttendanceById(attendanceId);
    return model.toEntity();
  }

  @override
  Future<Map<String, dynamic>> getTodaySummary() => _remote.getTodaySummary();

  @override
  Future<List<AttendanceEntity>> getByDateRange({
    required String startDate,
    required String endDate,
    int? staffId,
  }) async {
    final models = await _remote.getByDateRange(
      startDate: startDate,
      endDate: endDate,
      staffId: staffId,
    );
    return models.map((m) => m.toEntity()).toList();
  }
}
