import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? Pallets.surfaceDark : Pallets.surfaceLight;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.notifications_off_outlined,
              color: textSecondary,
              size: 36,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications',
            style: TextStyle(
              color: textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "You're all caught up!",
            style: TextStyle(color: textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
