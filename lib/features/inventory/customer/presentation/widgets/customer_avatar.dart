import 'package:flutter/material.dart';

class AppAvatar extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final double size;

  const AppAvatar({
    super.key,
    required this.name,
    this.avatarUrl,
    this.size = 46,
  });

  String _getInitials(String value) {
    if (value.trim().isEmpty) return '?';

    final parts = value.trim().split(RegExp(r'\s+'));

    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }

    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark
        ? const Color(0xFF424242)
        : const Color(0xFFEEEEEE);

    final textColor = isDark
        ? const Color(0xFFEEEEEE)
        : const Color(0xFF424242);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: avatarUrl != null && avatarUrl!.isNotEmpty
          ? ClipOval(
              child: Image.network(
                avatarUrl!,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildInitials(textColor),
              ),
            )
          : _buildInitials(textColor),
    );
  }

  Widget _buildInitials(Color textColor) {
    return Text(
      _getInitials(name),
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
        fontSize: size * 0.35,
      ),
    );
  }
}
