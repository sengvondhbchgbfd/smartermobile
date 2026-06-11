import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/company/presentation/widgets/card/user_state_card.dart';

class AvatarBubble extends StatelessWidget {
  final StaffPreview user;
  final double size;
  const AvatarBubble({super.key, required this.user, required this.size});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Pallets.backgroundDark, width: 2),
      ),
      child: CircleAvatar(
        radius: size / 2,
        backgroundColor: Pallets.surfaceDark,
        backgroundImage: user.avatarUrl != null
            ? NetworkImage(user.avatarUrl!)
            : null,
        child: user.avatarUrl == null
            ? Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
                
              )
            : null,
      ),
    );
  }
}
