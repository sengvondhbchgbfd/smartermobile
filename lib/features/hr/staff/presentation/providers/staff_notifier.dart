import 'dart:io';
import 'package:frontendmobile/features/hr/staff/domain/entities/staff_entity.dart';
import 'package:frontendmobile/features/users/presentation/provider/user_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontendmobile/features/hr/staff/data/model/staff/update_staff_request.dart';
import 'package:frontendmobile/features/hr/staff/domain/usecases/staff_usecases.dart';
import 'staff_repository_provider.dart';
part 'staff_notifier.g.dart';

@riverpod
class StaffNotifier extends _$StaffNotifier {
  late final GetAllStaffUseCase _getAll;
  late final GetStaffByIdUseCase _getById;
  late final GetMyStaffProfileUseCase _getMyProfile;
  late final GetStaffManagersUseCase _getManagers;
  late final GetStaffByRoleUseCase _getByRole;
  late final GetStaffByDepartmentUseCase _getByDepartment;
  late final GetStaffByUserIdUseCase _getByUserId;
  late final CreateStaffUseCase _create;
  late final UpdateStaffUseCase _update;
  late final UpdateStaffAvatarUseCase _updateAvatar;
  late final DeleteStaffUseCase _delete;

  @override
  Future<List<StaffEntity>> build() async {
    ref.keepAlive();
    final repository = await ref.read(staffRepositoryProvider.future);
    _getAll = GetAllStaffUseCase(repository);
    _getById = GetStaffByIdUseCase(repository);
    _getMyProfile = GetMyStaffProfileUseCase(repository);
    _getManagers = GetStaffManagersUseCase(repository);
    _getByRole = GetStaffByRoleUseCase(repository);
    _getByDepartment = GetStaffByDepartmentUseCase(repository);
    _getByUserId = GetStaffByUserIdUseCase(repository);
    _create = CreateStaffUseCase(repository);
    _update = UpdateStaffUseCase(repository);
    _updateAvatar = UpdateStaffAvatarUseCase(repository);
    _delete = DeleteStaffUseCase(repository);
    return await _getAll();
  }

  // ── REFRESH full list ─────────────────────────────────────────────────────
  Future<void> fetchAll() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _getAll());
  }

  // ── CREATE ────────────────────────────────────────────────────────────────
  Future<void> create(StaffEntity staff) async {
    final created = await _create(staff);
    final current = state.valueOrNull ?? [];
    state = AsyncData([...current, created]);
    if (created.userId != null) {
      ref.read(userNotifierProvider.notifier).patchStaff(created);
    }
  }

  // ── UPDATE ────────────────────────────────────────────────────────────────
  Future<void> updates(
    int id,
    UpdateStaffRequest request, {
    File? avatarFile,
  }) async {
    final updated = await _update(id, request, avatarFile: avatarFile);
    final current = state.valueOrNull ?? [];
    state = AsyncData(current.map((s) => s.id == id ? updated : s).toList());
    if (updated.userId != null) {
      ref.read(userNotifierProvider.notifier).patchStaff(updated);
    }
  }

  // ── UPDATE AVATAR ─────────────────────────────────────────────────────────
  Future<void> updateAvatar(int id, File avatarFile) async {
    final updated = await _updateAvatar(id, avatarFile);
    final current = state.valueOrNull ?? [];
    state = AsyncData(current.map((s) => s.id == id ? updated : s).toList());
    if (updated.userId != null) {
      ref.read(userNotifierProvider.notifier).patchStaff(updated);
    }
  }



  // ── DELETE ────────────────────────────────────────────────────────────────
  Future<void> delete(int id) async {
    final current = state.valueOrNull ?? [];
    final target = current.firstWhere(
      (s) => s.id == id,
      orElse: () => throw Exception('Staff not found'),
    );
    await _delete(id);
    state = AsyncData(current.where((s) => s.id != id).toList());
    if (target.userId != null) {
      ref.read(userNotifierProvider.notifier).removeStaff(target.userId!);
    }
  }

  // ── Internal fetch helpers (do NOT mutate main state) ────────────────────
  Future<StaffEntity> getById(int id) async {
    final cached = state.valueOrNull?.where((s) => s.id == id).firstOrNull;
    if (cached != null) return cached;
    return await _getById(id);
  }

  Future<StaffEntity> getMyProfile() => _getMyProfile();

  Future<StaffEntity?> getByUserId(int userId) async {
    final cached = state.valueOrNull
        ?.where((s) => s.userId == userId)
        .firstOrNull;
    if (cached != null) return cached;
    return await _getByUserId(userId);
  }

  Future<List<StaffEntity>> getManagers() => _getManagers();
  Future<List<StaffEntity>> getByRole(int roleId) => _getByRole(roleId);
  Future<List<StaffEntity>> getByDepartment(int deptId) =>
      _getByDepartment(deptId);
}

// ── Separate family providers — never touch the main list ─────────────────

@riverpod
Future<StaffEntity> staffDetail(StaffDetailRef ref, int id) async {
  final repository = await ref.read(staffRepositoryProvider.future);
  final useCase = GetStaffByIdUseCase(repository);
  return await useCase(id);
}

@riverpod
Future<List<StaffEntity>> staffManagers(StaffManagersRef ref) async {
  return ref.read(staffNotifierProvider.notifier).getManagers();
}

@riverpod
Future<List<StaffEntity>> staffByRole(StaffByRoleRef ref, int roleId) async {
  return ref.read(staffNotifierProvider.notifier).getByRole(roleId);
}

@riverpod
Future<List<StaffEntity>> staffByDepartment(
  StaffByDepartmentRef ref,
  int deptId,
) async {
  return ref.read(staffNotifierProvider.notifier).getByDepartment(deptId);
}
