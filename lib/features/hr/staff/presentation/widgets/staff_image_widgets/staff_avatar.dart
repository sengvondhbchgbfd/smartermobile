import 'package:flutter/material.dart';

class StaffAvatar extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final double radius;
  const StaffAvatar({
    super.key,
    required this.name,
    this.avatarUrl,
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
          child: avatarUrl == null
              ? Text(
                  name[0].toUpperCase(),
                  style: TextStyle(fontSize: radius * 0.8),
                )
              : null,
        ),
        // Small camera badge at bottom-right
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.blue.shade600,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            child: Icon(
              Icons.camera_alt,
              size: radius * 0.45,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
