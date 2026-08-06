import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

Widget buildRecentActivity(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  final items = [
    'Invoice created',
    'Attendance scanned',
    'User added',
    'Stock updated',
    'Payroll approved',
  ];

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: isDark ? Pallets.surfaceCard : Pallets.surfaceLight,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(
        color: isDark ? Pallets.borderDark : Pallets.borderLight,
      ),
      boxShadow: isDark
          ? null
          : [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: TextStyle(
            color: isDark ? Pallets.textPrimaryDark : Pallets.textPrimaryLight,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 14),
        ...List.generate(items.length, (i) {
          final isLast = i == items.length - 1;
          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Pallets.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    items[i],
                    style: TextStyle(
                      color: isDark
                          ? Pallets.textPrimaryDark
                          : Pallets.textPrimaryLight,
                      fontSize: 13,
                    ),
                  ),
                ),
                Text(
                  'Now',
                  style: TextStyle(
                    color: isDark
                        ? Pallets.textSecondaryDark
                        : Pallets.textSecondaryLight,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    ),
  );
}
