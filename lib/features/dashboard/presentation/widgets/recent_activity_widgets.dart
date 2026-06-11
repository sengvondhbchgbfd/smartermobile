import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

Widget buildRecentActivity() {
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
        color: Pallets.surfaceDark,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Pallets.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Activity',
            style: TextStyle(
              color: Colors.white,
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
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      items[i],
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                  const Text(
                    'Now',
                    style: TextStyle(
                      color: Pallets.textSecondaryDark,
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