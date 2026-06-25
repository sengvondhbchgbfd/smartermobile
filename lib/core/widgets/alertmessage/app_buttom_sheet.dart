import 'package:flutter/material.dart';

class AppBottomSheet {
  static void showOptions(
    BuildContext context, {
    required String title,
    required List<SheetOption> options,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Divider(height: 20),
            ...options.map(
              (opt) => ListTile(
                leading: Icon(
                  opt.icon,
                  color: opt.isDestructive ? const Color(0xFFC62828) : null,
                  size: 22,
                ),
                title: Text(
                  opt.label,
                  style: TextStyle(
                    fontSize: 14,
                    color: opt.isDestructive ? const Color(0xFFC62828) : null,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  opt.onTap();
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class SheetOption {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isDestructive;

  const SheetOption({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isDestructive = false,
  });
}
