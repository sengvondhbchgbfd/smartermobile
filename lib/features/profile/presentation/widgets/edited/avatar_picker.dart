import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class AvatarPicker extends StatelessWidget {
  final String? avatarUrl;
  final File? avatarFile;
  final String name;
  final VoidCallback onTap;

  const AvatarPicker({
    super.key,
    required this.avatarUrl,
    required this.avatarFile,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // avatar fallback bg — slightly elevated surface in both modes
    final avatarBg = isDark ? Pallets.surfaceDark : Pallets.borderLight;
    // camera badge border matches page background
    final badgeBorder = isDark
        ? Pallets.backgroundDark
        : Pallets.backgroundLight;

    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: avatarBg,
              backgroundImage: avatarFile != null
                  ? FileImage(avatarFile!) as ImageProvider
                  : (avatarUrl != null && avatarUrl!.isNotEmpty)
                  ? NetworkImage(avatarUrl!)
                  : null,
              child:
                  (avatarFile == null &&
                      (avatarUrl == null || avatarUrl!.isEmpty))
                  ? Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Pallets.gradient2, // brand, same in both modes
                  shape: BoxShape.circle,
                  border: Border.all(color: badgeBorder, width: 2),
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
