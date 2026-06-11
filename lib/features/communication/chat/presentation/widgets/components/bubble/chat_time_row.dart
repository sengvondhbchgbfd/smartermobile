import 'package:flutter/material.dart';
import 'package:frontendmobile/features/communication/chat/domain/entities/chat_message_entity.dart';

class ChatTimeRow extends StatelessWidget {
  final ChatMessageEntity message;
  final bool isMe;
  const ChatTimeRow({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        _fmt(message.createdAt),
        style: TextStyle(
          fontSize: 11.5,
          color: isMe
              ? Colors.white.withOpacity(0.45)
              : const Color(0xFF6b8097),
        ),
      ),
      if (isMe) ...[
        const SizedBox(width: 3),
        Icon(
          message.isRead ? Icons.done_all_rounded : Icons.done_rounded,
          size: 15,
          color: message.isRead
              ? const Color(0xFF5caeff)
              : Colors.white.withOpacity(0.45),
        ),
      ],
    ],
  );

  String _fmt(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
