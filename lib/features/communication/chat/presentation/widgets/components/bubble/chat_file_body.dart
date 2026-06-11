import 'package:flutter/material.dart';
import 'package:frontendmobile/features/communication/chat/domain/entities/chat_message_entity.dart';
import 'package:frontendmobile/features/communication/chat/presentation/widgets/components/bubble/chat_time_row.dart';

class ChatFileBody extends StatelessWidget {
  final ChatMessageEntity message;
  final bool isMe;
  const ChatFileBody({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(10),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFF2b5278),
          ),
          child: const Icon(
            Icons.description_outlined,
            color: Color(0xFF5caeff),
            size: 22,
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.fileName ?? 'File',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFe8eaed),
                ),
              ),
              if (message.fileSize != null)
                Text(
                  _formatSize(message.fileSize!),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8a9bb0),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        ChatTimeRow(message: message, isMe: isMe),
      ],
    ),
  );

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
