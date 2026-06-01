import 'dart:io';

import 'package:frontendmobile/features/communication/chat/domain/entities/chat_group_entity.dart';
import 'package:frontendmobile/features/communication/chat/domain/entities/chat_member_entity.dart';
import 'package:frontendmobile/features/communication/chat/domain/entities/chat_message_entity.dart';
import 'package:frontendmobile/features/communication/chat/domain/entities/ws_event_entity.dart';

abstract class ChatRepository {
  //--------Group------------|
  Future<ChatGroupEntity> createGroup({
    required String groupName,
    required String chatType,
    required List<int> memberIds,
  });
  Future<ChatGroupEntity> createDirectChat({required int targetStaffId});
  Future<List<ChatGroupEntity>> getMyGroups();

  Future<List<ChatGroupEntity>> getAllGroups();
  Future<ChatGroupEntity> getGroup(int groupId);
  Future<void> deleteGroup(int groupId);

  //-------Members-----------|
  Future<List<ChatMemberEntity>> getMembers(int groupId);
  Future<void> addMembers({required int groupId, required List<int> staffIds});
  Future<void> removeMember({required int groupId, required int staffId});
  Future<List<int>> getOnlineMembers(int groupId);
  //------Messages ---------|
  Future<ChatMessageEntity> sendTextMessage({
    required int groupId,
    required String content,
    int? replyToId,
  });

  Future<ChatMessageEntity> sendImage({
    required int groupId,
    required File file,
    int? replyToId,
  });

  Future<ChatMessageEntity> sendVideo({
    required int groupId,
    required File file,
    int? replyToId,
  });

  Future<ChatMessageEntity> sendAudio({
    required int groupId,
    required File file,
    int? replyToId,
  });

  Future<ChatMessageEntity> sendVoice({
    required int groupId,
    required File file,
    int? replyToId,
  });

  Future<ChatMessageEntity> sendFile({
    required int groupId,
    required File file,
    int? replyToId,
  });

  Future<List<ChatMessageEntity>> getMessages({
    required int groupId,
    int? beforeId,
    int limit = 50,
  });


  Future<void> markMessageRead({required int messageId});
  Future<void> markAllRead(int groupId);
  Future<int> getUnreadCount(int groupId);
  Future<void> deleteMessage({required int groupId, required int messageId});
  
  
  // ── WebSocket ───────|

  Stream<WsEventEntity> connectToGroup(int groupId);
  void disconnectFromGroup(int groupId);
}
