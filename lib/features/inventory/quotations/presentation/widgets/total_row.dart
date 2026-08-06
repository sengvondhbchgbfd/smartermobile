import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const TotalRow({
    super.key,
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 15 : 13,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              color: isTotal ? null : Pallets.textMuted,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 17 : 13,
              fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
              color: isTotal ? Pallets.blurple : null,
            ),
          ),
        ],
      ),
    );
  }
}
