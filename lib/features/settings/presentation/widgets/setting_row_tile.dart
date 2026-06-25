import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/core/themes/theme_provider.dart';
import 'package:frontendmobile/features/settings/domain/entities/system_setting_entity.dart';
import 'package:frontendmobile/features/settings/domain/models/setting_groups.dart';

class SettingRowTile extends StatelessWidget {
  final SettingDef def;
  final SystemSettingEntity? existing;
  final bool isLast;
  final VoidCallback onTap;

  const SettingRowTile({
    super.key,
    required this.def,
    required this.existing,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // ← remove WidgetRef ref
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final iconColor = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final dividerColor = isDark ? Pallets.borderDark : Pallets.borderLight;

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: Pallets.borderDark.withOpacity(0.3),
            highlightColor: Pallets.borderDark.withOpacity(0.15),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(def.icon, size: 22, color: iconColor),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      def.label,
                      style: TextStyle(
                        fontSize: 16,
                        color: textPrimary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  _trailing(isDark, textSecondary),
                ],
              ),
            ),
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: 54,
            endIndent: 0,
            color: dividerColor.withOpacity(0.5),
          ),
      ],
    );
  }

  Widget _trailing(bool isDark, Color textSecondary) {
    if (def.key == 'dark_mode') {
      return Consumer(
        builder: (context, ref, _) {
          final mode = ref.watch(themeModeProvider);
          final label = switch (mode) {
            ThemeMode.dark => 'Dark',
            ThemeMode.light => 'Light',
            ThemeMode.system => 'System',
            _ => 'System',
          };
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: TextStyle(fontSize: 15, color: textSecondary)),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right,
                size: 18,
                color: isDark ? Pallets.inactive : Pallets.textSecondaryLight,
              ),
            ],
          );
        },
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (existing?.value != null) ...[
          Text(
            existing!.value!,
            style: TextStyle(fontSize: 15, color: textSecondary),
          ),
          const SizedBox(width: 4),
        ],
        Icon(
          Icons.chevron_right,
          size: 18,
          color: isDark ? Pallets.inactive : Pallets.textSecondaryLight,
        ),
      ],
    );
  }
}
