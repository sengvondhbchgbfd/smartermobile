import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class PlanStatCard extends StatelessWidget {
  final String plan;
  const PlanStatCard({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isFree = plan.toLowerCase() == 'free';
    final t1 = isDark ? Pallets.textPrimaryDark : Pallets.textPrimaryLight;
    final t2 = isDark ? Pallets.textSecondaryDark : Pallets.textSecondaryLight;
    final bg = isDark ? Pallets.surfaceCard : Pallets.surfaceLight;
    final border = isDark ? Pallets.borderDark : Pallets.borderLight;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Icon ──────────────────────────────────────────────────
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: isFree ? null : Pallets.brandGradient,
              color: isFree ? Pallets.blurple.withOpacity(0.10) : null,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isFree
                  ? Icons.lock_outline_rounded
                  : Icons.workspace_premium_rounded,
              color: isFree ? Pallets.blurple : Pallets.onAccent,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // ── Label + plan name ──────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PLAN',
                  style: TextStyle(
                    color: t2,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  plan.toUpperCase(),
                  style: TextStyle(
                    color: isFree ? t2 : t1,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),

          // ── Upgrade pill / Pro badge ───────────────────────────────
          if (isFree)
            GestureDetector(
              onTap: () {}, // hook up upgrade flow
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  gradient: Pallets.brandGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Pallets.blurple.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Upgrade',
                      style: TextStyle(
                        color: Pallets.onAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Pallets.onAccent,
                      size: 12,
                    ),
                  ],
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Pallets.success.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Pallets.success.withOpacity(0.3)),
              ),
              child: const Text(
                'Active',
                style: TextStyle(
                  color: Pallets.success,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
