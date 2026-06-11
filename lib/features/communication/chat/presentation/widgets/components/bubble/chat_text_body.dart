import 'package:flutter/material.dart';
import 'package:frontendmobile/features/communication/chat/domain/entities/chat_message_entity.dart';
import 'package:frontendmobile/features/communication/chat/presentation/widgets/components/bubble/chat_time_row.dart';

class ChatTextBody extends StatelessWidget {
  final ChatMessageEntity message;
  final bool isMe;
  const ChatTextBody({super.key, required this.message, required this.isMe});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          message.content ?? '',
          style: const TextStyle(
            fontSize: 14.5,
            color: Color(0xFFe8eaed),
            height: 1.45,
          ),
        ),
        const SizedBox(height: 2),
        ChatTimeRow(message: message, isMe: isMe),
      ],
    ),
  );
}
