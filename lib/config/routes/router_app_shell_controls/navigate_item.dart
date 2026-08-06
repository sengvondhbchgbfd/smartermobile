import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class NavItem extends StatelessWidget {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  final IconData icon;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.icon,
    required this.isActive,
    required this.isDark,
    required this.onTap,
  });

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    final activeColor = Pallets.blurple;
    final inactiveColor = isDark
        ? Pallets.textMuted
        : Pallets.textSecondaryLight;

    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          width: isActive ? 44 : 36,
          height: 36,
          decoration: BoxDecoration(
            color: isActive
                ? activeColor.withOpacity(0.14)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            size: isActive ? 23 : 21,
            color: isActive ? activeColor : inactiveColor,
          ),
        ),
      ),
    );
  }
}
