import 'package:flutter/material.dart';
import 'package:frontendmobile/features/users/domain/entities/user_entity.dart';

class UserDetailScreen extends StatelessWidget {
  final UserEntity user;

  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final staff = user.staff;

    return Scaffold(
      appBar: AppBar(title: const Text("User Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // =========================================================
            // AVATAR
            // =========================================================
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue.shade100,
              backgroundImage:
                  user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                  ? NetworkImage(user.avatarUrl!)
                  : null,
              child: user.avatarUrl == null || user.avatarUrl!.isEmpty
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),

            const SizedBox(height: 16),

            Text(
              user.fullName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Text(
              "@${user.username}",
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),

            // =========================================================
            // STAFF BADGE
            // =========================================================
            if (staff != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Staff · ${staff.staffRole?.roleName ?? 'No Role'}",
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 30),

            // =========================================================
            // USER INFO CARD
            // =========================================================
            _buildSectionCard(
              title: "Account Info",
              icon: Icons.manage_accounts,
              children: [
                _buildInfoTile(
                  icon: Icons.badge,
                  title: "Role",
                  value: user.roleName ?? 'N/A',
                ),
                const Divider(),
                _buildInfoTile(
                  icon: Icons.business,
                  title: "Department",
                  value: user.departmentName ?? 'N/A',
                ),
                const Divider(),
                _buildInfoTile(
                  icon: Icons.verified_user,
                  title: "Status",
                  value: user.status,
                ),
                const Divider(),
                _buildInfoTile(
                  icon: Icons.calendar_month,
                  title: "Created At",
                  value: user.createdAt?.toString() ?? 'N/A',
                ),
                const Divider(),
                _buildInfoTile(
                  icon: Icons.update,
                  title: "Updated At",
                  value: user.updatedAt?.toString() ?? 'N/A',
                ),
              ],
            ),

            // =========================================================
            // STAFF PROFILE CARD
            // =========================================================
            if (staff != null) ...[
              const SizedBox(height: 20),
              _buildSectionCard(
                title: "Staff Profile",
                icon: Icons.badge_outlined,
                children: [
                  _buildInfoTile(
                    icon: Icons.person,
                    title: "Name",
                    value: staff.name,
                  ),

                  const Divider(),
                  _buildInfoTile(
                    icon: Icons.work,
                    title: "Staff Role",
                    value: staff.staffRole?.roleName ?? 'N/A',
                  ),

                  const Divider(),
                  _buildInfoTile(
                    icon: Icons.wc,
                    title: "Gender",
                    value: staff.gender ?? 'N/A',
                  ),
                  const Divider(),
                  _buildInfoTile(
                    icon: Icons.cake,
                    title: "Date of Birth",
                    value: staff.dateOfBirth ?? 'N/A',
                  ),
                  const Divider(),
                  _buildInfoTile(
                    icon: Icons.phone,
                    title: "Phone",
                    value: staff.phone ?? 'N/A',
                  ),
                  const Divider(),
                  _buildInfoTile(
                    icon: Icons.email,
                    title: "Email",
                    value: staff.email ?? 'N/A',
                  ),
                  const Divider(),
                  _buildInfoTile(
                    icon: Icons.location_on,
                    title: "Address",
                    value: staff.address ?? 'N/A',
                  ),
                  if (staff.age != null) ...[
                    const Divider(),
                    _buildInfoTile(
                      icon: Icons.numbers,
                      title: "Age",
                      value: "${staff.age}",
                    ),
                  ],
                ],
              ),
            ] else ...[
              // =========================================================
              // NO STAFF PROFILE
              // =========================================================
              const SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.grey.shade400),
                      const SizedBox(width: 12),
                      Text(
                        "No staff profile assigned",
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // SECTION CARD BUILDER
  // =========================================================
  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  // =========================================================
  // INFO TILE BUILDER
  // =========================================================
  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(value),
            ],
          ),
        ),
      ],
    );
  }
}
