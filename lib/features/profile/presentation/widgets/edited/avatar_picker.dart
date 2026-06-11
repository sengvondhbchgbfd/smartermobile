import 'dart:io';

import 'package:flutter/material.dart';

class AvatarPicker extends StatelessWidget {
  final String? avatarUrl;
  final File? avatarFile;
  final String name;
  final VoidCallback onTap;

  const AvatarPicker({super.key, 
    required this.avatarUrl,
    required this.avatarFile,
    required this.name,
    required this.onTap,
  });

  static const _bg = Color(0xFF1E1F22);
  static const _blurple = Color(0xFF5865F2);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: const Color(0xFF36393F),
              backgroundImage: avatarFile != null
                  ? FileImage(avatarFile!) as ImageProvider
                  : (avatarUrl != null && avatarUrl!.isNotEmpty)
                  ? NetworkImage(avatarUrl!)
                  : null,
              child:
                  (avatarFile == null &&
                      (avatarUrl == null || avatarUrl!.isEmpty))
                  ? Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: _blurple,
                  shape: BoxShape.circle,
                  border: Border.all(color: _bg, width: 2),
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

