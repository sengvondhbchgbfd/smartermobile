import 'package:flutter/material.dart';
import 'package:frontendmobile/core/components/sheet_hand.dart';
import 'package:frontendmobile/features/users/domain/entities/user_entity.dart';

class UserPickerSheet extends StatefulWidget {
  final List<UserEntity> userList;
  const UserPickerSheet({super.key, required this.userList});

  @override
  State<UserPickerSheet> createState() => _UserPickerSheetState();
}

class _UserPickerSheetState extends State<UserPickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = widget.userList
        .where(
          (u) =>
              u.fullName.toLowerCase().contains(_query.toLowerCase()) ||
              u.username.toLowerCase().contains(_query.toLowerCase()) ||
              (u.roleName ?? '').toLowerCase().contains(_query.toLowerCase()) ||
              (u.departmentName ?? '').toLowerCase().contains(
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
                hintText: 'Search by name, username, role…',
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
                ? const Center(child: Text('No users found.'))
                : ListView.builder(
                    controller: controller,
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final u = filtered[i];
                      final hasStaff = u.staff != null;
                      return ListTile(
                        leading: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CircleAvatar(
                              backgroundImage: u.avatarUrl != null
                                  ? NetworkImage(u.avatarUrl!)
                                  : null,
                              backgroundColor:
                                  theme.colorScheme.primaryContainer,
                              child: u.avatarUrl == null
                                  ? Text(
                                      u.fullName[0].toUpperCase(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: theme
                                            .colorScheme
                                            .onPrimaryContainer,
                                      ),
                                    )
                                  : null,
                            ),
                            // ── No staff badge ──
                            if (!hasStaff)
                              Positioned(
                                right: -2,
                                bottom: -2,
                                child: Container(
                                  width: 14,
                                  height: 14,
                                  decoration: const BoxDecoration(
                                    color: Colors.orange,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.warning_amber_rounded,
                                    size: 10,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        title: Text(
                          u.fullName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          [
                            u.username,
                            u.roleName,
                            if (!hasStaff) '⚠ No staff profile',
                          ].where((v) => v != null && v.isNotEmpty).join(' · '),
                          style: TextStyle(
                            fontSize: 12,
                            color: hasStaff
                                ? Colors.grey.shade500
                                : Colors.orange.shade700,
                          ),
                        ),
                        onTap: () => Navigator.pop(context, u),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
