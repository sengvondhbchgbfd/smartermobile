import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class Chipes extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const Chipes({super.key, 
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? Pallets.gradient2 : Pallets.backgroundDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? Pallets.gradient2 : Pallets.borderDark,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Pallets.textSecondaryDark,
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}