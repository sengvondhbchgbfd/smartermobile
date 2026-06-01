import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontendmobile/features/communication/chat/domain/entities/chat_message_entity.dart';

class ChatVideoBody extends StatelessWidget {
  final ChatMessageEntity message;
  final bool isMe;
  const ChatVideoBody({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) => Container(
    width: 240,
    height: 150,
    color: const Color(0xFF1a2533),
    child: Stack(
      alignment: Alignment.center,
      children: [
        if (message.mediaThumbnail != null)
          CachedNetworkImage(
            imageUrl: message.mediaThumbnail!,
            fit: BoxFit.cover,
            width: 240,
            height: 150,
          ),
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.55),
          ),
          child: const Icon(
            Icons.play_arrow_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),
        if (message.durationSecs != null)
          Positioned(
            bottom: 8,
            right: 8,
            child: Text(
              _formatDuration(message.durationSecs!),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    ),
  );

  String _formatDuration(int secs) {
    final m = secs ~/ 60;
    final s = secs % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}
