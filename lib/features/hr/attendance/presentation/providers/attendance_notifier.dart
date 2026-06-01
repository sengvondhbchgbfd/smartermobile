import 'package:dio/dio.dart';
import 'package:frontendmobile/core/errors/api_error_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'attendance_providers.dart';
import 'attendance_state.dart';

part 'attendance_notifier.g.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Staff Notifier
// ─────────────────────────────────────────────────────────────────────────────
@riverpod
class StaffAttendance extends _$StaffAttendance {
  bool _initialized = false;
  bool get isLoaded => _initialized;

  @override
  Future<StaffAttendanceState> build() async {
    if (_initialized) {
      return state.value ?? const StaffAttendanceState();
    }
    _initialized = true;
    return const StaffAttendanceState();
  }

  Future<void> _run(Future<void> Function() fn) async {
    final current = state.value ?? const StaffAttendanceState();
    state = AsyncData(current.copyWith(isLoading: true, error: null));
    try {
      await fn();
    } on DioException catch (e) {
      final s = state.value ?? const StaffAttendanceState();
      state = AsyncData(
        s.copyWith(isLoading: false, error: ApiErrorHandler.getMessage(e)),
      );
    } catch (e) {
      final s = state.value ?? const StaffAttendanceState();
      state = AsyncData(s.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> fetchMyAttendance({int? month, int? year}) => _run(() async {
    final useCase = await ref.read(getMyAttendanceUseCaseProvider.future);
    final list = await useCase(month: month, year: year);
    state = AsyncData(
      (state.value ?? const StaffAttendanceState()).copyWith(
        records: list,
        isLoading: false,
      ),
    );
  });

  Future<void> fetchMonthlyStats({required int month, required int year}) =>
      _run(() async {
        final useCase = await ref.read(getMonthlyStatsUseCaseProvider.future);
        final stats = await useCase(month: month, year: year);
        state = AsyncData(
          (state.value ?? const StaffAttendanceState()).copyWith(
            monthlyStats: stats,
            isLoading: false,
          ),
        );
      });

  void clearError() {
    final s = state.value ?? const StaffAttendanceState();
    state = AsyncData(s.copyWith(error: null));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Scan Notifier
// ─────────────────────────────────────────────────────────────────────────────
@riverpod
class ScanAttendance extends _$ScanAttendance {
  @override
  Future<ScanAttendanceState> build() async {
    await ref.watch(scanAuthenticateUseCaseProvider.future);
    await ref.watch(checkInUseCaseProvider.future);
    await ref.watch(checkOutUseCaseProvider.future);
    await ref.watch(getOfficeQrUseCaseProvider.future);
    await ref.watch(downloadOfficeQrImageUseCaseProvider.future);
    return const ScanAttendanceState();
  }

  Future<void> _run(Future<void> Function() fn) async {
    final current = state.value ?? const ScanAttendanceState();
    state = AsyncData(
      current.copyWith(isLoading: true, error: null, errorDetail: null),
    );
    try {
      await fn();
    } on DioException catch (e) {
      final s = state.value ?? const ScanAttendanceState();
      final data = e.response?.data;
      Map<String, dynamic>? detail;
      if (data is Map<String, dynamic>) {
        if (data['detail'] is Map<String, dynamic>) {
          detail = data['detail'];
        }
      }
      state = AsyncData(
        s.copyWith(
          isLoading: false,
          error: ApiErrorHandler.getMessage(e),
          errorDetail: detail,
        ),
      );
    } catch (e) {
      final s = state.value ?? const ScanAttendanceState();
      state = AsyncData(s.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> authenticate({required String password}) => _run(() async {
    final useCase = await ref.read(scanAuthenticateUseCaseProvider.future);
    final result = await useCase(password: password);
    state = AsyncData(
      (state.value ?? const ScanAttendanceState()).copyWith(
        scanResult: result,
        isLoading: false,
      ),
    );
  });

  Future<void> checkIn({
    required String scanToken,
    required String officeQrToken,
    required String latitude,
    required String longitude,
    required String companyId,
  }) => _run(() async {
    final useCase = await ref.read(checkInUseCaseProvider.future);
    final result = await useCase(
      scanToken: scanToken,
      officeQrToken: officeQrToken,
      latitude: latitude,
      longitude: longitude,
      companyId: companyId,
    );
    state = AsyncData(
      (state.value ?? const ScanAttendanceState()).copyWith(
        scanResult: result,
        isLoading: false,
      ),
    );
  });

  Future<void> checkOut({
    required String scanToken,
    required String officeQrToken,
    required String latitude,
    required String longitude,
    required String companyId,
  }) => _run(() async {
    final useCase = await ref.read(checkOutUseCaseProvider.future);
    final result = await useCase(
      scanToken: scanToken,
      officeQrToken: officeQrToken,
      latitude: latitude,
      longitude: longitude,
      companyId: companyId,
    );
    state = AsyncData(
      (state.value ?? const ScanAttendanceState()).copyWith(
        scanResult: result,
        isLoading: false,
      ),
    );
  });

  Future<void> fetchOfficeQr() => _run(() async {
    final useCase = await ref.read(getOfficeQrUseCaseProvider.future);
    final result = await useCase();
    state = AsyncData(
      (state.value ?? const ScanAttendanceState()).copyWith(
        officeQr: result,
        isLoading: false,
      ),
    );
  });

  Future<void> downloadOfficeQrImage() => _run(() async {
    final useCase = await ref.read(downloadOfficeQrImageUseCaseProvider.future);
    final result = await useCase();
    state = AsyncData(
      (state.value ?? const ScanAttendanceState()).copyWith(
        officeQrImage: result,
        isLoading: false,
      ),
    );
  });

  void clearError() {
    final s = state.value ?? const ScanAttendanceState();
    state = AsyncData(s.copyWith(error: null, errorDetail: null));
  }

  void clearScanResult() {
    final s = state.value ?? const ScanAttendanceState();
    state = AsyncData(s.copyWith(scanResult: null));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Attendance Settings Notifier
// ✅ sync build() — .value is NEVER null, no AsyncLoading race condition
// ─────────────────────────────────────────────────────────────────────────────
@riverpod
class AttendanceSettings extends _$AttendanceSettings {
  DateTime? _lastFetchTime;

  @override
  AttendanceSettingsState build() {
    ref.keepAlive();
    return const AttendanceSettingsState();
  }

  Future<void> _run(Future<void> Function() fn) async {
    final current = state.value ?? const AttendanceSettingsState();
    state = AsyncData(current.copyWith(isLoading: true, error: null));
    try {
      await fn();
    } on DioException catch (e) {
      final s = state.value ?? const AttendanceSettingsState();
      state = AsyncData(
        s.copyWith(isLoading: false, error: ApiErrorHandler.getMessage(e)),
      );
    } catch (e) {
      final s = state.value ?? const AttendanceSettingsState();
      state = AsyncData(s.copyWith(isLoading: false, error: e.toString()));
    }
  }

  bool _shouldRefetch() {
    if (_lastFetchTime == null) return true;
    return DateTime.now().difference(_lastFetchTime!).inMinutes >= 5;
  }

  Future<void> fetchSettings() async {
    if (!_shouldRefetch()) return;
    await _run(() async {
      final useCase = await ref.read(
        getAttendanceSettingsUseCaseProvider.future,
      );
      final result = await useCase();
      _lastFetchTime = DateTime.now();
      state = AsyncData(
        (state.value ?? const AttendanceSettingsState()).copyWith(
          settings: result,
          isLoading: false,
        ),
      );
    });
  }

  Future<void> updateSettings({
    double? officeLatitude,
    double? officeLongitude,
    int? allowedRadiusMeters,
    int? lateThresholdMinutes,
    int? overtimeThresholdMinutes,
    String? officeOpenTime,
    String? officeCloseTime,
    String? timezone,
  }) => _run(() async {
    final useCase = await ref.read(
      updateAttendanceSettingsUseCaseProvider.future,
    );
    final result = await useCase(
      officeLatitude: officeLatitude,
      officeLongitude: officeLongitude,
      allowedRadiusMeters: allowedRadiusMeters,
      lateThresholdMinutes: lateThresholdMinutes,
      overtimeThresholdMinutes: overtimeThresholdMinutes,
      officeOpenTime: officeOpenTime,
      officeCloseTime: officeCloseTime,
      timezone: timezone,
    );
    _lastFetchTime = DateTime.now();
    state = AsyncData(
      (state.value ?? const AttendanceSettingsState()).copyWith(
        settings: result,
        isLoading: false,
      ),
    );
  });

  void clearError() {
    final s = state.value ?? const AttendanceSettingsState();
    state = AsyncData(s.copyWith(error: null));
  }

  void clearSettings() {
    final s = state.value ?? const AttendanceSettingsState();
    state = AsyncData(s.copyWith(settings: null));
    _lastFetchTime = null;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Manager Notifier
// ─────────────────────────────────────────────────────────────────────────────
@riverpod
class ManagerAttendance extends _$ManagerAttendance {
  @override
  Future<ManagerAttendanceState> build() async {
    await ref.watch(getAllAttendanceUseCaseProvider.future);
    await ref.watch(getAttendanceByIdUseCaseProvider.future);
    await ref.watch(getTodaySummaryUseCaseProvider.future);
    await ref.watch(getByDateRangeUseCaseProvider.future);
    return const ManagerAttendanceState();
  }

  Future<void> _run(Future<void> Function() fn) async {
    final current = state.value ?? const ManagerAttendanceState();
    state = AsyncData(current.copyWith(isLoading: true, error: null));
    try {
      await fn();
    } on DioException catch (e) {
      final s = state.value ?? const ManagerAttendanceState();
      state = AsyncData(
        s.copyWith(isLoading: false, error: ApiErrorHandler.getMessage(e)),
      );
    } catch (e) {
      final s = state.value ?? const ManagerAttendanceState();
      state = AsyncData(s.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> fetchAllAttendance({
    String? filterDate,
    int? month, // ← add
    int? year, // ← add
    int? staffId, // ← add
  }) => _run(() async {
    final useCase = await ref.read(getAllAttendanceUseCaseProvider.future);
    final list = await useCase(
      filterDate: filterDate,
      month: month,
      year: year,
      staffId: staffId,
    );
    state = AsyncData(
      (state.value ?? const ManagerAttendanceState()).copyWith(
        records: list,
        isLoading: false,
      ),
    );
  });

  Future<void> fetchById(int attendanceId) => _run(() async {
    final useCase = await ref.read(getAttendanceByIdUseCaseProvider.future);
    final record = await useCase(attendanceId);
    state = AsyncData(
      (state.value ?? const ManagerAttendanceState()).copyWith(
        selected: record,
        isLoading: false,
      ),
    );
  });

  Future<void> fetchTodaySummary() => _run(() async {
    final useCase = await ref.read(getTodaySummaryUseCaseProvider.future);
    final summary = await useCase();
    state = AsyncData(
      (state.value ?? const ManagerAttendanceState()).copyWith(
        todaySummary: summary,
        isLoading: false,
      ),
    );
  });

  Future<void> fetchByDateRange({
    required String startDate,
    required String endDate,
    int? staffId,
  }) => _run(() async {
    final useCase = await ref.read(getByDateRangeUseCaseProvider.future);
    final list = await useCase(
      startDate: startDate,
      endDate: endDate,
      staffId: staffId,
    );
    state = AsyncData(
      (state.value ?? const ManagerAttendanceState()).copyWith(
        records: list,
        isLoading: false,
      ),
    );
  });

  void clearError() {
    final s = state.value ?? const ManagerAttendanceState();
    state = AsyncData(s.copyWith(error: null));
  }

  void clearSelected() {
    final s = state.value ?? const ManagerAttendanceState();
    state = AsyncData(s.copyWith(selected: null));
  }
}
