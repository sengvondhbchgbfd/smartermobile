import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/extensions/user_info_extensions.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontendmobile/features/settings/domain/models/setting_groups.dart';
import 'package:frontendmobile/features/settings/presentation/widgets/setting_group_tile.dart';
import 'package:go_router/go_router.dart';
import 'package:frontendmobile/features/settings/presentation/providers/settings_provider.dart';
import 'package:frontendmobile/features/settings/domain/entities/system_setting_entity.dart';
import 'package:frontendmobile/features/settings/domain/models/setting_create_extra.dart';

class SystemSettingsScreen extends ConsumerStatefulWidget {
  const SystemSettingsScreen({super.key});
  @override
  ConsumerState<SystemSettingsScreen> createState() =>
      _SystemSettingsScreenState();
}

////////////////////////////////////////////////////////////////////////////////
///  setting
////////////////////////////////////////////////////////////////////////////////
class _SystemSettingsScreenState extends ConsumerState<SystemSettingsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final state = ref.read(settingsProvider);
      if (state.settings.isEmpty) {
        ref.read(settingsProvider.notifier).loadAll();
      }
    });
  }

  //////////////////////////////////////////////////////////////////////////////
  //
  //////////////////////////////////////////////////////////////////////////////
  void _onTap(
    BuildContext context,
    SettingDef def,
    SystemSettingEntity? existing,
  ) {
    if (def.route != null) {
      context.push(def.route!, extra: existing).then((saved) {
        if (mounted && saved == true) {
          ref.read(settingsProvider.notifier).loadAll();
        }
      });
      return;
    }

    if (existing != null) {
      context.push<bool>('/settings/edit', extra: existing).then((saved) {
        if (mounted && saved == true) {
          ref.read(settingsProvider.notifier).loadAll();
        }
      });
    } else {
      context
          .push<bool>(
            '/settings/create',
            extra: SettingCreateExtra(key: def.key, hint: def.label),
          )
          .then((saved) {
            if (mounted && saved == true) {
              ref.read(settingsProvider.notifier).loadAll();
            }
          });
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////////////////////////////
    /// Surface errors as a snackbar, then clear so they don't persist stale.
    ////////////////////////////////////////////////////////////////////////////
    ref.listen(settingsProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(next.error!)),
              ],
            ),
            backgroundColor: Pallets.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
        ref.read(settingsProvider.notifier).clearError();
      }
    });

    final state = ref.watch(settingsProvider);
    final settingMap = {for (final s in state.settings) s.key: s};
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ⚠️ Assumes settings management uses the same permission as company
    // management. If there's a dedicated permission (e.g. MANAGE_SETTINGS)
    // on the backend, swap this for that instead — canManageCompany is a
    // stand-in until confirmed.
    final currentUser = ref.watch(currentUserProvider);
    final canManageSettings = currentUser?.canManageCompany ?? false;

    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    return Scaffold(
      backgroundColor: isDark
          ? Pallets.backgroundDark
          : Pallets.backgroundLight,

      //////////////////////////////////////////////////////////////////////////
      ///  AppBar
      //////////////////////////////////////////////////////////////////////////
      appBar: AppBar(
        backgroundColor: isDark
            ? Pallets.backgroundDark
            : Pallets.backgroundLight,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
      ),

      //////////////////////////////////////////////////////////////////////////
      /// Link Create — only shown if the user can manage settings
      //////////////////////////////////////////////////////////////////////////
      floatingActionButton: canManageSettings
          ? FloatingActionButton(
              onPressed: () async {
                final saved = await context.push<bool>('/settings/create');
                if (mounted && saved == true) {
                  ref.read(settingsProvider.notifier).loadAll();
                }
              },
              backgroundColor: Pallets.surfaceElevated,
              elevation: 0,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,

      //////////////////////////////////////////////////////////////////////////
      ///  Showing nav feature config
      //////////////////////////////////////////////////////////////////////////
      body: state.isLoading && state.settings.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : (state.error != null && state.settings.isEmpty)
          ? _ErrorRetry(
              message: state.error!,
              onRetry: () => ref.read(settingsProvider.notifier).loadAll(),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: kSettingGroups.length,
              itemBuilder: (_, gi) => SettingGroupTile(
                group: kSettingGroups[gi],
                settingMap: settingMap,
                onTap: canManageSettings
                    ? (def, existing) => _onTap(context, def, existing)
                    : (_, __) {}, // read-only: tapping does nothing
              ),
            ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Error + retry state (load failure with nothing cached to show)
// ─────────────────────────────────────────────────────────────────────────────
class _ErrorRetry extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorRetry({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Pallets.errorTint,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Pallets.error.withOpacity(0.25)),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: Pallets.error,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Couldn\'t load settings',
              style: TextStyle(
                color: isDark
                    ? Pallets.textPrimaryDark
                    : Pallets.textPrimaryLight,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              style: TextStyle(
                color: isDark
                    ? Pallets.textSecondaryDark
                    : Pallets.textSecondaryLight,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Pallets.blurple.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Pallets.blurple.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.refresh_rounded,
                      color: Pallets.blurple,
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Try again',
                      style: TextStyle(
                        color: Pallets.blurple,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
