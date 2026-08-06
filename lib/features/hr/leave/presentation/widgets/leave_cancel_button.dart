import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/leave_pallets.dart';

class LeaveCancelButton extends StatelessWidget {
  final LeavePalette p;
  final VoidCallback onTap;

  const LeaveCancelButton({super.key, required this.p, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: p.cancelBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: p.cancelBorder),
        ),
        child: Text(
          'Cancel',
          style: TextStyle(
            color: p.cancelText,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
