import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';


// ─────────────────────────────────────────────
// CHAT PREVIEW WIDGET
// ─────────────────────────────────────────────

Widget buildChatPreview() {
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
            'Team Chat',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 14),
          _chatTile('Sarah', 'Please approve invoice #102', '2m'),
          _chatTile('Tom', 'Meeting at 3PM', '10m'),
          _chatTile('Maria', 'Payroll completed', '1h', isLast: true),
        ],
      ),
    );
  }

  Widget _chatTile(
    String name,
    String message,
    String time, {
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Pallets.gradient2,
            child: Text(
              name[0],
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  message,
                  style: const TextStyle(
                    color: Pallets.textSecondaryDark,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            time,
            style: const TextStyle(
              color: Pallets.textSecondaryDark,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }