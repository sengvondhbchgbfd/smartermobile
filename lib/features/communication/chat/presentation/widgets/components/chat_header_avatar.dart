import 'package:flutter/material.dart';
import 'package:frontendmobile/features/communication/chat/domain/entities/chat_group_entity.dart';

class ChatHeaderAvatar extends StatelessWidget {
  final ChatGroupEntity group;
  const ChatHeaderAvatar({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final name = group.groupName ?? '';
    final initials = name.isEmpty
        ? 'C'
        : name
              .trim()
              .split(' ')
              .take(2)
              .map((w) => w.isEmpty ? '' : w[0].toUpperCase())
              .join();
    final isDirect = group.chatType == ChatType.direct;
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDirect ? const Color(0xFF1e3d2a) : const Color(0xFF1a3a5c),
      ),
      alignment: Alignment.center,
      child: Text(
        initials.isEmpty ? 'C' : initials,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isDirect ? const Color(0xFF4daf7c) : const Color(0xFF5caeff),
        ),
      ),
    );
  }
}
