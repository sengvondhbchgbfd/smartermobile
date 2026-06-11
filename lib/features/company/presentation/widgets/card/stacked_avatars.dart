import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/company/presentation/widgets/card/avatar_bubble.dart';
import 'package:frontendmobile/features/company/presentation/widgets/card/user_state_card.dart';

class StackedAvatars extends StatelessWidget {
  final List<StaffPreview> users;
  final int extra;
  const StackedAvatars({super.key, required this.users, required this.extra});
  @override
  Widget build(BuildContext context) {
    const double size = 28;
    const double overlap = 18;
    final totalSlots = users.length + (extra > 0 ? 1 : 0);
    final width = overlap * (totalSlots - 1) + size;

    return SizedBox(
      height: size,
      width: width,
      child: Stack(
        children: [
          // Avatars
          ...users.asMap().entries.map((entry) {
            final i = entry.key;
            final u = entry.value;
            return Positioned(
              left: i * overlap,
              child: AvatarBubble(user: u, size: size),
            );
          }),
          // +N bubble
          if (extra > 0)
            Positioned(
              left: users.length * overlap,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Pallets.gradient2.withOpacity(0.2),
                  border: Border.all(color: Pallets.backgroundDark, width: 2),
                ),
                child: Center(
                  child: Text(
                    '+$extra',
                    style: TextStyle(
                      color: Pallets.gradient2,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
