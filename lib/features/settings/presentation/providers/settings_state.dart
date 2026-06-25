import 'package:frontendmobile/features/settings/domain/entities/system_setting_entity.dart';

///////////////////////////////////////////////////////////////////////////
/// Store UI State
/// Before Calling API
/// settings = []
// isLoading = false
// error = null  || success error = null if error => error = "server error"
///////////////////////////////////////////////////////////////////////////
const _keep = Object();

class SettingsState {
  final List<SystemSettingEntity> settings;
  final bool isLoading;
  final String? error;

  const SettingsState({
    this.settings = const [],
    this.isLoading = false,
    this.error,
  });

  SettingsState copyWith({
    List<SystemSettingEntity>? settings,
    bool? isLoading,
    Object? error = _keep,
  }) => SettingsState(
    settings: settings ?? this.settings,
    isLoading: isLoading ?? this.isLoading,
    error: error == _keep ? this.error : error as String?,
  );
}
