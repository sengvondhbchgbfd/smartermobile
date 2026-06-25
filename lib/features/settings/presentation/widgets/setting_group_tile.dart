import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/settings/domain/entities/system_setting_entity.dart';
import 'package:frontendmobile/features/settings/domain/models/setting_groups.dart';
import 'package:frontendmobile/features/settings/presentation/widgets/setting_row_tile.dart';

class SettingGroupTile extends StatelessWidget {
  final SettingGroup group;
  final Map<String, SystemSettingEntity> settingMap;
  final void Function(SettingDef, SystemSettingEntity?) onTap;

  const SettingGroupTile({
    super.key,
    required this.group,
    required this.settingMap,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 28, 16, 8),
          child: Text(
            group.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color:
                  isDark // ← use it here
                  ? Colors.white.withOpacity(0.4)
                  : Colors.black.withOpacity(0.4),
              letterSpacing: 0.9,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isDark
                ? Pallets.surfaceCard
                : Pallets.surfaceLight, // ← theme-aware
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Column(
              children: group.items.map((def) {
                final existing = settingMap[def.key];
                final isLast = def == group.items.last;
                return SettingRowTile(
                  def: def,
                  existing: existing,
                  isLast: isLast,
                  onTap: () => onTap(def, existing),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
