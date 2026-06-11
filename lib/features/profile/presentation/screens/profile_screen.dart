import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/hr/staff/domain/entities/staff_entity.dart';
import 'package:frontendmobile/features/hr/staff/presentation/providers/staff_notifier.dart';
import 'package:frontendmobile/features/hr/staff/presentation/widgets/error_view.dart';
import 'package:frontendmobile/features/profile/presentation/providers/profile_providers.dart';
import 'package:frontendmobile/features/profile/presentation/widgets/profile_body.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /////////////////////////////////////////
    ///
    ////////////////////////////////////////
    final profileState = ref.watch(profileNotifierProvider);
    final staffAsync = ref.watch(staffNotifierProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF1E1F22),
      body: profileState.when(
        ////////////////////////////////////
        ///
        ///////////////////////////////////
        loading: () => const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Pallets.gradient2,
          ),
        ),
        ////////////////////////////////////
        ///
        ///////////////////////////////////
        error: (e, _) => ErrorView(
          message: e.toString(),
          onRetry: () => ref.read(profileNotifierProvider.notifier).refresh(),
        ),
        ////////////////////////////////////
        ///
        ///////////////////////////////////
        data: (profile) {
          final staff =
              staffAsync.valueOrNull?.firstWhere(
                (s) => s.userId == profile.userId,
                orElse: () => StaffEntity(
                  id: profile.staffId,
                  userId: profile.userId,
                  companyId: profile.companyId,
                  name: profile.fullName,
                  avatarUrl: profile.avatarUrl,
                ),
              ) ??
              StaffEntity(
                id: profile.staffId,
                userId: profile.userId,
                companyId: profile.companyId,
                name: profile.fullName,
                avatarUrl: profile.avatarUrl,
              );
          return ProfileBody(profile: profile, staff: staff);
        },
      ),
    );
  }
}
