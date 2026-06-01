import '../../domain/entities/chat_message_entity.dart';

class ReplyPreviewModel extends ReplyPreviewEntity {
  const ReplyPreviewModel({
    required super.messageId,
    required super.senderId,
    super.content,
    required super.messageType,
  });

  factory ReplyPreviewModel.fromJson(Map<String, dynamic> json) {
    return ReplyPreviewModel(
      messageId: json['message_id'] as int,
      senderId: json['sender_id'] as int,
      content: json['content'] as String?,
      messageType: json['message_type'] as String? ?? 'text',
    );
  }
}

class ChatMessageModel extends ChatMessageEntity {
  const ChatMessageModel({
    required super.messageId,
    required super.groupId,
    required super.companyId,
    required super.senderId,
    super.senderName,
    required super.messageType,
    super.content,
    super.fileUrl,
    super.fileName,
    super.fileSize,
    super.durationSecs,
    super.mediaThumbnail,
    super.replyToId,
    super.replyTo,
    required super.isDeleted,
    required super.isRead,
    required super.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      messageId: json['message_id'] as int,
      groupId: json['group_id'] as int,
      companyId: json['company_id'] as int,
      senderId: json['sender_id'] as int,
      senderName: json['sender_name'] as String?,
      messageType: _parseType(json['message_type'] as String? ?? 'text'),
      content: json['content'] as String?,
      fileUrl: json['file_url'] as String?,
      fileName: json['file_name'] as String?,
      fileSize: json['file_size'] as int?,
      durationSecs: json['duration_secs'] as int?,
      mediaThumbnail: json['media_thumbnail'] as String?,
      replyToId: json['reply_to_id'] as int?,
      replyTo: json['reply_to'] != null
          ? ReplyPreviewModel.fromJson(json['reply_to'] as Map<String, dynamic>)
          : null,
      isDeleted: json['is_deleted'] as bool? ?? false,
      isRead: json['is_read'] as bool? ?? false,
      createdAt:
          DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }
  /////////////////////////////////////////////////////////////////////////////
  /// Build from incoming WebSocket new_message payload
  /// /////////////////////////////////////////////////////////////////////////
  factory ChatMessageModel.fromWsPayload(Map<String, dynamic> p) {
    return ChatMessageModel(
      messageId: p['message_id'] as int,
      groupId: p['group_id'] as int,
      ////////////////////////////////
      ///// not sent in WS payload company
      ///////////////////////////////
      companyId: 0,
      senderId: p['sender_id'] as int,
      senderName: p['sender_name'] as String?,
      messageType: _parseType(p['message_type'] as String? ?? 'text'),
      content: p['content'] as String?,
      fileUrl: p['file_url'] as String?,
      fileName: p['file_name'] as String?,
      fileSize: p['file_size'] as int?,
      durationSecs: p['duration_secs'] as int?,
      replyToId: p['reply_to_id'] as int?,
      isDeleted: false,
      isRead: false,
      createdAt:
          DateTime.tryParse(p['created_at'] as String? ?? '') ?? DateTime.now(),
    );
  }

  static MessageType _parseType(String t) => switch (t) {
    'image' => MessageType.image,
    'video' => MessageType.video,
    'audio' => MessageType.audio,
    'voice' => MessageType.voice,
    'file' => MessageType.file,
    _ => MessageType.text,
  };
}
