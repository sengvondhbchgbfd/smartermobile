import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class PlanBadge extends StatelessWidget {
  final String plan;
  const PlanBadge({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPro = plan.toLowerCase() != 'free';

    final freeBg = isDark ? Pallets.surfaceElevated : Pallets.borderLight;
    final freeBorder = isDark ? Pallets.borderDark : Pallets.borderLight;
    final freeText = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        gradient: isPro ? Pallets.brandGradient : null,
        color: isPro ? null : freeBg,
        borderRadius: BorderRadius.circular(20),
        border: isPro ? null : Border.all(color: freeBorder),
        boxShadow: isPro
            ? [
                BoxShadow(
                  color: Pallets.blurple.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPro
                ? Icons.workspace_premium_rounded
                : Icons.lock_outline_rounded,
            color: isPro ? Pallets.onAccent : freeText,
            size: 14,
          ),
          const SizedBox(width: 6),
          Text(
            plan.toUpperCase(),
            style: TextStyle(
              color: isPro ? Pallets.onAccent : freeText,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
