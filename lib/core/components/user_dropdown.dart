import 'package:flutter/material.dart';
import 'package:frontendmobile/core/components/user_picker_sheet.dart';
import 'package:frontendmobile/features/users/domain/entities/user_entity.dart';

class UserDropdown extends StatelessWidget {
  final String label;
  final List<UserEntity> userList;
  final UserEntity? selected;
  final ValueChanged<UserEntity?> onChanged;

  const UserDropdown({super.key, 
    required this.label,
    required this.userList,
    required this.selected,
    required this.onChanged,
  });

  void _open(BuildContext context) async {
    final result = await showModalBottomSheet<UserEntity>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => UserPickerSheet(userList: userList),
    );
    if (result != null) onChanged(result);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => _open(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (selected != null) ...[
              CircleAvatar(
                radius: 16,
                backgroundImage: selected!.avatarUrl != null
                    ? NetworkImage(selected!.avatarUrl!)
                    : null,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: selected!.avatarUrl == null
                    ? Text(
                        selected!.fullName[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selected!.fullName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    if (selected!.roleName != null)
                      Text(
                        selected!.roleName!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    // ── Warn if no linked staff profile ──
                    if (selected!.staff == null)
                      Text(
                        '⚠ No linked staff profile',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.orange.shade700,
                        ),
                      ),
                  ],
                ),
              ),
            ] else ...[
              Icon(Icons.manage_accounts_outlined, color: Colors.grey.shade500),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ),
            ],
            Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
          ],
        ),
      ),
    );
  }
}
