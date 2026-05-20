import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/profile/domain/entities/profile_entity.dart';
import 'package:frontendmobile/features/profile/presentation/providers/profile_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final profileState = ref.watch(profileNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark
            ? Pallets.backgroundDark
            : Pallets.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          color: isDark
              ? Pallets.textSecondaryDark
              : Pallets.textSecondaryLight,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDark ? Pallets.textPrimaryDark : Pallets.textPrimaryLight,
          ),
        ),
        centerTitle: true,
      ),
      body: profileState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Pallets.gradient2,
          ),
        ),
        error: (e, _) => _ErrorView(
          message: e.toString(),
          onRetry: () => ref.read(profileNotifierProvider.notifier).refresh(),
        ),
        data: (profile) => _ProfileBody(profile: profile),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// BODY
// ─────────────────────────────────────────────

class _ProfileBody extends StatelessWidget {
  final ProfileEntity profile;
  const _ProfileBody({required this.profile});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: [
          _AvatarCard(profile: profile),
          const SizedBox(height: 12),
          _InfoCard(profile: profile),
          const SizedBox(height: 12),
          if (profile.permissions.isNotEmpty)
            _PermissionsCard(permissions: profile.permissions),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// AVATAR CARD
// ─────────────────────────────────────────────

class _AvatarCard extends StatelessWidget {
  final ProfileEntity profile;
  const _AvatarCard({required this.profile});

  String get _initials {
    final parts = profile.fullName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return profile.fullName.isNotEmpty
        ? profile.fullName[0].toUpperCase()
        : '?';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Pallets.surfaceDark : Pallets.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Pallets.borderDark : Pallets.borderLight,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          // Avatar circle with gradient border
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Pallets.gradient1, Pallets.gradient2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              _initials,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Name + status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.fullName,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? Pallets.textPrimaryDark
                        : Pallets.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 6),
                _StatusBadge(status: profile.status),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// STATUS BADGE
// ─────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  Color get _bgColor {
    switch (status.toLowerCase()) {
      case 'active':
        return Pallets.success.withOpacity(0.15);
      case 'inactive':
        return Pallets.inactive.withOpacity(0.15);
      default:
        return Pallets.inactive.withOpacity(0.15);
    }
  }

  Color get _textColor {
    switch (status.toLowerCase()) {
      case 'active':
        return Pallets.success;
      case 'inactive':
        return Pallets.inactive;
      default:
        return Pallets.inactive;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status[0].toUpperCase() + status.substring(1),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _textColor,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// INFO CARD
// ─────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final ProfileEntity profile;
  const _InfoCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? Pallets.surfaceDark : Pallets.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Pallets.borderDark : Pallets.borderLight,
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.person_outline_rounded,
            label: 'Username',
            value: profile.username,
          ),
          _RowDivider(),
          _InfoRow(
            icon: Icons.shield_outlined,
            label: 'Role',
            value: profile.role,
          ),
          _RowDivider(),
          if (profile.departmentId != null) ...[
            _InfoRow(
              icon: Icons.business_outlined,
              label: 'Department',
              value: 'Dept #${profile.departmentId}',
            ),
            _RowDivider(),
          ],
          _InfoRow(
            icon: Icons.group_outlined,
            label: 'Manager',
            value: profile.isManager ? 'Yes' : 'No',
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// INFO ROW
// ─────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: isDark
                ? Pallets.textSecondaryDark
                : Pallets.textSecondaryLight,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? Pallets.textSecondaryDark
                  : Pallets.textSecondaryLight,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? Pallets.textPrimaryDark
                  : Pallets.textPrimaryLight,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PERMISSIONS CARD
// ─────────────────────────────────────────────

class _PermissionsCard extends StatelessWidget {
  final List<String> permissions;
  const _PermissionsCard({required this.permissions});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Pallets.surfaceDark : Pallets.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Pallets.borderDark : Pallets.borderLight,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Permissions',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? Pallets.textSecondaryDark
                  : Pallets.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: permissions
                .map((p) => _PermissionChip(label: p))
                .toList(),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PERMISSION CHIP
// ─────────────────────────────────────────────

class _PermissionChip extends StatelessWidget {
  final String label;
  const _PermissionChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Pallets.gradient2.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Pallets.gradient2,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ROW DIVIDER
// ─────────────────────────────────────────────

class _RowDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Divider(
      height: 0.5,
      thickness: 0.5,
      color: isDark ? Pallets.borderDark : Pallets.borderLight,
      indent: 16,
      endIndent: 16,
    );
  }
}

// ─────────────────────────────────────────────
// ERROR VIEW
// ─────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 40,
              color: Pallets.error,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? Pallets.textSecondaryDark
                    : Pallets.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                backgroundColor: Pallets.gradient2.withOpacity(0.15),
                foregroundColor: Pallets.gradient2,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
