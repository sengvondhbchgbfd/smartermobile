import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class PlanStatCard extends StatelessWidget {
  final String plan;
  const PlanStatCard({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final isFree = plan.toLowerCase() == 'free';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Pallets.backgroundDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Pallets.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PLAN',
            style: TextStyle(
              color: Pallets.textSecondaryDark,
              fontSize: 10,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            plan.toUpperCase(),
            style: TextStyle(
              color: isFree ? Pallets.textSecondaryDark : Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (isFree)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.purple.withOpacity(0.3)),
              ),
              child: Text(
                'UPGRADE →',
                style: TextStyle(
                  color: Colors.purple[200],
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
              ),
            ),
        ],
      ),
    );
  }
}