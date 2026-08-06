import 'package:flutter/material.dart';
import 'package:frontendmobile/config/routes/router_app_shell_controls/fall_back_avatar.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class ProfileNavItem extends StatelessWidget {
  ////////////////////////////////////////////////////////////////
  ///
  ///////////////////////////////////////////////////////////////
  final String? avatarUrl;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;
  const ProfileNavItem({
    super.key,
    required this.avatarUrl,
    required this.isActive,
    required this.isDark,
    required this.onTap,
  });

  ////////////////////////////////////////////////////////////////
  ///
  ///////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////////////
    ///
    ///////////////////////////////////////////////////////////
    final activeColor = Pallets.blurple;
    /////////////////////////////////////////////////////////////
    ///
    ///////////////////////////////////////////////////////////

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          width: 34,
          height: 34,

          //////////////////////////////
          ///
          //////////////////////////////
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? activeColor : Colors.transparent,
              width: 2,
            ),
          ),

          //////////////////////////////
          ///
          //////////////////////////////
          child: ClipOval(
            child: avatarUrl != null && avatarUrl!.isNotEmpty
                ? Image.network(
                    avatarUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        FallbackAvatar(isActive: isActive),
                  )
                : FallbackAvatar(isActive: isActive),
          ),

          //////////////////////////////
          ///
          //////////////////////////////
        ),
      ),
    );
  }
}
