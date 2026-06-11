import 'package:flutter/material.dart';

class ChatContextAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;
  const ChatContextAction({
    super.key,
    required this.icon,
    required this.label,
    this.color,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon, color: color ?? const Color(0xFF8a9bb0), size: 22),
    title: Text(
      label,
      style: TextStyle(color: color ?? const Color(0xFFe8eaed), fontSize: 15),
    ),
    onTap: onTap,
    dense: true,
  );
}
