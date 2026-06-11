import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/network/dio_client.dart';

import '../../data/datasources/system_setting_remote_datasource.dart';
import '../../data/repositories/system_setting_repository_impl.dart';
import '../../domain/entities/system_setting_entity.dart';
import '../../domain/repositories/system_setting_repository.dart';
import '../../domain/usecase/system_setting_usecase.dart';

final dioClientProvider = Provider<DioClient>((ref) => throw UnimplementedError(
  'Register dioClientProvider in your ProviderScope overrides.',
));

final systemSettingDataSourceProvider =
    Provider<SystemSettingRemoteDataSource>((ref) {
  return SystemSettingRemoteDataSourceImpl(ref.read(dioClientProvider));
});

final systemSettingRepositoryProvider = Provider<SystemSettingRepository>((ref) {
  return SystemSettingRepositoryImpl(ref.read(systemSettingDataSourceProvider));
});

// ---------------------------------------------------------------------------
// Usecase providers
// ---------------------------------------------------------------------------

final getAllSettingsUseCaseProvider =
    Provider((ref) => GetAllSettingsUseCase(ref.read(systemSettingRepositoryProvider)));

final getSettingByIdUseCaseProvider =
    Provider((ref) => GetSettingByIdUseCase(ref.read(systemSettingRepositoryProvider)));

final createSettingUseCaseProvider =
    Provider((ref) => CreateSettingUseCase(ref.read(systemSettingRepositoryProvider)));

final updateSettingUseCaseProvider =
    Provider((ref) => UpdateSettingUseCase(ref.read(systemSettingRepositoryProvider)));

final upsertSettingByKeyUseCaseProvider =
    Provider((ref) => UpsertSettingByKeyUseCase(ref.read(systemSettingRepositoryProvider)));

final bulkUpsertSettingsUseCaseProvider =
    Provider((ref) => BulkUpsertSettingsUseCase(ref.read(systemSettingRepositoryProvider)));

final deleteSettingUseCaseProvider =
    Provider((ref) => DeleteSettingUseCase(ref.read(systemSettingRepositoryProvider)));

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

class SettingsState {
  final List<SystemSettingEntity> settings;
  final bool    isLoading;
  final String? error;

  const SettingsState({
    this.settings  = const [],
    this.isLoading = false,
    this.error,
  });

  SettingsState copyWith({
    List<SystemSettingEntity>? settings,
    bool?   isLoading,
    String? error,
  }) =>
      SettingsState(
        settings:  settings  ?? this.settings,
        isLoading: isLoading ?? this.isLoading,
        error:     error,
      );
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class SettingsNotifier extends StateNotifier<SettingsState> {
  final GetAllSettingsUseCase     _getAll;
  final CreateSettingUseCase      _create;
  final UpdateSettingUseCase      _update;
  final UpsertSettingByKeyUseCase _upsertByKey;
  final BulkUpsertSettingsUseCase _bulkUpsert;
  final DeleteSettingUseCase      _delete;

  SettingsNotifier({
    required GetAllSettingsUseCase     getAll,
    required CreateSettingUseCase      create,
    required UpdateSettingUseCase      update,
    required UpsertSettingByKeyUseCase upsertByKey,
    required BulkUpsertSettingsUseCase bulkUpsert,
    required DeleteSettingUseCase      delete,
  })  : _getAll      = getAll,
        _create      = create,
        _update      = update,
        _upsertByKey = upsertByKey,
        _bulkUpsert  = bulkUpsert,
        _delete      = delete,
        super(const SettingsState());

  // ── Load ──────────────────────────────────────────────────────────────────

  Future<void> loadAll() async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await _getAll();
      state = state.copyWith(settings: result, isLoading: false);
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ── Create ────────────────────────────────────────────────────────────────

  Future<bool> create({
    required String key,
    required String value,
    String? description,
  }) async {
    try {
      final created = await _create(key: key, value: value, description: description);
      state = state.copyWith(settings: [...state.settings, created]);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(error: e.message);
      return false;
    }
  }

  // ── Update ────────────────────────────────────────────────────────────────

  Future<bool> update({
    required int    settingId,
    required String value,
    String?         description,
  }) async {
    try {
      final updated = await _update(
        settingId: settingId, value: value, description: description,
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

  // ── Upsert by key ─────────────────────────────────────────────────────────

  Future<bool> upsertByKey({
    required String key,
    required String value,
  }) async {
    try {
      final result = await _upsertByKey(key: key, value: value);
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

  // ── Bulk upsert ───────────────────────────────────────────────────────────

  Future<bool> bulkUpsert(List<({String key, String value})> items) async {
    try {
      final results = await _bulkUpsert(items);
      final map     = {for (final r in results) r.settingId: r};
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

  // ── Delete ────────────────────────────────────────────────────────────────

  Future<bool> delete(int settingId) async {
    try {
      await _delete(settingId);
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
// Provider
// ---------------------------------------------------------------------------

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier(
    getAll:      ref.read(getAllSettingsUseCaseProvider),
    create:      ref.read(createSettingUseCaseProvider),
    update:      ref.read(updateSettingUseCaseProvider),
    upsertByKey: ref.read(upsertSettingByKeyUseCaseProvider),
    bulkUpsert:  ref.read(bulkUpsertSettingsUseCaseProvider),
    delete:      ref.read(deleteSettingUseCaseProvider),
  );
});