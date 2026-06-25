import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/config/routes/route_names.dart';
import 'package:frontendmobile/features/dashboard/presentation/components/cart/user_card_skeleton.dart';
import 'package:frontendmobile/features/dashboard/presentation/components/cart/user_card_widgets.dart';
import 'package:go_router/go_router.dart';

class ProfileRow extends StatelessWidget {
  const ProfileRow({super.key, required this.profileAsync});

  final AsyncValue<dynamic> profileAsync;

  @override
  Widget build(BuildContext context) {
    return profileAsync.when(
      loading: () => const UserCardSkeleton(),
      error: (_, __) => const UserCardSkeleton(),
      data: (profile) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: UserCardWidget(
              profile: profile,
              onSettingsTap: () => context.push(RouteNames.profile),
            ),
          ),
        ],
      ),
    );
  }
}
