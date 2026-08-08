import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/users/domain/entities/role_entity.dart';
import 'package:frontendmobile/features/users/presentation/provider/user_notifier.dart';
import 'package:go_router/go_router.dart';

class RolePermissionsScreen extends ConsumerStatefulWidget {
  final RoleEntity role;
  const RolePermissionsScreen({super.key, required this.role});

  @override
  ConsumerState<RolePermissionsScreen> createState() =>
      _RolePermissionsScreenState();
}

class _RolePermissionsScreenState
    extends ConsumerState<RolePermissionsScreen> {
  late Set<String> _selectedCodes;
  bool _isSaving = false;

  // TODO: replace with a fetched list from GET /permissions/all
  static const _allPermissionCodes = [
    'view_users',
    'manage_users',
    'manage_roles',
    'manage_departments',
    'approve_leave',
    'view_team_leave',
  ];

  @override
  void initState() {
    super.initState();
    _selectedCodes = widget.role.permissions.map((p) => p.code).toSet();
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    await ref
        .read(userNotifierProvider.notifier)
        .setRolePermissions(widget.role.id, _selectedCodes.toList());
    if (!mounted) return;
    setState(() => _isSaving = false);

    final error = ref.read(userNotifierProvider).valueOrNull?.errorMessage;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Pallets.error),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permissions updated'),
          backgroundColor: Pallets.success,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? Pallets.backgroundDark : Pallets.backgroundLight;
    final surface = isDark ? Pallets.surfaceDark : Pallets.surfaceLight;
    final cardBg = isDark ? Pallets.surfaceCard : Pallets.surfaceLight;
    final border = isDark ? Pallets.borderDark : Pallets.borderLight;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final iconBg = isDark
        ? Colors.white.withOpacity(0.07)
        : Colors.black.withOpacity(0.05);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: surface,
        surfaceTintColor: Pallets.transparent,
        elevation: 0,
        scrolledUnderElevation: 1,
        shape: Border(bottom: BorderSide(color: border, width: 1)),
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(
              Icons.chevron_left_rounded,
              color: textPrimary,
              size: 22,
            ),
          ),
        ),
        title: Text(
          widget.role.roleName,
          style: TextStyle(
            color: textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Permissions',
            style: TextStyle(
              color: textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: border),
            ),
            child: Column(
              children: _allPermissionCodes.map((code) {
                final isLast = code == _allPermissionCodes.last;
                return Column(
                  children: [
                    CheckboxListTile(
                      value: _selectedCodes.contains(code),
                      onChanged: (checked) => setState(() {
                        checked! ? _selectedCodes.add(code) : _selectedCodes.remove(code);
                      }),
                      title: Text(
                        code,
                        style: TextStyle(
                          color: textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      activeColor: Pallets.blurple,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    if (!isLast) Divider(height: 1, color: border),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: Pallets.blurple,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Save permissions',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}