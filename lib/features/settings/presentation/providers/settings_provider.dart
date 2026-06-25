import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/config/di/dependency_injection.dart';
import 'package:frontendmobile/core/errors/exceptions.dart';
import 'package:frontendmobile/features/settings/presentation/providers/settings_state.dart';
import '../../data/datasources/system_setting_remote_datasource.dart';
import '../../data/repositories/system_setting_repository_impl.dart';
import '../../domain/repositories/system_setting_repository.dart';
import '../../domain/usecase/system_setting_usecase.dart';

// ---------------------------------------------------------------------------
// Data / Repo / UseCase providers
// ---------------------------------------------------------------------------

final systemSettingDataSourceProvider =
    FutureProvider<SystemSettingRemoteDataSource>((ref) async {
      final dioClient = await ref.watch(dioClientProvider.future);
      return SystemSettingRemoteDataSourceImpl(dioClient);
    });

final systemSettingRepositoryProvider = FutureProvider<SystemSettingRepository>(
  (ref) async {
    final ds = await ref.watch(systemSettingDataSourceProvider.future);
    return SystemSettingRepositoryImpl(ds);
  },
);

final getAllSettingsUseCaseProvider = FutureProvider((ref) async {
  final repo = await ref.watch(systemSettingRepositoryProvider.future);
  return GetAllSettingsUseCase(repo);
});

final getSettingByIdUseCaseProvider = FutureProvider((ref) async {
  final repo = await ref.watch(systemSettingRepositoryProvider.future);
  return GetSettingByIdUseCase(repo);
});

final createSettingUseCaseProvider = FutureProvider((ref) async {
  final repo = await ref.watch(systemSettingRepositoryProvider.future);
  return CreateSettingUseCase(repo);
});

final updateSettingUseCaseProvider = FutureProvider((ref) async {
  final repo = await ref.watch(systemSettingRepositoryProvider.future);
  return UpdateSettingUseCase(repo);
});

final upsertSettingByKeyUseCaseProvider = FutureProvider((ref) async {
  final repo = await ref.watch(systemSettingRepositoryProvider.future);
  return UpsertSettingByKeyUseCase(repo);
});

final bulkUpsertSettingsUseCaseProvider = FutureProvider((ref) async {
  final repo = await ref.watch(systemSettingRepositoryProvider.future);
  return BulkUpsertSettingsUseCase(repo);
});

final deleteSettingUseCaseProvider = FutureProvider((ref) async {
  final repo = await ref.watch(systemSettingRepositoryProvider.future);
  return DeleteSettingUseCase(repo);
});

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class SettingsNotifier extends StateNotifier<SettingsState> {
  final Ref _ref;
  SystemSettingRepository? _cachedRepo;

  SettingsNotifier(this._ref) : super(const SettingsState());

  Future<SystemSettingRepository> get _repo async {
    _cachedRepo ??= await _ref.read(systemSettingRepositoryProvider.future);
    return _cachedRepo!;
  }

  Future<void> loadAll() async {
    state = state.copyWith(isLoading: true);
    try {
      final repo = await _repo;
      final result = await GetAllSettingsUseCase(repo)();
      state = state.copyWith(settings: result, isLoading: false);
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> create({
    required String key,
    required String value,
    String? description,
  }) async {
    try {
      final repo = await _repo;
      final created = await CreateSettingUseCase(repo)(
        key: key,
        value: value,
        description: description,
      );
      state = state.copyWith(settings: [...state.settings, created]);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(error: e.message);
      return false;
    }
  }

  Future<bool> update({
    required int settingId,
    required String value,
    String? description,
  }) async {
    try {
      final repo = await _repo;
      final updated = await UpdateSettingUseCase(repo)(
        settingId: settingId,
        value: value,
        description: description,
      );
      state = state.copyWith(
        settings: state.settings
            .map((s) => s.settingId == settingId ? updated : s)
            .toList(),
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(error: e.message);
      return false;
    }
  }

  Future<bool> upsertByKey({required String key, required String value}) async {
    try {
      final repo = await _repo;
      final result = await UpsertSettingByKeyUseCase(repo)(
        key: key,
        value: value,
      );
      final exists = state.settings.any((s) => s.settingId == result.settingId);
      state = state.copyWith(
        settings: exists
            ? state.settings
                  .map((s) => s.settingId == result.settingId ? result : s)
                  .toList()
            : [...state.settings, result],
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(error: e.message);
      return false;
    }
  }

  Future<bool> bulkUpsert(List<({String key, String value})> items) async {
    try {
      final repo = await _repo;
      final results = await BulkUpsertSettingsUseCase(repo)(items);
      final map = {for (final r in results) r.settingId: r};
      final updated = state.settings.map((s) => map[s.settingId] ?? s).toList();
      final newOnes = results.where(
        (r) => !state.settings.any((s) => s.settingId == r.settingId),
      );
      state = state.copyWith(settings: [...updated, ...newOnes]);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(error: e.message);
      return false;
    }
  }

  Future<bool> delete(int settingId) async {
    try {
      final repo = await _repo;
      await DeleteSettingUseCase(repo)(settingId);
      state = state.copyWith(
        settings: state.settings
            .where((s) => s.settingId != settingId)
            .toList(),
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(error: e.message);
      return false;
    }
  }

  void clearError() => state = state.copyWith(error: null);
}

// ---------------------------------------------------------------------------
// Provider — simple, no Noop classes, no loading constructor
// ---------------------------------------------------------------------------

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) {
    return SettingsNotifier(ref);
  },
);
