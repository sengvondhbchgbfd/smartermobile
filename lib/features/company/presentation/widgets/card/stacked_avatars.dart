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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const double size = 28;
    const double overlap = 18;
    final totalSlots = users.length + (extra > 0 ? 1 : 0);
    final width = overlap * (totalSlots - 1) + size;

    return SizedBox(
      height: size,
      width: width,
      child: Stack(
        children: [
          // ── Avatars ───────────────────────────────────────────
          ...users.asMap().entries.map((entry) {
            return Positioned(
              left: entry.key * overlap,
              child: AvatarBubble(user: entry.value, size: size),
            );
          }),

          // ── +N bubble ─────────────────────────────────────────
          if (extra > 0)
            Positioned(
              left: users.length * overlap,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Pallets.blurple.withOpacity(0.15),
                  border: Border.all(
                    color: isDark
                        ? Pallets.backgroundDark
                        : Pallets.backgroundLight,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    '+$extra',
                    style: const TextStyle(
                      color: Pallets.blurple,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
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
