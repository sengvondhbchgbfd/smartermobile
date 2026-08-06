import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
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
    ///
    ////////////////////////////////////////////////////////////////////////////
    final state = ref.watch(settingsProvider);
    final settingMap = {for (final s in state.settings) s.key: s};
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
      /// Link Create
      //////////////////////////////////////////////////////////////////////////
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final saved = await context.push<bool>('/settings/create');
          if (mounted && saved == true) {
            ref.read(settingsProvider.notifier).loadAll();
          }
        },

        backgroundColor: Pallets.surfaceElevated,
        elevation: 0,
        child: const Icon(Icons.add, color: Colors.white),
      ),

      //////////////////////////////////////////////////////////////////////////
      ///  Showing nav feature config
      //////////////////////////////////////////////////////////////////////////
      body: state.isLoading && state.settings.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: kSettingGroups.length,
              itemBuilder: (_, gi) => SettingGroupTile(
                group: kSettingGroups[gi],
                settingMap: settingMap,
                onTap: (def, existing) => _onTap(context, def, existing),
              ),
            ),
    );
  }
}
