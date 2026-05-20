import 'package:flutter/material.dart';
import 'package:frontendmobile/core/components/staff_picker.dart';
import 'package:frontendmobile/features/hr/staff/domain/entities/staff_entity.dart';

class StaffDropdown extends StatelessWidget {
  final String label;
  final List<StaffEntity> staffList;
  final StaffEntity? selected;
  final ValueChanged<StaffEntity?> onChanged;

  const StaffDropdown({super.key, 
    required this.label,
    required this.staffList,
    required this.selected,
    required this.onChanged,
  });

  void _open(BuildContext context) async {
    final result = await showModalBottomSheet<StaffEntity>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => StaffPickerSheet(staffList: staffList),
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
                        selected!.name[0].toUpperCase(),
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
                      selected!.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    if (selected!.staffRole?.roleName != null)
                      Text(
                        selected!.staffRole!.roleName,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                  ],
                ),
              ),
            ] else ...[
              Icon(Icons.person_search_outlined, color: Colors.grey.shade500),
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
