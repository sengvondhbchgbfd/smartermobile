import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontendmobile/shared/providers/core_providers.dart';
import '../../data/datasource/attendance_remote_datasource_impl.dart';
import '../../data/repositories/attendance_repository_impl.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../../domain/usecases/attendance_usecases.dart';
part 'attendance_providers.g.dart';

// ── datasource → repository ───────────────────────────────────────────────────

@riverpod
Future<AttendanceRepository> attendanceRepository(Ref ref) async {
  final dioClient = await ref.watch(dioClientProvider.future);
  final ds = AttendanceRemoteDataSourceImpl(dioClient.dio);
  return AttendanceRepositoryImpl(ds);
}

// ── Staff usecases ────────────────────────────────────────────────────────────

@riverpod
Future<GetMyAttendanceUseCase> getMyAttendanceUseCase(Ref ref) async {
  final repo = await ref.watch(attendanceRepositoryProvider.future);
  return GetMyAttendanceUseCase(repo);
}

@riverpod
Future<GetMonthlyStatsUseCase> getMonthlyStatsUseCase(Ref ref) async {
  final repo = await ref.watch(attendanceRepositoryProvider.future);
  return GetMonthlyStatsUseCase(repo);
}

// ── Scan usecases ─────────────────────────────────────────────────────────────

@riverpod
Future<ScanAuthenticateUseCase> scanAuthenticateUseCase(Ref ref) async {
  final repo = await ref.watch(attendanceRepositoryProvider.future);
  return ScanAuthenticateUseCase(repo);
}

@riverpod
Future<CheckInUseCase> checkInUseCase(Ref ref) async {
  final repo = await ref.watch(attendanceRepositoryProvider.future);
  return CheckInUseCase(repo);
}

@riverpod
Future<CheckOutUseCase> checkOutUseCase(Ref ref) async {
  final repo = await ref.watch(attendanceRepositoryProvider.future);
  return CheckOutUseCase(repo);
}

@riverpod
Future<GetOfficeQrUseCase> getOfficeQrUseCase(Ref ref) async {
  final repo = await ref.watch(attendanceRepositoryProvider.future);
  return GetOfficeQrUseCase(repo);
}

@riverpod
Future<DownloadOfficeQrImageUseCase> downloadOfficeQrImageUseCase(
  Ref ref,
) async {
  final repo = await ref.watch(attendanceRepositoryProvider.future);
  return DownloadOfficeQrImageUseCase(repo);
}
// ── settings usecases ─────────────────────────────────────────────────────────

@riverpod
Future<GetAttendanceSettingsUseCase> getAttendanceSettingsUseCase(
  Ref ref,
) async {
  final repo = await ref.watch(attendanceRepositoryProvider.future);
  return GetAttendanceSettingsUseCase(repo);
}

@riverpod
Future<UpdateAttendanceSettingUseCase> updateAttendanceSettingsUseCase(
  Ref ref,
) async {
  final repo = await ref.watch(attendanceRepositoryProvider.future);
  return UpdateAttendanceSettingUseCase(repo);
}

// ── Manager usecases ──────────────────────────────────────────────────────────

@riverpod
Future<GetAllAttendanceUseCase> getAllAttendanceUseCase(Ref ref) async {
  final repo = await ref.watch(attendanceRepositoryProvider.future);
  return GetAllAttendanceUseCase(repo);
}

@riverpod
Future<GetAttendanceByIdUseCase> getAttendanceByIdUseCase(Ref ref) async {
  final repo = await ref.watch(attendanceRepositoryProvider.future);
  return GetAttendanceByIdUseCase(repo);
}

@riverpod
Future<GetTodaySummaryUseCase> getTodaySummaryUseCase(Ref ref) async {
  final repo = await ref.watch(attendanceRepositoryProvider.future);
  return GetTodaySummaryUseCase(repo);
}

@riverpod
Future<GetByDateRangeUseCase> getByDateRangeUseCase(Ref ref) async {
  final repo = await ref.watch(attendanceRepositoryProvider.future);
  return GetByDateRangeUseCase(repo);
}
