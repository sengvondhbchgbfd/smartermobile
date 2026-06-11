import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/communication/chat/presentation/widgets/components/chat_avatar.dart';
import '../../domain/entities/chat_group_entity.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../providers/chat_provider.dart';

class GroupListItem extends ConsumerWidget {
  final ChatGroupEntity group;
  final VoidCallback onTap;
  const GroupListItem({super.key, required this.group, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = ref.watch(unreadCountProvider(group.groupId));
    final chatState = ref.watch(chatProvider(group.groupId));
    final isDirect = group.chatType == ChatType.direct;

    // ✅ Get last message from already-loaded chat state
    final lastMsg = chatState.messages.isNotEmpty ? chatState.messages.first : null;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      leading: ChatAvatar(group: group),
      title: Row(
        children: [
          Expanded(
            child: Text(
              group.groupName ?? (isDirect ? 'Direct Message' : 'Group'),
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFFe8eaed),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // ✅ Timestamp on the right
          if (lastMsg != null)
            Text(
              _formatTime(lastMsg.createdAt),
              style: const TextStyle(
                fontSize: 11.5,
                color: Color(0xFF6b8097),
              ),
            ),
        ],
      ),
      subtitle: lastMsg != null
          ? Row(
              children: [
                // ✅ Show read tick for sent messages
                if (lastMsg.isRead)
                  const Icon(
                    Icons.done_all_rounded,
                    size: 14,
                    color: Color(0xFF5caeff),
                  )
                else
                  const Icon(
                    Icons.done_rounded,
                    size: 14,
                    color: Color(0xFF6b8097),
                  ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    _lastMessagePreview(lastMsg),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF8a9bb0),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            )
          : const Text(
              'No messages yet',
              style: TextStyle(fontSize: 13, color: Color(0xFF8a9bb0)),
            ),
      trailing: unread.when(
        data: (count) => count > 0
            ? Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF5caeff),
                ),
                alignment: Alignment.center,
                child: Text(
                  count > 99 ? '99+' : '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : null,
        loading: () => null,
        error: (_, __) => null,
      ),
    );
  }

  // ✅ Format last message preview text
  String _lastMessagePreview(ChatMessageEntity msg) {
    if (msg.isDeleted) return '🚫 Message deleted';
    switch (msg.messageType) {
      case MessageType.image:
        return '📷 Photo';
      case MessageType.video:
        return '🎥 Video';
      case MessageType.audio:
        return '🎵 Audio';
      case MessageType.voice:
        return '🎙 Voice message';
      case MessageType.file:
        return '📎 ${msg.fileName ?? 'File'}';
      default:
        return msg.content ?? '';
    }
  }

  // ✅ Format time — show time if today, date if older
  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final isToday =
        dt.year == now.year && dt.month == now.month && dt.day == now.day;
    if (isToday) {
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      return '$h:$m';
    }
    // Yesterday
    final yesterday = now.subtract(const Duration(days: 1));
    if (dt.year == yesterday.year &&
        dt.month == yesterday.month &&
        dt.day == yesterday.day) {
      return 'Yesterday';
    }
    // Older — show date
    return '${dt.day}/${dt.month}';
  }
}