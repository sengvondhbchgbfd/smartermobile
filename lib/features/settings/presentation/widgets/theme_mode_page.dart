import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/core/themes/theme_provider.dart';

class ThemeModePage extends ConsumerWidget {
  const ThemeModePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMode = ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final surface = isDark ? Pallets.surfaceDark : Pallets.surfaceLight;
    final border = isDark
        ? const Color.fromARGB(255, 52, 51, 67)
        : Pallets.borderLight;

    final options = [
      _ThemeOption(
        mode: ThemeMode.system,
        label: 'System Default',
        subtitle: 'Follows your device setting',
        icon: Icons.brightness_auto_rounded,
      ),
      _ThemeOption(
        mode: ThemeMode.light,
        label: 'Light Mode',
        subtitle: 'Always use light theme',
        icon: Icons.light_mode_rounded,
      ),
      _ThemeOption(
        mode: ThemeMode.dark,
        label: 'Dark Mode',
        subtitle: 'Always use dark theme',
        icon: Icons.dark_mode_rounded,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme'),
        backgroundColor: isDark
            ? Pallets.backgroundDark
            : Pallets.backgroundLight,
        foregroundColor: textPrimary,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: options.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final option = options[index];
          final isSelected = currentMode == option.mode;

          return GestureDetector(
            onTap: () {
              ref.read(themeModeProvider.notifier).setMode(option.mode);
              Navigator.pop(context);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isSelected
                    ? Pallets.gradient2.withOpacity(0.12)
                    : surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? Pallets.gradient2 : border,
                  width: isSelected ? 1.8 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? Pallets.gradient2.withOpacity(0.2)
                          : (isDark
                                ? Pallets.backgroundDark
                                : Pallets.backgroundLight),
                    ),
                    child: Icon(
                      option.icon,
                      color: isSelected ? Pallets.gradient2 : textSecondary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          option.label,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Pallets.gradient2 : textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          option.subtitle,
                          style: TextStyle(fontSize: 13, color: textSecondary),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Pallets.gradient2,
                      size: 22,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ThemeOption {
  final ThemeMode mode;
  final String label;
  final String subtitle;
  final IconData icon;

  const _ThemeOption({
    required this.mode,
    required this.label,
    required this.subtitle,
    required this.icon,
  });
}
