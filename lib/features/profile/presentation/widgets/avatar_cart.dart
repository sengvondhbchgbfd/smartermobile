import 'package:flutter/material.dart';
import 'package:frontendmobile/features/profile/domain/entities/profile_entity.dart';

class AvatarCard extends StatelessWidget {
  final ProfileEntity profile;
  const AvatarCard({super.key, required this.profile});
  @override
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Widget build(BuildContext context) {
    const double radius = 48;
    const double badgeSize = 16;
    return SizedBox(
      width: radius * 2 + 4,
      height: radius * 2 + 4,
      child: Stack(
        children: [
          //////////////////////////////////////////////////////////////////////
          // Avatar circle
          //////////////////////////////////////////////////////////////////////
          CircleAvatar(
            radius: radius,
            backgroundColor: const Color(0xFF36393F),
            backgroundImage:
                (profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty)
                ? NetworkImage(profile.avatarUrl!)
                : null,
            child: (profile.avatarUrl == null || profile.avatarUrl!.isEmpty)
                ? Text(
                    profile.fullName.isNotEmpty
                        ? profile.username[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
          //////////////////////////////////////////////////////////////////////
          // Online badge (bottom-right)
          //////////////////////////////////////////////////////////////////////
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              width: badgeSize,
              height: badgeSize,
              decoration: BoxDecoration(
                color: const Color(0xFF23A55A),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF1E1F22), width: 3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
