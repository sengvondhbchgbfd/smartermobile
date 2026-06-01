// ─────────────────────────────────────────────────────────────────────────────
// Abstract contract
// ─────────────────────────────────────────────────────────────────────────────

import 'package:frontendmobile/features/communication/chat/data/models/chat_group_model.dart';
import 'package:frontendmobile/features/communication/chat/data/models/chat_member_model.dart';
import 'package:frontendmobile/features/communication/chat/data/models/chat_message_model.dart';
import 'package:frontendmobile/features/communication/chat/domain/entities/ws_event_entity.dart';

abstract class ChatRemoteDatasource {
  // Group
  Future<ChatGroupModel> createGroup(Map<String, dynamic> body);
  Future<ChatGroupModel> createDirectChat(int targetStaffId);

  Future<List<ChatGroupModel>> getMyGroups();

  Future<List<ChatGroupModel>> getAllGroups();
  Future<ChatGroupModel> getGroup(int groupId);
  Future<void> deleteGroup(int groupId);

  // Members
  Future<List<ChatMemberModel>> getMembers(int groupId);
  Future<void> addMembers(int groupId, List<int> staffId);
  Future<void> removeMember(int groupId, int staffId);
  Future<List<int>> getOnlineMembers(int groupId);

  // Message
  Future<ChatMessageModel> sendTextMessage(
    int groupId,
    String content,
    int? replyToId,
  );
  Future<ChatMessageModel> sendMedia(
    int groupId,
    String filePath,
    String endpoint,
    int? replyToId,
  );
  Future<List<ChatMessageModel>> getMessages(int groupId, int? beforeId, int limit);
  Future<void> markMessageRead(int messageId);
  Future<void> markAllRead(int groupId);
  Future<int> getUnreadCount(int groupId);
  Future<void> deleteMessage(int groupId, int messageId);
  // Websocket
  Stream<WsEventEntity> connectWs(int groupId);
  void disconnectWs(int groupId);
}
