import 'package:dio/dio.dart';
import 'package:frontendmobile/core/constants/ApiEndpoints.dart';
import 'package:frontendmobile/features/hr/attendance/data/model/attendance_setting_model.dart';

import '../model/attendance_model.dart';
import 'attendance_remote_datasource.dart';

class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  final Dio _dio;
  AttendanceRemoteDataSourceImpl(this._dio);

  // ─────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────

  Map<String, dynamic> _params(Map<String, dynamic> raw) =>
      Map.fromEntries(raw.entries.where((e) => e.value != null));
  AttendanceModel _toModel(dynamic data) =>
      AttendanceModel.fromJson(data as Map<String, dynamic>);
  List<AttendanceModel> _toModelList(dynamic data) => (data as List<dynamic>)
      .map((e) => AttendanceModel.fromJson(e as Map<String, dynamic>))
      .toList();

  AttendanceSettingsModel _toSettingsModel(dynamic data) =>
      AttendanceSettingsModel.fromJson(data as Map<String, dynamic>);

  // ─────────────────────────────────────────────────────────────
  // STAFF
  // ─────────────────────────────────────────────────────────────

  /// GET /attendance/my
  @override
  Future<List<AttendanceModel>> getMyAttendance({int? month, int? year}) async {
    final res = await _dio.get<List<dynamic>>(
      ApiEndpoints.attendanceMy,
      queryParameters: _params({'month': month, 'year': year}),
    );
    return _toModelList(res.data);
  }

  /// GET /attendance/my/monthly-stats
  @override
  Future<Map<String, dynamic>> getMonthlyStats({
    required int month,
    required int year,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.attendanceMonthlyStats,
      queryParameters: {'month': month, 'year': year},
    );

    return res.data!;
  }

  // ─────────────────────────────────────────────────────────────
  // SCAN AUTH
  // ─────────────────────────────────────────────────────────────

  /// POST /attendance/scan/authenticate
  @override
  Future<Map<String, dynamic>> scanAuthenticate({
    required String password,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.attendanceScanAuth,
      data: {'password': password},
    );
    return res.data!;
  }

  // ─────────────────────────────────────────────────────────────
  // CHECK IN
  // ─────────────────────────────────────────────────────────────

  /// POST /attendance/scan/check-in
  @override
  Future<Map<String, dynamic>> checkIn({
    required String scanToken,
    required String officeQrToken,
    required String latitude,
    required String longitude,
    required String companyId,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.attendanceScanCheckIn,
      data: {
        'scan_token': scanToken,
        'office_qr_token': officeQrToken,
        'latitude': latitude,
        'longitude': longitude,
        'company_id': companyId,
      },
    );

    return res.data!;
  }

  // ─────────────────────────────────────────────────────────────
  // CHECK OUT
  // ─────────────────────────────────────────────────────────────

  /// POST /attendance/scan/check-out
  @override
  Future<Map<String, dynamic>> checkOut({
    required String scanToken,
    required String officeQrToken,
    required String latitude,
    required String longitude,
    required String companyId,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.attendanceScanCheckOut,
      data: {
        'scan_token': scanToken,
        'office_qr_token': officeQrToken,
        'latitude': latitude,
        'longitude': longitude,
        'company_id': companyId,
      },
    );
    return res.data!;
  }

  // ─────────────────────────────────────────────────────────────
  // OFFICE QR
  // ─────────────────────────────────────────────────────────────

  /// GET /attendance/office-qr
  @override
  Future<Map<String, dynamic>> getOfficeQr() async {
    final res = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.attendanceOfficeQr,
    );
    return res.data!;
  }

  /// GET /attendance/office-qr/image
  @override
  Future<Response<dynamic>> downloadOfficeQrImage() async {
    return await _dio.get(
      '${ApiEndpoints.attendanceOfficeQr}/image',
      options: Options(responseType: ResponseType.bytes),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // ATTENDANCE SETTINGS
  // ─────────────────────────────────────────────────────────────
  // GET

  @override
  Future<AttendanceSettingsModel> getAttendanceSettings() async {
    final res = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.attendanceSettings,
    );
    return _toSettingsModel(res.data);
  }

  // PATCH  ATTENDANCE

  @override
  Future<AttendanceSettingsModel> updateAttendanceSettings({
    double? officeLatitude,
    double? officeLongitude,
    int? allowedRadiusMeters,
    int? lateThresholdMinutes,
    int? overtimeThresholdMinutes,
    String? officeOpenTime,
    String? officeCloseTime,
    String? timezone,
  }) async {
    final res = await _dio.patch<Map<String, dynamic>>(
      ApiEndpoints.attendanceSettingCreate,
      data: _params({
        'office_latitude': officeLatitude,
        'office_longitude': officeLongitude,
        'allowed_radius_meters': allowedRadiusMeters,
        'late_threshold_minutes': lateThresholdMinutes,
        'overtime_threshold_minutes': overtimeThresholdMinutes,
        'office_open_time': officeOpenTime,
        'office_close_time': officeCloseTime,
        'timezone': timezone,
      }),
    );
    return _toSettingsModel(res.data);
  }
  // ─────────────────────────────────────────────────────────────
  // MANAGER
  // ─────────────────────────────────────────────────────────────

  @override
  Future<List<AttendanceModel>> getAllAttendance({
    String? filterDate,
    int? month, // ← add
    int? year, // ← add
    int? staffId, // ← add
  }) async {
    final res = await _dio.get<List<dynamic>>(
      ApiEndpoints.attendance,
      queryParameters: _params({
        'filter_date': filterDate,
        'month': month, // ← add
        'year': year, // ← add
        'staff_id': staffId, // ← add
      }),
    );
    return _toModelList(res.data);
  }

  /// GET /attendance/{id}
  @override
  Future<AttendanceModel> getAttendanceById(int attendanceId) async {
    final res = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.attendanceById(attendanceId),
    );

    return _toModel(res.data);
  }

  /// GET /attendance/summary/today

  @override
  Future<Map<String, dynamic>> getTodaySummary() async {
    final res = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.attendanceSummaryToday,
    );
    return res.data!;
  }

  /// GET /attendance/date-range
  @override
  Future<List<AttendanceModel>> getByDateRange({
    required String startDate,
    required String endDate,
    int? staffId,
  }) async {
    final res = await _dio.get<List<dynamic>>(
      ApiEndpoints.attendanceDateRange,
      queryParameters: _params({
        'start_date': startDate,
        'end_date': endDate,
        'staff_id': staffId,
      }),
    );

    return _toModelList(res.data);
  }
}
