import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final int maxLines;
  final Color textPrimary;
  final Color textSecondary;

  const InfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.textPrimary,
    required this.textSecondary,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.trim().isNotEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Pallets.infoTint,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 17, color: Pallets.blurple),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 11.5, color: textSecondary),
                ),
                const SizedBox(height: 2),
                Text(
                  hasValue ? value! : 'Not provided',
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    color: hasValue ? textPrimary : textSecondary,
                    fontStyle: hasValue ? FontStyle.normal : FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
