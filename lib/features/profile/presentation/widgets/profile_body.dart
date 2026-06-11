import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/hr/staff/domain/entities/staff_entity.dart';
import 'package:frontendmobile/features/profile/domain/entities/profile_entity.dart';
import 'package:frontendmobile/features/profile/presentation/providers/profile_providers.dart';
import 'package:frontendmobile/features/profile/presentation/widgets/avatar_cart.dart';
import 'package:frontendmobile/features/profile/presentation/widgets/info_card.dart';
import 'package:frontendmobile/features/profile/presentation/widgets/permission_card.dart';
import 'package:go_router/go_router.dart';

class ProfileBody extends ConsumerStatefulWidget {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  final ProfileEntity profile;
  final StaffEntity staff;
  const ProfileBody({super.key, required this.profile, required this.staff});
  @override
  ConsumerState<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends ConsumerState<ProfileBody> {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  int _selectedTab = 0;
  static const _bannerHeight = 160.0;
  static const _avatarRadius = 48.0;
  static const _avatarOverlap = 32.0;
  static const _blurple = Color(0xFF5865F2);
  static const _tabMuted = Color(0xFF80848E);
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //══════════════════════════════════════════
          // Banner + Avatar stack
          //══════════════════════════════════════════
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: _bannerHeight,
                width: double.infinity,
                color: const Color(0xFF5B3A8E),
              ),
              //////////////////////////////////////
              ///
              /////////////////////////////////////
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                left: 8,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: Colors.white70,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              //////////////////////////////////////
              ///
              /////////////////////////////////////
              Positioned(
                top: _bannerHeight - _avatarOverlap,
                left: 20,
                child: AvatarCard(profile: widget.profile),
              ),
              SizedBox(height: _bannerHeight + _avatarRadius + _avatarOverlap),
            ],
          ),

          const SizedBox(height: 12),

          //══════════════════════════════════════════
          // Name + subtitle + Edit button
          //══════════════════════════════════════════
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.profile.fullName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white70,
                      size: 20,
                    ),
                  ],
                ),

                ////////////////////////////////////////////////////////////////
                const SizedBox(height: 2),
                ////////////////////////////////////////////////////////////////
                Text(
                  '${widget.profile.isManager ? 'Manager' : 'Staff'}  •  ${widget.profile.username}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFFB5BAC1),
                  ),
                ),

                ////////////////////////////////////////////////////////////////
                const SizedBox(height: 16),
                ////////////////////////////////////////////////////////////////
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await context.push(
                        '/profile/edit',
                        extra: {
                          'profile': widget.profile,
                          'staff': widget.staff,
                        },
                      );
                      // ref.invalidate(profileNotifierProvider);
                      ref.read(profileNotifierProvider.notifier).refresh();
                    },

                    icon: const Icon(Icons.edit_rounded, size: 16),
                    label: const Text('Edit Profile'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _blurple,
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
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          //══════════════════════════════════════════
          // Tab row
          //══════════════════════════════════════════
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(height: 1, color: Color(0xFF3F4147)),
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
                        color: active ? _blurple : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: active ? _blurple : _tabMuted,
                    ),
                  ),
                ),
              );
            }),
          ),

          /////////////////////////////////////////////////////////////////
          ///
          /////////////////////////////////////////////////////////////////
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(height: 1, color: Color(0xFF3F4147)),
          ),

          ////////////////////////////////////////////////////////////////
          const SizedBox(height: 12),
          ////////////////////////////////////////////////////////////////

          //══════════════════════════════════════════
          // Tab content Info Card
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
                  ? _EmptyPermissions(key: const ValueKey('empty'))
                  : PermissionsCard(
                      key: const ValueKey('perms'),
                      permissions: widget.profile.permissions,
                    ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
// ── Empty permissions placeholder ────────────────────────────────────────────
////////////////////////////////////////////////////////////////////////////////

class _EmptyPermissions extends StatelessWidget {
  const _EmptyPermissions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.shield_outlined, size: 36, color: Color(0xFF4E5058)),
          SizedBox(height: 10),
          Text(
            'No permissions assigned',
            style: TextStyle(fontSize: 13, color: Color(0xFF80848E)),
          ),
        ],
      ),
    );
  }
}
