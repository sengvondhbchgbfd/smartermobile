import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/chat_message_entity.dart';

class ReplyBar extends StatelessWidget {
  final ChatMessageEntity message;
  final VoidCallback onCancel;
  const ReplyBar({super.key, required this.message, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    final content = message.isDeleted
        ? 'Deleted message'
        : (message.content ?? _typeLabel(message.messageType));

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
      decoration: const BoxDecoration(
        color: Color(0xFF1a2d3e),
        border: Border(left: BorderSide(color: Color(0xFF3a7bd5), width: 3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.senderName ?? 'Unknown',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5caeff),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  content,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF8a9bb0),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onCancel,
            icon: const Icon(
              Icons.close_rounded,
              color: Color(0xFF8a9bb0),
              size: 20,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  String _typeLabel(MessageType t) {
    switch (t) {
      case MessageType.image:
        return '📷 Photo';
      case MessageType.video:
        return '🎥 Video';
      case MessageType.audio:
        return '🎵 Audio';
      case MessageType.voice:
        return '🎙 Voice note';
      case MessageType.file:
        return '📎 File';
      default:
        return 'Message';
    }
  }
}

//============================================================================
// chat input bar
//============================================================================

class ChatInputBar extends StatefulWidget {
  final ChatMessageEntity? replyTarget;
  final VoidCallback? onCancelReply;
  final Future<void> Function(String text, {int? replyToId}) onSendText;
  final Future<void> Function(File file, {int? replyToId}) onSendImage;
  final Future<void> Function(File file, {int? replyToId}) onSendVideo;
  final Future<void> Function(File file, {bool isVoice, int? replyToId})
  onSendAudio;
  final Future<void> Function(File file, {int? replyToId}) onSendFile;

  const ChatInputBar({
    super.key,
    this.replyTarget,
    this.onCancelReply,
    required this.onSendText,
    required this.onSendImage,
    required this.onSendVideo,
    required this.onSendAudio,
    required this.onSendFile,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final _ctrl = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(() {
      final has = _ctrl.text.trim().isNotEmpty;
      if (has != _hasText) setState(() => _hasText = has);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _send() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    widget.onSendText(text, replyToId: widget.replyTarget?.messageId);
    _ctrl.clear();
    widget.onCancelReply?.call();
  }

  void _showAttachMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF17212b),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 4),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF2a3f52),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _AttachOption(
                    icon: Icons.photo_library_rounded,
                    label: 'Gallery',
                    color: const Color(0xFF5caeff),
                    onTap: () async {
                      Navigator.pop(context);
                      await _pickImage();
                    },
                  ),
                  _AttachOption(
                    icon: Icons.camera_alt_rounded,
                    label: 'Camera',
                    color: const Color(0xFF4daf7c),
                    onTap: () async {
                      Navigator.pop(context);
                      await _captureImage();
                    },
                  ),
                  _AttachOption(
                    icon: Icons.video_library_rounded,
                    label: 'Video',
                    color: const Color(0xFFaf4d7c),
                    onTap: () async {
                      Navigator.pop(context);
                      await _pickVideo();
                    },
                  ),
                  _AttachOption(
                    icon: Icons.insert_drive_file_rounded,
                    label: 'File',
                    color: const Color(0xFFaf8f4d),
                    onTap: () async {
                      Navigator.pop(context);
                      await _pickFile();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final xfile = await picker.pickImage(source: ImageSource.gallery);
    if (xfile == null) return;
    widget.onSendImage(
      File(xfile.path),
      replyToId: widget.replyTarget?.messageId,
    );
    widget.onCancelReply?.call();
  }

  Future<void> _captureImage() async {
    final picker = ImagePicker();
    final xfile = await picker.pickImage(source: ImageSource.camera);
    if (xfile == null) return;
    widget.onSendImage(
      File(xfile.path),
      replyToId: widget.replyTarget?.messageId,
    );
    widget.onCancelReply?.call();
  }

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final xfile = await picker.pickVideo(source: ImageSource.gallery);
    if (xfile == null) return;
    widget.onSendVideo(
      File(xfile.path),
      replyToId: widget.replyTarget?.messageId,
    );
    widget.onCancelReply?.call();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null || result.files.isEmpty) return;
    final path = result.files.single.path;
    if (path == null) return;
    widget.onSendFile(File(path), replyToId: widget.replyTarget?.messageId);
    widget.onCancelReply?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.replyTarget != null)
          ReplyBar(
            message: widget.replyTarget!,
            onCancel: () => widget.onCancelReply?.call(),
          ),
        Container(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          decoration: const BoxDecoration(
            color: Color(0xFF17212b),
            border: Border(
              top: BorderSide(color: Color(0xFF1f3040), width: 0.5),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                onPressed: _showAttachMenu,
                icon: const Icon(
                  Icons.attach_file_rounded,
                  color: Color(0xFF8a9bb0),
                ),
                padding: const EdgeInsets.all(6),
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 120),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0d1923),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: const Color(0xFF1f3040),
                      width: 0.5,
                    ),
                  ),
                  child: TextField(
                    controller: _ctrl,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    style: const TextStyle(
                      color: Color(0xFFe8eaed),
                      fontSize: 14.5,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Write a message…',
                      hintStyle: TextStyle(color: Color(0xFF8a9bb0)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _send,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _hasText
                        ? const Color(0xFF3a7bd5)
                        : const Color(0xFF2a3f52),
                  ),
                  child: Icon(
                    _hasText ? Icons.send_rounded : Icons.mic_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

//============================================================================
//
//============================================================================

class _AttachOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _AttachOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.15),
          ),
          child: Icon(icon, color: color, size: 26),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12.5, color: Color(0xFF8a9bb0)),
        ),
      ],
    ),
  );
}
