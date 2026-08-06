import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class FallbackAvatar extends StatelessWidget {
  final bool isActive;
  const FallbackAvatar({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Pallets.blurple.withOpacity(0.12),
      child: Icon(
        Icons.person_rounded,
        size: 18,
        color: isActive ? Pallets.blurple : Pallets.textMuted,
      ),
    );
  }
}
