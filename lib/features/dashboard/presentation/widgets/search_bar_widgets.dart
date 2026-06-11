import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class SearchBarWidget extends StatelessWidget {
  final String hint;
  final VoidCallback? onTap;

  const SearchBarWidget({
    super.key,
    this.hint = 'Search modules...',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Pallets.surfaceDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Pallets.borderDark),
        ),
        child: Row(
          children: [
            const Icon(Icons.search_rounded, color: Pallets.textSecondaryLight, size: 20),
            const SizedBox(width: 10),
            Text(hint, style: const TextStyle(color: Pallets.textSecondaryLight, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}