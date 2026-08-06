import 'package:flutter/material.dart';

class BannerIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const BannerIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black26,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: IconButton(
        icon: Icon(icon, size: 18, color: Colors.white70),
        onPressed: onPressed,
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      ),
    );
  }
}
