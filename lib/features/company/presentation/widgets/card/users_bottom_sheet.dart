import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/company/presentation/widgets/card/user_list_tile.dart';
import 'package:frontendmobile/features/company/presentation/widgets/card/user_state_card.dart';

class UsersBottomSheet extends StatelessWidget {
  final List<StaffPreview> users;
  final int maxUsers;
  const UsersBottomSheet({
    super.key,
    required this.users,
    required this.maxUsers,
  });
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (_, controller) => Column(
        children: [
          ////////////////////////////////////////////////////////////////
          // ── Handle ──
          ////////////////////////////////////////////////////////////////
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Pallets.borderDark,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),

          ////////////////////////////////////////////////////////////////
          // ── Header ──
          ////////////////////////////////////////////////////////////////
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Text(
                  'Active in',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Pallets.borderDark,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ////////////////////////////////////////////////////////////////
          // ── Summary row ──
          ////////////////////////////////////////////////////////////////
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Pallets.backgroundDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Pallets.borderDark),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.people_outline,
                    color: Pallets.gradient2,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Showing ${users.length} of $maxUsers members',
                    style: TextStyle(
                      color: Pallets.textSecondaryDark,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ////////////////////////////////////////////////////////////////
          // ── User List ──
          ////////////////////////////////////////////////////////////////
          Expanded(
            child: ListView.separated(
              controller: controller,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: users.length,
              separatorBuilder: (_, __) =>
                  Divider(color: Pallets.borderDark, height: 1),
              itemBuilder: (_, i) => UserListTile(user: users[i]),
            ),
          ),
          ////////////////////////////////////////////////////////////////
          ///
          ////////////////////////////////////////////////////////////////
        ],
      ),
    );
  }
}
