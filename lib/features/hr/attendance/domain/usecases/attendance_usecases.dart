import 'package:dio/dio.dart';
import 'package:frontendmobile/features/hr/attendance/domain/entities/attendance_settings_entity.dart';
import '../entities/attendance_entity.dart';
import '../repositories/attendance_repository.dart';

// ── Staff ─────────────────────────────────────────────────────────────────────

class GetMyAttendanceUseCase {
  final AttendanceRepository _repo;
  const GetMyAttendanceUseCase(this._repo);
  Future<List<AttendanceEntity>> call({int? month, int? year}) =>
      _repo.getMyAttendance(month: month, year: year);
}

class GetMonthlyStatsUseCase {
  final AttendanceRepository _repo;
  const GetMonthlyStatsUseCase(this._repo);
  Future<Map<String, dynamic>> call({required int month, required int year}) =>
      _repo.getMonthlyStats(month: month, year: year);
}

// ── Scan Auth ─────────────────────────────────────────────────────────────────

class ScanAuthenticateUseCase {
  final AttendanceRepository _repo;
  const ScanAuthenticateUseCase(this._repo);
  Future<Map<String, dynamic>> call({required String password}) =>
      _repo.scanAuthenticate(password: password);
}

// ── Check In ──────────────────────────────────────────────────────────────────

class CheckInUseCase {
  final AttendanceRepository _repo;
  const CheckInUseCase(this._repo);
  Future<Map<String, dynamic>> call({
    required String scanToken,
    required String officeQrToken,
    required String latitude,
    required String longitude,
    required String companyId,
  }) => _repo.checkIn(
    scanToken: scanToken,
    officeQrToken: officeQrToken,
    latitude: latitude,
    longitude: longitude,
    companyId: companyId,
  );
}

// ── Check Out ─────────────────────────────────────────────────────────────────

class CheckOutUseCase {
  final AttendanceRepository _repo;
  const CheckOutUseCase(this._repo);
  Future<Map<String, dynamic>> call({
    required String scanToken,
    required String officeQrToken,
    required String latitude,
    required String longitude,
    required String companyId,
  }) => _repo.checkOut(
    scanToken: scanToken,
    officeQrToken: officeQrToken,
    latitude: latitude,
    longitude: longitude,
    companyId: companyId,
  );
}

// ── Office QR ─────────────────────────────────────────────────────────────────

class GetOfficeQrUseCase {
  final AttendanceRepository _repo;
  const GetOfficeQrUseCase(this._repo);

  Future<Map<String, dynamic>> call() => _repo.getOfficeQr();
}

class DownloadOfficeQrImageUseCase {
  final AttendanceRepository _repo;
  const DownloadOfficeQrImageUseCase(this._repo);
  Future<Response<dynamic>> call() => _repo.downloadOfficeQrImage();
}

// ── Attendance Settings ───────────────────────────────────────────────────────

class GetAttendanceSettingsUseCase {
  final AttendanceRepository _repo;
  const GetAttendanceSettingsUseCase(this._repo);
  Future<AttendanceSettingsEntity> call() => _repo.getAttendanceSettings();
}

class UpdateAttendanceSettingUseCase {
  final AttendanceRepository _repo;
  const UpdateAttendanceSettingUseCase(this._repo);

  Future<AttendanceSettingsEntity> call({
    double? officeLatitude,
    double? officeLongitude,
    int? allowedRadiusMeters,
    int? lateThresholdMinutes,
    int? overtimeThresholdMinutes,
    String? officeOpenTime,
    String? officeCloseTime,
    String? timezone,
  }) => _repo.updateAttendanceSettings(
    officeLatitude: officeLatitude,
    officeLongitude: officeLongitude,
    allowedRadiusMeters: allowedRadiusMeters,
    lateThresholdMinutes: lateThresholdMinutes,
    overtimeThresholdMinutes: overtimeThresholdMinutes,
    officeOpenTime: officeOpenTime,
    officeCloseTime: officeCloseTime,
    timezone: timezone,
  );
}

// ── Manager ───────────────────────────────────────────────────────────────────

class GetAllAttendanceUseCase {
  final AttendanceRepository _repo;
  const GetAllAttendanceUseCase(this._repo);

  Future<List<AttendanceEntity>> call({
    String? filterDate,
    int? month,
    int? year,
    int? staffId,
  }) => _repo.getAllAttendance(
    filterDate: filterDate,
    month: month,
    year: year,
    staffId: staffId,
  );
}

class GetAttendanceByIdUseCase {
  final AttendanceRepository _repo;
  const GetAttendanceByIdUseCase(this._repo);
  Future<AttendanceEntity> call(int attendanceId) =>
      _repo.getAttendanceById(attendanceId);
}

class GetTodaySummaryUseCase {
  final AttendanceRepository _repo;
  const GetTodaySummaryUseCase(this._repo);
  Future<Map<String, dynamic>> call() => _repo.getTodaySummary();
}

class GetByDateRangeUseCase {
  final AttendanceRepository _repo;
  const GetByDateRangeUseCase(this._repo);
  Future<List<AttendanceEntity>> call({
    required String startDate,
    required String endDate,
    int? staffId,
  }) => _repo.getByDateRange(
    startDate: startDate,
    endDate: endDate,
    staffId: staffId,
  );
}
