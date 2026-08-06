import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class ScanButton extends StatelessWidget {
  final VoidCallback onTap;
  const ScanButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 68,
        height: 68,
        decoration: BoxDecoration(
          gradient: Pallets.brandGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Pallets.blurple.withOpacity(0.5),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(
          Icons.qr_code_scanner_rounded,
          color: Pallets.onAccent,
          size: 30,
        ),
      ),
    );
  }
}
