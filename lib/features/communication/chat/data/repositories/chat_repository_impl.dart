import 'dart:io';
import '../../domain/entities/chat_group_entity.dart';
import '../../domain/entities/chat_member_entity.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/ws_event_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDatasource _remote;
  const ChatRepositoryImpl(this._remote);
  // ── Groups ───────────────────────────────────────────────────────────────

  @override
  Future<ChatGroupEntity> createGroup({
    required String groupName,
    required String chatType,
    required List<int> memberIds,
  }) => _remote.createGroup({
    'group_name': groupName,
    'chat_type': chatType,
    'member_ids': memberIds,
  });

  @override
  Future<ChatGroupEntity> createDirectChat({required int targetStaffId}) =>
      _remote.createDirectChat(targetStaffId);

  @override
  Future<List<ChatGroupEntity>> getMyGroups() => _remote.getMyGroups();

  @override
  Future<List<ChatGroupEntity>> getAllGroups() => _remote.getAllGroups();
  @override
  Future<ChatGroupEntity> getGroup(int groupId) => _remote.getGroup(groupId);
  @override
  Future<void> deleteGroup(int groupId) => _remote.deleteGroup(groupId);

  // ── Members ──────────────────────────────────────────────────────────────

  @override
  Future<List<ChatMemberEntity>> getMembers(int groupId) =>
      _remote.getMembers(groupId);

  @override
  Future<void> addMembers({
    required int groupId,
    required List<int> staffIds,
  }) => _remote.addMembers(groupId, staffIds);

  @override
  Future<void> removeMember({required int groupId, required int staffId}) =>
      _remote.removeMember(groupId, staffId);

  @override
  Future<List<int>> getOnlineMembers(int groupId) =>
      _remote.getOnlineMembers(groupId);

  // ── Messages ─────────────────────────────────────────────────────────────

  @override
  Future<ChatMessageEntity> sendTextMessage({
    required int groupId,
    required String content,
    int? replyToId,
  }) => _remote.sendTextMessage(groupId, content, replyToId);

  @override
  Future<ChatMessageEntity> sendImage({
    required int groupId,
    required File file,
    int? replyToId,
  }) => _remote.sendMedia(groupId, file.path, 'images', replyToId);

  @override
  Future<ChatMessageEntity> sendVideo({
    required int groupId,
    required File file,
    int? replyToId,
  }) => _remote.sendMedia(groupId, file.path, 'videos', replyToId);

  @override
  Future<ChatMessageEntity> sendAudio({
    required int groupId,
    required File file,
    int? replyToId,
  }) => _remote.sendMedia(groupId, file.path, 'audio', replyToId);

  @override
  Future<ChatMessageEntity> sendVoice({
    required int groupId,
    required File file,
    int? replyToId,
  }) => _remote.sendMedia(groupId, file.path, 'voice', replyToId);

  @override
  Future<ChatMessageEntity> sendFile({
    required int groupId,
    required File file,
    int? replyToId,
  }) => _remote.sendMedia(groupId, file.path, 'files', replyToId);

  @override
  Future<List<ChatMessageEntity>> getMessages({
    required int groupId,
<<<<<<< HEAD
    int? beforeId = 0,
    int limit = 50,
  }) => _remote.getMessages(groupId, beforeId, limit);
=======
    int skip = 0,
    int limit = 50,
  }) => _remote.getMessages(groupId, skip, limit);
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c

  @override
  Future<void> markMessageRead({required int messageId}) =>
      _remote.markMessageRead(messageId);

  @override
  Future<void> markAllRead(int groupId) => _remote.markAllRead(groupId);

  @override
  Future<int> getUnreadCount(int groupId) => _remote.getUnreadCount(groupId);

  @override
  Future<void> deleteMessage({required int groupId, required int messageId}) =>
      _remote.deleteMessage(groupId, messageId);

  // ── WebSocket ─────────────────────────────────────────────────────────────

  @override
  Stream<WsEventEntity> connectToGroup(int groupId) =>
      _remote.connectWs(groupId);

  @override
  void disconnectFromGroup(int groupId) => _remote.disconnectWs(groupId);
}
