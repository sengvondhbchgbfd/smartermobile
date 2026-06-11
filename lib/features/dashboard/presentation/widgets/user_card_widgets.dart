import 'package:flutter/material.dart';
import 'package:frontendmobile/features/profile/domain/entities/profile_entity.dart';

const Color _gradient1 = Color.fromRGBO(187, 63, 221, 1);
const Color _gradient2 = Color.fromRGBO(251, 109, 169, 1);

class UserCardWidget extends StatelessWidget {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  final ProfileEntity profile;
  final VoidCallback? onSettingsTap;
  const UserCardWidget({super.key, required this.profile, this.onSettingsTap});
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    final displayRole = _capitalize(profile.role);
    final displayDept = profile.department ?? "No Department";
    final initails = _initials(profile.fullName);
    final hasAvatar =
        profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty;

    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    return Container(
      padding: const EdgeInsets.all(18),

      //////////////////////////////////////////////////////////////////////////
      ///
      //////////////////////////////////////////////////////////////////////////
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_gradient1, _gradient2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),

      //////////////////////////////////////////////////////////////////////////
      ///  Column Top
      //////////////////////////////////////////////////////////////////////////
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //////////////////////////////////////////////////////////////////////////
          ///
          //////////////////////////////////////////////////////////////////////////
          Row(
            children: [
              ///////////////////////////////////////
              /// Avatar
              //////////////////////////////////////
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white.withOpacity(0.2),
                backgroundImage: hasAvatar
                    ? NetworkImage(profile.avatarUrl!)
                    : null,
                child: !hasAvatar
                    ? Text(
                        initails,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      )
                    : null,
              ),

              //////////////////////////////////////////////////////////////////////
              const SizedBox(width: 14),
              //////////////////////////////////////////////////////////////////////
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.fullName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    ////////////////////////////////////////////////////////////
                    const SizedBox(height: 3),
                    ////////////////////////////////////////////////////////////
                    Text(
                      '@${profile.username}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              //////////////////////////////////////////////////////////////////////
              /// On Setting
              //////////////////////////////////////////////////////////////////////
              GestureDetector(
                onTap: onSettingsTap,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.settings_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),

          //////////////////////////////////////////////////////////
          ///
          //////////////////////////////////////////////////////////
          const SizedBox(height: 14),
          Divider(color: Colors.white.withOpacity(0.2), height: 1),
          const SizedBox(height: 14),

          //////////////////////////////////////////////////
          // Role + Department
          /////////////////////////////////////////////////
          Row(
            children: [
              //--------------
              //Row
              //--------------
              _InfoChip(icon: Icons.badge_outlined, label: displayRole),
              const SizedBox(width: 8),
              //-------------
              // Department
              //------------
              Flexible(
                child: _InfoChip(
                  icon: Icons.business_outlined,
                  label: displayDept,
                ),
              ),

              const Spacer(),
              //-----------
              // status
              //----------
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                //------------------------
                //
                //------------------------
                decoration: BoxDecoration(
                  color: profile.status == "active"
                      ? const Color(0xFF4ADE80).withOpacity(0.2)
                      : Colors.redAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: profile.status == 'active'
                        ? const Color(0xFF4ADE80)
                        : Colors.redAccent,
                    width: 1,
                  ),
                ),
                //----------------------
                //
                //----------------------
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.circle,
                      size: 6,
                      color: profile.status == 'active'
                          ? const Color(0xFF4ADE80)
                          : Colors.redAccent,
                    ),
                    //---------------------------
                    const SizedBox(width: 4),
                    //---------------------------
                    Text(
                      _capitalize(profile.status),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: profile.status == 'active'
                            ? const Color(0xFF4ADE80)
                            : Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),

              /////////////////////////////////////////////////////////////////
              ////Manager Badge
              ////////////////////////////////////////////////////////////////
              if (profile.isManager) ...[
                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star_rounded, size: 12, color: Colors.amber),

                      SizedBox(width: 4),
                      Text(
                        "Manager",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).toLowerCase();
}

///////////////////////////////////////////////////////////////////////////
///
///////////////////////////////////////////////////////////////////////////

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.15),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: Colors.white70),
        const SizedBox(width: 4),
        Flexible(
          // ✅ allows text to shrink
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    ),
  );
}
