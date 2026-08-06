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

    const items = [
      (Icons.settings_outlined, 'Settings', 'settings'),
      (Icons.person_outline_rounded, 'Profile curation', 'profile'),
      (Icons.edit_outlined, 'Drafts', 'drafts'),
      (Icons.history_rounded, 'History', 'history'),
      (Icons.bookmark_outline_rounded, 'Saved', 'saved'),
    ];

    // SingleChildScrollView fixes the 68px RenderFlex overflow on
    // smaller screens / when keyboard or safe-area eats space.
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ────────────────────────────────────────────────
          // Header
          // ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 12, 8),
            child: Row(
              children: [
                Text(
                  'My Account',
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.close_rounded, color: textSecondary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          Divider(color: dividerColor, height: 1),

          // ────────────────────────────────────────────────
          // Menu items
          // ────────────────────────────────────────────────
          ...items.map((item) {
            return ListTile(
              leading: Icon(item.$1, color: textSecondary, size: 22),
              title: Text(
                item.$2,
                style: TextStyle(color: textPrimary, fontSize: 15),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              onTap: () {
                // Close the sheet first...
                Navigator.of(context).pop();
                // ...then notify the caller. No pop(value) => no cast crash,
                // and no risk of racing the navigator lock.
                onItemSelected(item.$3);
              },
            );
          }),

          Divider(color: dividerColor, height: 1),

          // ────────────────────────────────────────────────
          // Logout
          // ────────────────────────────────────────────────
          ListTile(
            leading: const Icon(
              Icons.logout_rounded,
              color: Colors.redAccent,
              size: 22,
            ),
            title: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
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

              // Close the account menu itself.
              if (context.mounted) {
                Navigator.of(context).pop();
              }

              // Let the pop's transition/frame settle before touching
              // the Navigator again — this is what avoids the
              // '!_debugLocked' assertion.
              await Future.delayed(Duration.zero);

              // Now safe to log out and navigate.
              await ref.read(authProvider.notifier).logout();

              if (context.mounted) {
                context.go('/login');
              }
            },
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 12),
        ],
      ),
    );
  }
}
