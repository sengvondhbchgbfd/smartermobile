import 'dart:io';
import 'package:frontendmobile/features/hr/staff/domain/entities/staff_entity.dart';
<<<<<<< HEAD
=======
import 'package:frontendmobile/features/users/presentation/provider/user_notifier.dart';
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontendmobile/features/hr/staff/data/model/staff/update_staff_request.dart';
import 'package:frontendmobile/features/hr/staff/domain/usecases/staff_usecases.dart';
import 'staff_repository_provider.dart';
part 'staff_notifier.g.dart';
<<<<<<< HEAD
=======

>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
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
<<<<<<< HEAD
    // ← keep provider alive so it's not destroyed when leaving the screen
    ref.keepAlive();
    // ── wait for repository to be ready ──
    final repository = await ref.read(staffRepositoryProvider.future);
    // ── init use cases ──
=======
    ref.keepAlive();
    final repository = await ref.read(staffRepositoryProvider.future);
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
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
<<<<<<< HEAD
    // ── fetch once automatically ──
    return await _getAll();
  }

  // ── Manual refresh ──
=======
    return await _getAll();
  }

>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
  Future<void> fetchAll() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _getAll());
  }

<<<<<<< HEAD
  ////////////////////////

=======
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
  Future<void> fetchById(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final staff = await _getById(id);
      return [staff];
    });
  }

  Future<void> fetchMyProfile() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final staff = await _getMyProfile();
      return [staff];
    });
  }

  Future<void> fetchManagers() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _getManagers());
  }

  Future<void> fetchByRole(int staffRoleId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _getByRole(staffRoleId));
  }

  Future<void> fetchByDepartment(int departmentId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _getByDepartment(departmentId));
  }

  Future<void> fetchByUserId(int userId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final staff = await _getByUserId(userId);
      return [staff];
    });
  }

<<<<<<< HEAD
  Future<void> create(StaffEntity staff) async {
    state = const AsyncValue.loading();
    await AsyncValue.guard(() => _create(staff));
    await fetchAll();
  }

=======
  // ── CREATE ──
  Future<void> create(StaffEntity staff) async {
    final created = await _create(staff);
    final current = state.valueOrNull ?? [];
    state = AsyncData([...current, created]);
    if (created.userId != null) {
      ref.read(userNotifierProvider.notifier).patchStaff(created);
    }
  }

  // ── UPDATE ──
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
  Future<void> updates(
    int id,
    UpdateStaffRequest request, {
    File? avatarFile,
  }) async {
<<<<<<< HEAD
    state = const AsyncValue.loading();
    await AsyncValue.guard(() => _update(id, request, avatarFile: avatarFile));
    await fetchAll();
  }

  Future<void> updateAvatar(int id, File avatarFile) async {
    state = const AsyncValue.loading();
    await AsyncValue.guard(() => _updateAvatar(id, avatarFile));
    await fetchAll();
  }

  Future<void> delete(int id) async {
    state = const AsyncValue.loading();
    await AsyncValue.guard(() => _delete(id));
    await fetchAll();
  }
}
=======
    final updated = await _update(id, request, avatarFile: avatarFile);
    final current = state.valueOrNull ?? [];
    state = AsyncData(
      current.map((s) => s.id == id ? updated : s).toList(),
    );
    if (updated.userId != null) {
      ref.read(userNotifierProvider.notifier).patchStaff(updated);
    }
  }

  // ── UPDATE AVATAR ──
  Future<void> updateAvatar(int id, File avatarFile) async {
    final updated = await _updateAvatar(id, avatarFile);
    final current = state.valueOrNull ?? [];
    state = AsyncData(
      current.map((s) => s.id == id ? updated : s).toList(),
    );
    if (updated.userId != null) {
      ref.read(userNotifierProvider.notifier).patchStaff(updated);
    }
  }

  // ── DELETE ──
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
}
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
