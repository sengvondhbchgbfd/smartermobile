import 'package:flutter/material.dart';

class DateTile extends StatelessWidget {
  final DateTime? dob;
  final VoidCallback onTap;

  const DateTile({super.key, required this.dob, required this.onTap});

  String get _label {
    if (dob == null) return 'Date of Birth';
    return '${dob!.day.toString().padLeft(2, '0')}/'
        '${dob!.month.toString().padLeft(2, '0')}/'
        '${dob!.year}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF2B2D31),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF3F4147)),
        ),
        child: Row(
          children: [
            const Icon(Icons.cake_outlined, size: 18, color: Color(0xFF80848E)),
            const SizedBox(width: 10),
            Text(
              _label,
              style: TextStyle(
                fontSize: 14,
                color: dob == null ? const Color(0xFF80848E) : Colors.white,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: Color(0xFF80848E),
            ),
          ],
        ),
      ),
    );
  }
}
