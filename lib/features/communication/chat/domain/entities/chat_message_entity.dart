import 'package:equatable/equatable.dart';

enum MessageType { text, image, video, audio, voice, file }

class ReplyPreviewEntity extends Equatable {
  final int messageId;
  final int senderId;
  final String? content;
  final String messageType;

  const ReplyPreviewEntity({
    required this.messageId,
    required this.senderId,
    this.content,
    required this.messageType,
  });

  @override
  List<Object> get props => [messageId];
}

class ChatMessageEntity extends Equatable {
  final int messageId;
  final int groupId;
  final int companyId;
  final int senderId;
  final String? senderName;
  final MessageType messageType;
  final String? content;
  final String? fileUrl;
  final String? fileName;
  final int? fileSize;
  final int? durationSecs;
  final String? mediaThumbnail;
  final int? replyToId;
  final ReplyPreviewEntity? replyTo;
  final bool isDeleted;
  final bool isRead;
  final DateTime createdAt;

  const ChatMessageEntity({
    required this.messageId,
    required this.groupId,
    required this.companyId,
    required this.senderId,
    this.senderName,
    required this.messageType,
    this.content,
    this.fileUrl,
    this.fileName,
    this.fileSize,
    this.durationSecs,
    this.mediaThumbnail,
    this.replyToId,
    this.replyTo,
    required this.isDeleted,
    required this.isRead,
    required this.createdAt,
  });
  @override
  List<Object?> get props => [messageId, groupId, companyId];
}
