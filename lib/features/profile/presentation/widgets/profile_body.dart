import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/hr/staff/domain/entities/staff_entity.dart';
import 'package:frontendmobile/features/profile/domain/entities/profile_entity.dart';
import 'package:frontendmobile/features/profile/presentation/providers/profile_providers.dart';
import 'package:frontendmobile/features/profile/presentation/widgets/avatar_cart.dart';
import 'package:frontendmobile/features/profile/presentation/widgets/banner_icon_button.dart';
import 'package:frontendmobile/features/profile/presentation/widgets/info_card.dart';
import 'package:frontendmobile/features/profile/presentation/widgets/menu/account_menu.dart';
import 'package:frontendmobile/features/profile/presentation/widgets/permission/empty_permission.dart';
import 'package:frontendmobile/features/profile/presentation/widgets/permission_card.dart';
import 'package:go_router/go_router.dart';

class ProfileBody extends ConsumerStatefulWidget {
  final ProfileEntity profile;
  final StaffEntity staff;
  const ProfileBody({super.key, required this.profile, required this.staff});

  @override
  ConsumerState<ProfileBody> createState() => _ProfileBodyState();
}

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class _ProfileBodyState extends ConsumerState<ProfileBody> {
  int _selectedTab = 0;
  static const _bannerHeight = 160.0;
  static const _avatarRadius = 48.0;
  static const _avatarOverlap = 32.0;

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  void _openAccountMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => AccountMenu(
        onItemSelected: (action) {
          switch (action) {
            case 'settings':
              context.push('/settings');
              break;
            case 'profile':
              context.push('/profile');
              break;
            case 'drafts':
              context.push('/drafts');
              break;
            case 'history':
              context.push('/history');
              break;
            case 'saved':
              context.push('/saved');
              break;
          }
        },
      ),
    );
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final textSub = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final dividerColor = isDark ? Pallets.borderDark : Pallets.borderLight;
    final scaffoldBg = isDark
        ? Pallets.backgroundDark
        : Pallets.backgroundLight;
    // Tab active color — brand accent, same in both modes
    const tabActiveColor = Pallets.gradient2;
    final tabInactiveColor = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;

    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    return ColoredBox(
      color: scaffoldBg,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ////////////////////////////////////////////////////////////////////
            // Banner + Avatar stack
            ////////////////////////////////////////////////////////////////////
            Stack(
              clipBehavior: Clip.none,
              children: [
                ////////////////////////////////////////////////////////////////
                ///  set background grediend
                ////////////////////////////////////////////////////////////////
                Container(
                  height: _bannerHeight,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Pallets.purpleStart, Pallets.purpleEnd],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),

                ////////////////////////////////////////////////////////////////
                // Top bar
                ////////////////////////////////////////////////////////////////
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 8,
                  right: 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BannerIconButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onPressed: () {
                          context.go("/dashboard");
                        },
                      ),
                      BannerIconButton(
                        icon: Icons.menu_rounded,
                        onPressed: () => _openAccountMenu(context),
                      ),
                    ],
                  ),
                ),

                ////////////////////////////////////////////////////////////////
                /// Avatar
                ////////////////////////////////////////////////////////////////
                Positioned(
                  top: _bannerHeight - _avatarOverlap,
                  left: 20,
                  child: AvatarCard(profile: widget.profile),
                ),
                SizedBox(
                  height: _bannerHeight + _avatarRadius + _avatarOverlap,
                ),

                ////////////////////////////////////////////////////////////////
                ///
                ////////////////////////////////////////////////////////////////
              ],
            ),

            const SizedBox(height: 16),

            ////////////////////////////////////////////////////////////////////
            // Name + subtitle + Edit Profile button
            ////////////////////////////////////////////////////////////////////
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.profile.fullName,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: textPrimary.withOpacity(0.5),
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${widget.profile.isManager ? 'Manager' : 'Staff'}  •  ${widget.profile.username}',
                    style: TextStyle(fontSize: 13, color: textSub),
                  ),
                  const SizedBox(height: 16),

                  //////////////////////////////////////////////////////////////
                  // Edit Profile button — gradient2 stays same in both modes
                  //////////////////////////////////////////////////////////////
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      //////////////////////////////////
                      ///
                      /////////////////////////////////
                      onPressed: () async {
                        await context.push(
                          '/profile/edit',
                          extra: {
                            'profile': widget.profile,
                            'staff': widget.staff,
                          },
                        );
                        // ref.read(profileNotifierProvider.notifier).refresh();
                        ref.invalidate(profileNotifierProvider);
                      },
                      //////////////////////////////////
                      ///
                      /////////////////////////////////
                      icon: const Icon(Icons.edit_rounded, size: 16),
                      label: const Text('Edit Profile'),

                      //////////////////////////////////
                      ///
                      /////////////////////////////////
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Pallets.gradient2,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      //////////////////////////////////
                      ///
                      /////////////////////////////////
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            ////////////////////////////////////////////////////////////////////
            // Tab row
            ////////////////////////////////////////////////////////////////////
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(height: 1, color: dividerColor),
            ),
            Row(
              children: List.generate(2, (i) {
                final active = i == _selectedTab;
                final label = i == 0 ? 'Info' : 'Permissions';
                return GestureDetector(
                  onTap: () => setState(() => _selectedTab = i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: active ? tabActiveColor : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: active ? tabActiveColor : tabInactiveColor,
                      ),
                    ),
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(height: 1, color: dividerColor),
            ),
            const SizedBox(height: 12),

            //══════════════════════════════════════════
            // Tab content
            //══════════════════════════════════════════
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _selectedTab == 0
                    ? InfoCard(
                        key: const ValueKey('info'),
                        profile: widget.profile,
                      )
                    : widget.profile.permissions.isEmpty
                    ? EmptyPermissions(key: const ValueKey('empty'))
                    : PermissionsCard(
                        key: const ValueKey('perms'),
                        permissions: widget.profile.permissions,
                      ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
