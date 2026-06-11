import 'package:flutter/material.dart';
import 'package:frontendmobile/features/communication/chat/domain/entities/chat_group_entity.dart';

class ChatAvatar extends StatelessWidget {
  final ChatGroupEntity group;
  const ChatAvatar({super.key, required this.group});
  @override
  Widget build(BuildContext context) {
    final isDirect = group.chatType == ChatType.direct;
    final name = group.groupName ?? '';
    final initials = name.isEmpty
        ? (isDirect ? 'DM' : 'GR')
        : name.trim().split(' ').take(2).map((w) => w[0].toUpperCase()).join();

    return Stack(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDirect ? const Color(0xFF1e3d2a) : const Color(0xFF1a3a5c),
          ),
          alignment: Alignment.center,
          child: Text(
            initials,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDirect
                  ? const Color(0xFF4daf7c)
                  : const Color(0xFF5caeff),
            ),
          ),
        ),
        if (isDirect)
          Positioned(
            bottom: 1,
            right: 1,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF4daf7c),
                border: Border.all(color: const Color(0xFF17212b), width: 2),
              ),
            ),
          ),
      ],
    );
  }
}
