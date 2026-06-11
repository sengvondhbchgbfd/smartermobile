import 'package:flutter/material.dart';
import 'package:frontendmobile/features/communication/chat/domain/entities/chat_message_entity.dart';

class ChatReplyPreview extends StatelessWidget {
  final ReplyPreviewEntity reply;
  final VoidCallback? onTap;
  const ChatReplyPreview({super.key, required this.reply, this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
        border: const Border(
          left: BorderSide(color: Color(0xFF3a7bd5), width: 3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reply to',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF5caeff),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            reply.content ?? _typeLabel(reply.messageType),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12.5, color: Color(0xFF8a9bb0)),
          ),
        ],
      ),
    ),
  );

  String _typeLabel(String t) {
    switch (t) {
      case 'image':
        return '📷 Photo';
      case 'video':
        return '🎥 Video';
      case 'audio':
        return '🎵 Audio';
      case 'voice':
        return '🎙 Voice note';
      case 'file':
        return '📎 File';
      default:
        return 'Message';
    }
  }
}
