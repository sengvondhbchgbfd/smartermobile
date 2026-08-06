import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const HeaderIconButton({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Pallets.onAccent.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Pallets.onAccent, size: 20),
      ),
    );
  }
}
