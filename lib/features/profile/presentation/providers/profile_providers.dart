import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/errors/api_error_handler.dart';
import 'package:frontendmobile/features/hr/staff/presentation/providers/staff_notifier.dart';
import 'package:frontendmobile/features/users/presentation/provider/user_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontendmobile/features/profile/data/datasources/profile_local_datasource.dart'; // ← interface
import 'package:frontendmobile/features/profile/data/datasources/profile_local_datasource_impl.dart'; // ← impl (for instantiation)
import 'package:frontendmobile/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:frontendmobile/features/profile/domain/entities/profile_entity.dart';
import 'package:frontendmobile/features/profile/domain/repositories/profile_repository.dart'; // ← interface
import 'package:frontendmobile/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:frontendmobile/shared/providers/core_providers.dart';
part 'profile_providers.g.dart';

// ── Datasource ────────────────────────────────────────────────────────────────

@riverpod
Future<ProfileLocalDatasource> profileLocal(Ref ref) async {
  final storage = ref.read(secureStorageProvider);
  return ProfileLocalDatasourceImpl(storage);
}

// ── Repository ────────────────────────────────────────────────────────────────

@riverpod
Future<ProfileRepository> profileRepository(Ref ref) async {
  final local = await ref.watch(profileLocalProvider.future);
  return ProfileRepositoryImpl(local);
}

// ── UseCase ───────────────────────────────────────────────────────────────────

@riverpod
Future<GetProfileUseCase> getProfileUseCase(Ref ref) async {
  final repo = await ref.watch(profileRepositoryProvider.future);
  return GetProfileUseCase(repo);
}

// ── Notifier ──────────────────────────────────────────────────────────────────

@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  @override
  Future<ProfileEntity> build() async => _fetch();

  Future<ProfileEntity> _fetch() async {
    final useCase = await ref.read(getProfileUseCaseProvider.future);
    final profile = await useCase();

    try {
      final staffList = await ref.watch(staffNotifierProvider.future);
      final myStaffProfile = staffList
          .where((s) => s.userId == profile.userId)
          .firstOrNull;

      final userState = await ref.watch(userNotifierProvider.future);
      final departmentName = userState.departments
          .where((d) => d.departmentId == profile.departmentId)
          .firstOrNull
          ?.departmentName;

      return ProfileEntity(
        userId: profile.userId,
        companyId: profile.companyId,
        staffId: profile.staffId,
        username: profile.username,
        fullName: myStaffProfile?.name.isNotEmpty == true
            ? myStaffProfile!.name
            : profile.fullName,
        role: profile.role,
        status: profile.status,
        isManager: profile.isManager,
        permissions: profile.permissions,
        departmentId: profile.departmentId,
        avatarUrl: myStaffProfile?.avatarUrl ?? profile.avatarUrl,
        memberSince: myStaffProfile?.createdAt != null
            ? '${myStaffProfile!.createdAt!.year}-'
                  '${myStaffProfile.createdAt!.month.toString().padLeft(2, '0')}-'
                  '${myStaffProfile.createdAt!.day.toString().padLeft(2, '0')}'
            : profile.memberSince,
        department: departmentName ?? profile.department,
      );
    } on DioException catch (e) {
      throw ApiErrorHandler.getMessage(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(_fetch);
  }
}
