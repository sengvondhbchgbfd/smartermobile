import 'package:flutter/material.dart';
import 'package:frontendmobile/features/communication/chat/presentation/widgets/components/bubble/chat_context_action.dart';
import 'package:frontendmobile/features/communication/chat/presentation/widgets/components/bubble/chat_deleted_body.dart';
import 'package:frontendmobile/features/communication/chat/presentation/widgets/components/bubble/chat_file_body.dart';
import 'package:frontendmobile/features/communication/chat/presentation/widgets/components/bubble/chat_image_body.dart';
import 'package:frontendmobile/features/communication/chat/presentation/widgets/components/bubble/chat_reply_preview.dart';
import 'package:frontendmobile/features/communication/chat/presentation/widgets/components/bubble/chat_sender_name.dart';
import 'package:frontendmobile/features/communication/chat/presentation/widgets/components/bubble/chat_text_body.dart';
import 'package:frontendmobile/features/communication/chat/presentation/widgets/components/bubble/chat_video_body.dart';
import '../../domain/entities/chat_message_entity.dart';
import 'voice_message_widget.dart';

//============================================================================
//
//============================================================================
class ChatBubble extends StatelessWidget {
  final ChatMessageEntity message;
  final bool isMe;
  final bool showSenderName;
  final VoidCallback? onReply;
  final VoidCallback? onDelete;
  final VoidCallback? onTapReply;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.showSenderName = false,
    this.onReply,
    this.onDelete,
    this.onTapReply,
  });
  @override
  //============================================================================
  //
  //============================================================================
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _showContextMenu(context),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        //======================================================================
        //
        //======================================================================
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          //====================================================================
          //
          //====================================================================
          child: Container(
            margin: EdgeInsets.only(
              top: 2,
              bottom: 2,
              left: isMe ? 48 : 8,
              right: isMe ? 8 : 48,
            ),
            //==================================================================
            //
            //==================================================================
            decoration: BoxDecoration(
              color: isMe ? const Color(0xFF2b5278) : const Color(0xFF182533),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isMe ? 16 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 16),
              ),
            ),

            //==================================================================
            //
            //==================================================================
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isMe ? 16 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 16),
              ),
              //================================================================
              //
              //================================================================
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isMe && showSenderName)
                    ChatSenderName(name: message.senderName ?? 'Unknown'),
                  if (message.replyTo != null)
                    ChatReplyPreview(
                      reply: message.replyTo!,
                      onTap: onTapReply,
                    ),
                  _buildBody(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  //============================================================================
  //
  //============================================================================

  Widget _buildBody(BuildContext context) {
    if (message.isDeleted) return ChatDeletedBody(isMe: isMe);

    switch (message.messageType) {
      case MessageType.image:
        return ChatImageBody(message: message, isMe: isMe);
      case MessageType.video:
        return ChatVideoBody(message: message, isMe: isMe);
      case MessageType.audio:
      case MessageType.voice:
        return VoiceMessageWidget(message: message, isMe: isMe);
      case MessageType.file:
        return ChatFileBody(message: message, isMe: isMe);
      default:
        return ChatTextBody(message: message, isMe: isMe);
    }
  }

  ////////////////////////////////////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////////////////////////////////

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF17212b),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
<<<<<<< HEAD
=======

>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (onReply != null)
                ChatContextAction(
                  icon: Icons.reply_rounded,
                  label: 'Reply',
                  onTap: () {
                    Navigator.pop(context);
                    onReply!();
                  },
                ),
              if (message.messageType == MessageType.text && !message.isDeleted)
                ChatContextAction(
                  icon: Icons.copy_rounded,
                  label: 'Copy',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              if (isMe && onDelete != null && !message.isDeleted)
                ChatContextAction(
                  icon: Icons.delete_outline_rounded,
                  label: 'Delete',
                  color: Colors.redAccent,
                  onTap: () {
                    Navigator.pop(context);
                    onDelete!();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
