import 'package:flutter/material.dart';

class SwitchAccountButton extends StatelessWidget {
  const SwitchAccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: open account switcher bottom sheet
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.purple.withOpacity(0.12),
          border: Border.all(color: Colors.purple.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Switch account',
              style: TextStyle(
                color: Colors.purple[200],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.purple[200],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
