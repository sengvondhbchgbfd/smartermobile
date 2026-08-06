import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontendmobile/config/routes/Notched_bar_clipper.dart';
import 'package:frontendmobile/config/routes/route_names.dart';
import 'package:frontendmobile/config/routes/router_app_shell_controls/constance.dart';
import 'package:frontendmobile/config/routes/router_app_shell_controls/navigate_item.dart';
import 'package:frontendmobile/config/routes/router_app_shell_controls/profile_navigate_item.dart';
import 'package:frontendmobile/config/routes/router_app_shell_controls/scann_button.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class FloatingNavBar extends StatelessWidget {
  final bool isDark;
  final int currentIndex;
  final String? avatarUrl;
  final void Function(int) onTap;

  const FloatingNavBar({
    super.key,
    required this.isDark,
    required this.currentIndex,
    required this.avatarUrl,
    required this.onTap,
  });

  /////////////////////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    ///////////////////////////////////////////////////////////
    ///
    //////////////////////////////////////////////////////////
    final surfaceColor = isDark
        ? Pallets.surfaceCard.withOpacity(0.72)
        : Pallets.surfaceLight.withOpacity(0.85);
    final borderColor = (isDark ? Colors.white : Colors.black).withOpacity(
      0.06,
    );
    final scanIndex = navItems.indexWhere((e) => e.$1 == '__scan__');
    const barHeight = 64.0;
    const notchRadius = 38.0;
    const floatUp = 26.0;

    /////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////

    return LayoutBuilder(
      builder: (context, constraints) {
        /////////////////////////////////////////////////////////////
        ///
        ////////////////////////////////////////////////////////////
        final barWidth = constraints.maxWidth;
        final notchCenterX = barWidth / 2;
        /////////////////////////////////////////////////////////////
        ///
        ////////////////////////////////////////////////////////////

        return SizedBox(
          height: barHeight + floatUp,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              //////////////////////////////////////////////////////////////////
              // ---- Notched bar background ----
              //////////////////////////////////////////////////////////////////
              ClipPath(
                clipper: NotchedBarClipper(
                  notchRadius: notchRadius,
                  notchCenterX: notchCenterX,
                ),
                ////////////////////////////////////////////////////////////////
                ///
                ////////////////////////////////////////////////////////////////
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: Container(
                    height: barHeight,
                    ////////////////////////////////////////////////////////////
                    ///
                    ////////////////////////////////////////////////////////////
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      border: Border.all(color: borderColor, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.35 : 0.12),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    ////////////////////////////////////////////////////////////
                    ///
                    ////////////////////////////////////////////////////////////
                    child: Row(
                      children: List.generate(navItems.length, (i) {
                        ////////////////////////////////////////////////////////
                        final key = navItems[i].$1;
                        final isScan = key == '__scan__';
                        final isProfile = key == RouteNames.profile;
                        final isActive = currentIndex == i;
                        ////////////////////////////////////////////////////////

                        if (isScan) {
                          return const Expanded(child: SizedBox.shrink());
                        }
                        ////////////////////////////////////////////////////////

                        if (isProfile) {
                          return Expanded(
                            child: ProfileNavItem(
                              avatarUrl: avatarUrl,
                              isActive: isActive,
                              isDark: isDark,
                              onTap: () => onTap(i),
                            ),
                          );
                        }

                        ////////////////////////////////////////////////////////

                        return Expanded(
                          child: NavItem(
                            icon: navItems[i].$2,
                            isActive: isActive,
                            isDark: isDark,
                            onTap: () => onTap(i),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),

              //////////////////////////////////////////////////////////////////
              // ---- Floating scan circle sitting in the notch ----
              //////////////////////////////////////////////////////////////////
              Positioned(
                bottom: barHeight - notchRadius - 4,
                child: ScanButton(onTap: () => onTap(scanIndex)),
              ),
            ],
          ),
        );
      },
    );
  }
}
