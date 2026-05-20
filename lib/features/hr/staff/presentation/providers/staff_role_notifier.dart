import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontendmobile/features/hr/staff/domain/entities/staff_role_entity.dart';
import 'package:frontendmobile/features/hr/staff/domain/usecases/staff_role_usecases.dart';
import 'staff_role_repository_provider.dart';
part 'staff_role_notifier.g.dart';

@riverpod
class StaffRoleNotifier extends _$StaffRoleNotifier {
  late final GetAllStaffRoleUseCase _getAll;
  late final GetStaffRoleByIdUseCase _getById;
  late final CreateStaffRoleUseCase _create;
  late final UpdateStaffRoleUseCase _updateRole;
  late final DeleteStaffRoleUseCase _delete;

  @override
  Future<List<StaffRoleEntity>> build() async {
    // ← keep provider alive so it's not destroyed when leaving the screen
    ref.keepAlive();
    // ── watch repository once ──
    // ref.watch() inside build()   → listens for changes -> repository changes → build() runs again -> API called again
    // ref.read() inside build()    → reads once, no listener -> repository doesn't trigger rebuild -> api one call
    final repository = await ref.read(staffRoleRepositoryProvider.future);

    // ── init use cases ──
    _getAll = GetAllStaffRoleUseCase(repository);
    _getById = GetStaffRoleByIdUseCase(repository);
    _create = CreateStaffRoleUseCase(repository);
    _updateRole = UpdateStaffRoleUseCase(repository);
    _delete = DeleteStaffRoleUseCase(repository);

    // ── fetch once, automatically, no microtask needed ──
    return await _getAll();
  }

  // ── Manual refresh ──
  Future<void> fetchAll() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _getAll());
  }

  Future<void> fetchById(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final role = await _getById(id);
      return [role];
    });
  }

  Future<void> create(StaffRoleEntity role) async {
    state = const AsyncValue.loading();
    await AsyncValue.guard(() => _create(role));
    await fetchAll();
  }

  Future<void> updates(int id, StaffRoleEntity role) async {
    state = const AsyncValue.loading();
    await AsyncValue.guard(() => _updateRole(id, role));
    await fetchAll();
  }

  Future<void> delete(int id) async {
    state = const AsyncValue.loading();
    await AsyncValue.guard(() => _delete(id));
    await fetchAll();
  }
}
