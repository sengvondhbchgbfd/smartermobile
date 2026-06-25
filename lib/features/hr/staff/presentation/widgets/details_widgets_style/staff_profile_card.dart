import 'package:flutter/material.dart';
import 'package:frontendmobile/features/hr/staff/domain/entities/staff_entity.dart';

class ProfileCard extends StatelessWidget {
  final StaffEntity staff;
  final Color surface;
  final Color border;
  final Color muted;
  final VoidCallback onPickAvatar;
  const ProfileCard({
    super.key,
    required this.staff,
    required this.surface,
    required this.border,
    required this.muted,
    required this.onPickAvatar,
  });

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: 0.5),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              //////////////////////////////////////////////////////////////////
              ///
              //////////////////////////////////////////////////////////////////
              CircleAvatar(
                radius: 42,
                backgroundColor: const Color(0xFFB5D4F4),
                backgroundImage: staff.avatarUrl != null
                    ? NetworkImage(staff.avatarUrl!)
                    : null,
                child: staff.avatarUrl == null
                    ? Text(
                        staff.name.isNotEmpty
                            ? staff.name[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF185FA5),
                        ),
                      )
                    : null,
              ),
              //////////////////////////////////////////////////////////////////
              ///
              //////////////////////////////////////////////////////////////////
              Positioned(
                bottom: -2,
                right: -2,
                child: GestureDetector(
                  onTap: onPickAvatar,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black87,
                      border: Border.all(color: surface, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      size: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          //////////////////////////////////////////////////////////////////////
          ///
          //////////////////////////////////////////////////////////////////////
          const SizedBox(height: 12),
          Text(
            staff.name,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 2),
          //////////////////////////////////////////////////////////////////////
          ///
          //////////////////////////////////////////////////////////////////////
          Text(
            staff.staffRole?.roleName ?? 'No role assigned',
            style: TextStyle(fontSize: 13, color: muted),
          ),
          const SizedBox(height: 10),
          //////////////////////////////////////////////////////////////////////
          ///
          //////////////////////////////////////////////////////////////////////
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF3DE),
              borderRadius: BorderRadius.circular(8),
            ),

            ////////////////////////////////////////////////////////////////////
            ///
            ////////////////////////////////////////////////////////////////////
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircleAvatar(radius: 3, backgroundColor: Color(0xFF27500A)),
                SizedBox(width: 6),
                Text(
                  'Active',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF27500A),
                  ),
                ),
              ],
            ),

            ////////////////////////////////////////////////////////////////////
            ///
            ////////////////////////////////////////////////////////////////////
          ),
        ],
      ),
    );
  }
}
