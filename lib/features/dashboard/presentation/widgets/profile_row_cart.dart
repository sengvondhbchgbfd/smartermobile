import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/config/routes/route_names.dart';
import 'package:frontendmobile/features/dashboard/presentation/widgets/user_card_skeleton.dart';
import 'package:frontendmobile/features/dashboard/presentation/widgets/user_card_widgets.dart';
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


          
          /////////////////////////////
          // Add Button
          /////////////////////////////
          // const SizedBox(width: 10),
          // _AddButton(onPressed: () {}),
          ////////////////////////////
          ///
          ///////////////////////////
        ],
      ),
    );
  }
}

// class _AddButton extends StatelessWidget {
//   final VoidCallback onPressed;
//   const _AddButton({required this.onPressed});
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Container(
//         width: 44,
//         height: 44,
//         decoration: BoxDecoration(
//           color: const Color.fromRGBO(251, 109, 169, 1),
//           borderRadius: BorderRadius.circular(14),
//         ),
//         child: const Icon(Icons.add_rounded, color: Colors.white, size: 22),
//       ),
//     );
//   }
// }
