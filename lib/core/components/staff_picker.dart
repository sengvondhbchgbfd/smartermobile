import 'package:flutter/material.dart';
import 'package:frontendmobile/core/components/sheet_hand.dart';
import 'package:frontendmobile/features/hr/staff/domain/entities/staff_entity.dart';

class StaffPickerSheet extends StatefulWidget {
  final List<StaffEntity> staffList;
  const StaffPickerSheet({super.key, required this.staffList});

  @override
  State<StaffPickerSheet> createState() => _StaffPickerSheetState();
}

class _StaffPickerSheetState extends State<StaffPickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = widget.staffList
        .where(
          (s) =>
              s.name.toLowerCase().contains(_query.toLowerCase()) ||
              (s.email ?? '').toLowerCase().contains(_query.toLowerCase()) ||
              (s.staffRole?.roleName ?? '').toLowerCase().contains(
                _query.toLowerCase(),
              ),
        )
        .toList();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.92,
      minChildSize: 0.4,
      builder: (_, controller) => Column(
        children: [
          SheetHand(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search by name, role, email…',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('No staff found.'))
                : ListView.builder(
                    controller: controller,
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final s = filtered[i];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: s.avatarUrl != null
                              ? NetworkImage(s.avatarUrl!)
                              : null,
                          backgroundColor: theme.colorScheme.primaryContainer,
                          child: s.avatarUrl == null
                              ? Text(
                                  s.name[0].toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onPrimaryContainer,
                                  ),
                                )
                              : null,
                        ),
                        title: Text(
                          s.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          [
                            s.staffRole?.roleName,
                            s.email,
                          ].where((v) => v != null && v.isNotEmpty).join(' · '),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        onTap: () => Navigator.pop(context, s),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
