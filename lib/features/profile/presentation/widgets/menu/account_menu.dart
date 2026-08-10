import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/auth/presentation/providers/auth_provider.dart';

class AccountMenu extends ConsumerWidget {
  final void Function(String action) onItemSelected;

  const AccountMenu({super.key, required this.onItemSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final dividerColor = isDark ? Pallets.borderDark : Pallets.borderLight;
    final surface = isDark ? Pallets.surfaceDark : Pallets.surfaceLight;
    final chipBg = isDark
        ? Colors.white.withOpacity(0.06)
        : Colors.black.withOpacity(0.04);

    const items = [
      (
        Icons.settings_outlined,
        'Settings',
        'Preferences & account',
        'settings',
      ),
      (Icons.history_rounded, 'My Activity', 'Your recent activity', 'history'),
    ];

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ────────────────────────────────────────────────
          // Drag handle
          // ────────────────────────────────────────────────
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // ────────────────────────────────────────────────
          // Header
          // ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 12, 4),
            child: Row(
              children: [
                Text(
                  'My Account',
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: textSecondary,
                    size: 22,
                  ),
                  splashRadius: 20,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
          Divider(color: dividerColor, height: 1),
          const SizedBox(height: 4),

          // ────────────────────────────────────────────────
          // Menu items
          // ────────────────────────────────────────────────
          ...items.map((item) {
            return ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: chipBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.$1, color: textSecondary, size: 20),
              ),
              title: Text(
                item.$2,
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                item.$3,
                style: TextStyle(color: textSecondary, fontSize: 12.5),
              ),
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: textSecondary.withOpacity(0.6),
                size: 20,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 2,
              ),
              onTap: () {
                Navigator.of(context).pop();
                onItemSelected(item.$4);
              },
            );
          }),

          const SizedBox(height: 4),
          Divider(color: dividerColor, height: 1),

          // ────────────────────────────────────────────────
          // Logout
          // ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
            child: Material(
              color: Colors.redAccent.withOpacity(isDark ? 0.12 : 0.08),
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to log out?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          child: const Text(
                            'Logout',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirmed != true) return;

                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }

                  await Future.delayed(Duration.zero);

                  await ref.read(authProvider.notifier).logout();

                  if (context.mounted) {
                    context.go('/login');
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout_rounded,
                        color: Colors.redAccent,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}
