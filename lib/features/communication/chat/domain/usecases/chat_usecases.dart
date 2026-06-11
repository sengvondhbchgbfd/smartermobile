import 'dart:io';
import '../entities/chat_group_entity.dart';
import '../entities/chat_member_entity.dart';
import '../entities/chat_message_entity.dart';
import '../entities/ws_event_entity.dart';
import '../repositories/chat_repository.dart';

// ── Groups ─────────────────────────────────────────────────────────────────

class GetMyGroupsUseCase {
  final ChatRepository repo;
  const GetMyGroupsUseCase(this.repo);
  Future<List<ChatGroupEntity>> call() => repo.getMyGroups();
}

class GetGroupUseCase {
  final ChatRepository repo;
  const GetGroupUseCase(this.repo);
  Future<ChatGroupEntity> call(int groupId) => repo.getGroup(groupId);
}

class CreateGroupUseCase {
  final ChatRepository repo;
  const CreateGroupUseCase(this.repo);
  Future<ChatGroupEntity> call({
    required String groupName,
    required List<int> memberIds,
  }) => repo.createGroup(
    groupName: groupName,
    chatType: 'group',
    memberIds: memberIds,
  );
}

class CreateDirectChatUseCase {
  final ChatRepository repo;
  const CreateDirectChatUseCase(this.repo);
  Future<ChatGroupEntity> call(int targetStaffId) =>
      repo.createDirectChat(targetStaffId: targetStaffId);
}

class DeleteGroupUseCase {
  final ChatRepository repo;
  const DeleteGroupUseCase(this.repo);
  Future<void> call(int groupId) => repo.deleteGroup(groupId);
}

// ── Members ────────────────────────────────────────────────────────────────

class GetMembersUseCase {
  final ChatRepository repo;
  const GetMembersUseCase(this.repo);
  Future<List<ChatMemberEntity>> call(int groupId) => repo.getMembers(groupId);
}

class AddMembersUseCase {
  final ChatRepository repo;
  const AddMembersUseCase(this.repo);
  Future<void> call({required int groupId, required List<int> staffIds}) =>
      repo.addMembers(groupId: groupId, staffIds: staffIds);
}

class RemoveMemberUseCase {
  final ChatRepository repo;
  const RemoveMemberUseCase(this.repo);
  Future<void> call({required int groupId, required int staffId}) =>
      repo.removeMember(groupId: groupId, staffId: staffId);
}

class GetOnlineMembersUseCase {
  final ChatRepository repo;
  const GetOnlineMembersUseCase(this.repo);
  Future<List<int>> call(int groupId) => repo.getOnlineMembers(groupId);
}

// ── Messages ───────────────────────────────────────────────────────────────

class GetMessagesUseCase {
  final ChatRepository repo;
  const GetMessagesUseCase(this.repo);
  Future<List<ChatMessageEntity>> call({
    required int groupId,
<<<<<<< HEAD
    int? beforeId = 0,
    int limit = 50,
  }) => repo.getMessages(groupId: groupId, beforeId: beforeId, limit: limit);
=======
    int skip = 0,
    int limit = 50,
  }) => repo.getMessages(groupId: groupId, skip: skip, limit: limit);
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
}

class SendTextMessageUseCase {
  final ChatRepository repo;
  const SendTextMessageUseCase(this.repo);
  Future<ChatMessageEntity> call({
    required int groupId,
    required String content,
    int? replyToId,
  }) => repo.sendTextMessage(
    groupId: groupId,
    content: content,
    replyToId: replyToId,
  );
}

class SendImageUseCase {
  final ChatRepository repo;
  const SendImageUseCase(this.repo);
  Future<ChatMessageEntity> call({
    required int groupId,
    required File file,
    int? replyToId,
  }) => repo.sendImage(groupId: groupId, file: file, replyToId: replyToId);
}

class SendVideoUseCase {
  final ChatRepository repo;
  const SendVideoUseCase(this.repo);
  Future<ChatMessageEntity> call({
    required int groupId,
    required File file,
    int? replyToId,
  }) => repo.sendVideo(groupId: groupId, file: file, replyToId: replyToId);
}

class SendAudioUseCase {
  final ChatRepository repo;
  const SendAudioUseCase(this.repo);
  Future<ChatMessageEntity> call({
    required int groupId,
    required File file,
    int? replyToId,
  }) => repo.sendAudio(groupId: groupId, file: file, replyToId: replyToId);
}

class SendVoiceUseCase {
  final ChatRepository repo;
  const SendVoiceUseCase(this.repo);
  Future<ChatMessageEntity> call({
    required int groupId,
    required File file,
    int? replyToId,
  }) => repo.sendVoice(groupId: groupId, file: file, replyToId: replyToId);
}

class SendFileUseCase {
  final ChatRepository repo;
  const SendFileUseCase(this.repo);
  Future<ChatMessageEntity> call({
    required int groupId,
    required File file,
    int? replyToId,
  }) => repo.sendFile(groupId: groupId, file: file, replyToId: replyToId);
}

class MarkMessageReadUseCase {
  final ChatRepository repo;
  const MarkMessageReadUseCase(this.repo);
  Future<void> call({required int messageId}) =>
      repo.markMessageRead(messageId: messageId);
}

class MarkAllReadUseCase {
  final ChatRepository repo;
  const MarkAllReadUseCase(this.repo);
  Future<void> call(int groupId) => repo.markAllRead(groupId);
}

class GetUnreadCountUseCase {
  final ChatRepository repo;
  const GetUnreadCountUseCase(this.repo);
  Future<int> call(int groupId) => repo.getUnreadCount(groupId);
}

class DeleteMessageUseCase {
  final ChatRepository repo;
  const DeleteMessageUseCase(this.repo);
  Future<void> call({required int groupId, required int messageId}) =>
      repo.deleteMessage(groupId: groupId, messageId: messageId);
}

// ── WebSocket ──────────────────────────────────────────────────────────────

class ConnectToChatUseCase {
  final ChatRepository repo;
  const ConnectToChatUseCase(this.repo);
  Stream<WsEventEntity> call(int groupId) => repo.connectToGroup(groupId);
}

class DisconnectFromChatUseCase {
  final ChatRepository repo;
  const DisconnectFromChatUseCase(this.repo);
  void call(int groupId) => repo.disconnectFromGroup(groupId);
}
