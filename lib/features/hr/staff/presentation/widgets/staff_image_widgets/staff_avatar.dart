import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class StaffAvatar extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final double radius;
  final VoidCallback? onTap;
  final bool showCameraBadge;

  const StaffAvatar({
    super.key,
    required this.name,
    this.avatarUrl,
    this.radius = 20,
    this.onTap,
    this.showCameraBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final initial = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '?';

    final avatar = CircleAvatar(
      radius: radius,
      backgroundColor: Pallets.blurple.withOpacity(isDark ? 0.2 : 0.12),
      backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
      child: avatarUrl == null
          ? Text(
              initial,
              style: TextStyle(
                fontSize: radius * 0.8,
                fontWeight: FontWeight.w600,
                color: Pallets.blurple,
              ),
            )
          : null,
    );

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          avatar,
          if (showCameraBadge)
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Pallets.blurple,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? Pallets.surfaceDark : Colors.white,
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  size: radius * 0.4,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}