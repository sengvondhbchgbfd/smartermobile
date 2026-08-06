import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class EmptyState extends StatelessWidget {
  final String query;
  final Color textPrimary;
  final Color textSecondary;

  const EmptyState({
    super.key,
    required this.query,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Pallets.infoTint,
                shape: BoxShape.circle,
              ),
              child: Icon(
                query.isNotEmpty
                    ? Icons.search_off_rounded
                    : Icons.local_shipping_outlined,
                color: Pallets.blurple,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              query.isNotEmpty
                  ? 'No suppliers match "$query"'
                  : 'No suppliers yet',
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              query.isNotEmpty
                  ? 'Try a different name, phone, or email.'
                  : 'Tap "Add supplier" to add your first vendor.',
              style: TextStyle(fontSize: 13, color: textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
