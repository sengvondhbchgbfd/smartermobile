import 'package:flutter/material.dart';

class ReadOnlyTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ReadOnlyTile({super.key, 
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2D31),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF3F4147)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF80848E)),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF80848E)),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFFB5BAC1),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.lock_outline_rounded,
            size: 13,
            color: Color(0xFF4E5058),
          ),
        ],
      ),
    );
  }
}

