import 'package:dio/dio.dart';
import 'package:frontendmobile/features/hr/attendance/domain/entities/attendance_settings_entity.dart';
import '../../domain/entities/attendance_entity.dart';

// ─────────────────────────────────────────────────────────
// Sentinel for explicit null in copyWith
// ─────────────────────────────────────────────────────────
const _keep = Object();

/// ─────────────────────────────────────────────────────────
/// Staff State
/// ─────────────────────────────────────────────────────────

class StaffAttendanceState {
  final List<AttendanceEntity> records;
  final Map<String, dynamic> monthlyStats;
  final bool isLoading;
  final String? error;

  const StaffAttendanceState({
    this.records = const [],
    this.monthlyStats = const {},
    this.isLoading = false,
    this.error,
  });

  StaffAttendanceState copyWith({
    List<AttendanceEntity>? records,
    Map<String, dynamic>? monthlyStats,
    bool? isLoading,
    Object? error = _keep, // ✅ sentinel — null means "clear error"
  }) {
    return StaffAttendanceState(
      records: records ?? this.records,
      monthlyStats: monthlyStats ?? this.monthlyStats,
      isLoading: isLoading ?? this.isLoading,
      error: error == _keep ? this.error : error as String?,
    );
  }
}

/// ─────────────────────────────────────────────────────────
/// Scan State
/// ─────────────────────────────────────────────────────────

class ScanAttendanceState {
  final Map<String, dynamic>? scanResult;
  final Map<String, dynamic>? officeQr;
  final Response<dynamic>? officeQrImage;
  final bool isLoading;
  final String? error;
  final Map<String, dynamic>? errorDetail;

  const ScanAttendanceState({
    this.scanResult,
    this.officeQr,
    this.officeQrImage,
    this.isLoading = false,
    this.error,
    this.errorDetail,
  });

  ScanAttendanceState copyWith({
    Map<String, dynamic>? scanResult,
    Map<String, dynamic>? officeQr,
    Response<dynamic>? officeQrImage,
    bool? isLoading,
    Object? error = _keep, // ✅ sentinel
    Object? errorDetail = _keep, // ✅ sentinel
  }) {
    return ScanAttendanceState(
      scanResult: scanResult ?? this.scanResult,
      officeQr: officeQr ?? this.officeQr,
      officeQrImage: officeQrImage ?? this.officeQrImage,
      isLoading: isLoading ?? this.isLoading,
      error: error == _keep ? this.error : error as String?,
      errorDetail: errorDetail == _keep
          ? this.errorDetail
          : errorDetail as Map<String, dynamic>?,
    );
  }
}

/// ─────────────────────────────────────────────────────────
/// Attendance Settings State
/// ─────────────────────────────────────────────────────────

class AttendanceSettingsState {
  final AttendanceSettingsEntity? settings;
  final bool isLoading;
  final String? error;

  const AttendanceSettingsState({
    this.settings,
    this.isLoading = false,
    this.error,
  });

  AttendanceSettingsState copyWith({
    AttendanceSettingsEntity? settings,
    bool? isLoading,
    Object? error = _keep, // ✅ sentinel
  }) {
    final next = AttendanceSettingsState(
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
      error: error == _keep ? this.error : error as String?,
    );
    return next;
  }
}

/// ─────────────────────────────────────────────────────────
/// Manager State
/// ─────────────────────────────────────────────────────────

class ManagerAttendanceState {
  final List<AttendanceEntity> records;
  final AttendanceEntity? selected;

  
  final Map<String, dynamic> todaySummary;


  final bool isLoading;
  final String? error;

  const ManagerAttendanceState({
    this.records = const [],
    this.selected,
    this.todaySummary = const {},
    this.isLoading = false,
    this.error,
  });

  ManagerAttendanceState copyWith({
    List<AttendanceEntity>? records,
    AttendanceEntity? selected,
    Map<String, dynamic>? todaySummary,
    bool? isLoading,
    Object? error = _keep,
  }) {
    return ManagerAttendanceState(
      records: records ?? this.records,
      selected: selected ?? this.selected,
      todaySummary: todaySummary ?? this.todaySummary,
      isLoading: isLoading ?? this.isLoading,
      error: error == _keep ? this.error : error as String?,
    );
  }
}
