import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontendmobile/features/profile/data/datasources/profile_local_datasource_impl.dart';
import 'package:frontendmobile/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:frontendmobile/features/profile/domain/entities/profile_entity.dart';
import 'package:frontendmobile/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:frontendmobile/shared/providers/core_providers.dart';

part 'profile_providers.g.dart';

// ── Datasource ───────────────────────────────────────────────
@riverpod
Future<ProfileLocalDatasourceImpl> profileLocal(Ref ref) async {
  final storage = ref.read(secureStorageProvider); // ← storage only, no Dio
  return ProfileLocalDatasourceImpl(storage);
}

// ── Repository ───────────────────────────────────────────────
@riverpod
Future<ProfileRepositoryImpl> profileRepository(Ref ref) async {
  final local = await ref.watch(profileLocalProvider.future); // ← profileLocal
  return ProfileRepositoryImpl(local);
}

// ── UseCase ──────────────────────────────────────────────────
@riverpod
Future<GetProfileUseCase> getProfileUseCase(Ref ref) async {
  final repo = await ref.watch(profileRepositoryProvider.future);
  return GetProfileUseCase(repo);
}

// ── Notifier ─────────────────────────────────────────────────
@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  @override
  Future<ProfileEntity> build() async {
    return _fetch();
  }

  Future<ProfileEntity> _fetch() async {
    final useCase = await ref.read(getProfileUseCaseProvider.future);
    return useCase();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }
}