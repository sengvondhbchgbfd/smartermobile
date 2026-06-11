import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontendmobile/features/communication/chat/domain/entities/chat_message_entity.dart';
import 'package:frontendmobile/features/communication/chat/presentation/widgets/components/bubble/chat_time_row.dart';

class ChatImageBody extends StatelessWidget {
  final ChatMessageEntity message;
  final bool isMe;
  const ChatImageBody({super.key, required this.message, required this.isMe});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      if (message.fileUrl != null) _buildImage(message.fileUrl!),
      if (message.content != null)
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 6, 12, 2),
          child: Text(
            message.content!,
            style: const TextStyle(fontSize: 13.5, color: Color(0xFFe8eaed)),
          ),
        ),
      Padding(
        padding: const EdgeInsets.fromLTRB(8, 2, 8, 6),
        child: ChatTimeRow(message: message, isMe: isMe),
      ),
    ],
  );
  Widget _buildImage(String url) {
    final isLocal = !url.startsWith('http');
    if (isLocal) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Image.file(File(url), width: 240, height: 180, fit: BoxFit.cover),
          // ← uploading indicator overlay
          Container(
            width: 240,
            height: 180,
            color: Colors.black.withOpacity(0.30),
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF5caeff),
              ),
            ),
          ),
        ],
      );
    }
    return CachedNetworkImage(
      imageUrl: url,
      width: 240,
      height: 180,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(
        width: 240,
        height: 180,
        color: const Color(0xFF1a3a5c),
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Color(0xFF5caeff),
          ),
        ),
      ),
      errorWidget: (_, __, ___) => Container(
        width: 240,
        height: 180,
        color: const Color(0xFF1a3a5c),
        child: const Icon(Icons.broken_image_rounded, color: Color(0xFF5caeff)),
      ),
    );
  }
}
