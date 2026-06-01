import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/config/di/dependency_injection.dart';
import 'package:frontendmobile/features/communication/chat/data/datasources/chat_remote_datasource_impl.dart';
import 'package:frontendmobile/features/communication/chat/presentation/providers/chat_state.dart';

import '../../data/datasources/chat_remote_datasource.dart';
import '../../data/models/chat_message_model.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/entities/chat_group_entity.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/ws_event_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/usecases/chat_usecases.dart';

// ── Chat DI Base Layer ────────────────────────────────────────────────────────

final chatRemoteDatasourceProvider = FutureProvider<ChatRemoteDatasource>((
  ref,
) async {
  final dio = await ref.watch(dioClientProvider.future);
  final storage = ref.watch(secureStorageProvider);
  return ChatRemoteDatasourceImpl(client: dio, storage: storage);
});

final chatRepositoryProvider = FutureProvider<ChatRepository>((ref) async {
  final datasource = await ref.watch(chatRemoteDatasourceProvider.future);
  return ChatRepositoryImpl(datasource);
});

// ── Use-case providers ────────────────────────────────────────────────────────

final getMyGroupsUCProvider = Provider<GetMyGroupsUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider).requireValue;
  return GetMyGroupsUseCase(repository);
});

////////////////////////////////////////////////////////////////////////////////

final getGroupUCProvider = Provider<GetGroupUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider).requireValue;
  return GetGroupUseCase(repository);
});

final createGroupUCProvider = Provider<CreateGroupUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider).requireValue;
  return CreateGroupUseCase(repository);
});

final createDirectChatUCProvider = Provider<CreateDirectChatUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider).requireValue;
  return CreateDirectChatUseCase(repository);
});

final deleteGroupUCProvider = Provider<DeleteGroupUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider).requireValue;
  return DeleteGroupUseCase(repository);
});

final getMembersUCProvider = Provider<GetMembersUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider).requireValue;
  return GetMembersUseCase(repository);
});

final addMembersUCProvider = Provider<AddMembersUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider).requireValue;
  return AddMembersUseCase(repository);
});

final removeMemberUCProvider = Provider<RemoveMemberUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider).requireValue;
  return RemoveMemberUseCase(repository);
});

final getOnlineMembersUCProvider = Provider<GetOnlineMembersUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider).requireValue;
  return GetOnlineMembersUseCase(repository);
});

final getMessagesUCProvider = Provider<GetMessagesUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider).requireValue;
  return GetMessagesUseCase(repository);
});

final sendTextUCProvider = Provider<SendTextMessageUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider).requireValue;
  return SendTextMessageUseCase(repository);
});

final sendImageUCProvider = Provider<SendImageUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider).requireValue;
  return SendImageUseCase(repository);
});

final sendVideoUCProvider = Provider<SendVideoUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider).requireValue;
  return SendVideoUseCase(repository);
});

final sendAudioUCProvider = Provider<SendAudioUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider).requireValue;
  return SendAudioUseCase(repository);
});

final sendVoiceUCProvider = Provider<SendVoiceUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider).requireValue;
  return SendVoiceUseCase(repository);
});

final sendFileUCProvider = Provider<SendFileUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider).requireValue;
  return SendFileUseCase(repository);
});

final markReadUCProvider = Provider<MarkMessageReadUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider).requireValue;
  return MarkMessageReadUseCase(repository);
});

final markAllReadUCProvider = Provider<MarkAllReadUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider).requireValue;
  return MarkAllReadUseCase(repository);
});

final getUnreadCountUCProvider = Provider<GetUnreadCountUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider).requireValue;
  return GetUnreadCountUseCase(repository);
});

final deleteMessageUCProvider = Provider<DeleteMessageUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider).requireValue;
  return DeleteMessageUseCase(repository);
});

final connectChatUCProvider = Provider<ConnectToChatUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider).requireValue;
  return ConnectToChatUseCase(repository);
});

final disconnectChatUCProvider = Provider<DisconnectFromChatUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider).requireValue;
  return DisconnectFromChatUseCase(repository);
});

// ─────────────────────────────────────────────────────────────────────────────
// Group list Provider
// ─────────────────────────────────────────────────────────────────────────────

final groupListProvider = FutureProvider<List<ChatGroupEntity>>((ref) async {
  final uc = ref.watch(getMyGroupsUCProvider);
  return uc();
});

// ─────────────────────────────────────────────────────────────────────────────
// Current staff id
// ─────────────────────────────────────────────────────────────────────────────

final currentStaffIdProvider = FutureProvider<int>((ref) async {
  final storage = ref.watch(secureStorageProvider);
  final info = await storage.getUserInfo();
  return info?.staffId ?? 0;
});

final currentUserIdProvider = FutureProvider<int>((ref) async {
  final storage = ref.watch(secureStorageProvider);
  final info = await storage.getUserInfo();
  return info?.userId ?? 0;
});

// ─────────────────────────────────────────────────────────────────────────────
// Per-group chat state Notifier
// ─────────────────────────────────────────────────────────────────────────────

class ChatNotifier extends StateNotifier<ChatState> {
  final int groupId;
  final int currentStaffId;
  final int currentUserId;
  final Set<int> _pendingLocalIds = {};

  final GetMessagesUseCase _getMessages;
  final SendTextMessageUseCase _sendText;
  final SendImageUseCase _sendImage;
  final SendVideoUseCase _sendVideo;
  final SendAudioUseCase _sendAudio;
  final SendVoiceUseCase _sendVoice;
  final SendFileUseCase _sendFile;
  final MarkMessageReadUseCase _markRead;
  final MarkAllReadUseCase _markAllRead;
  final DeleteMessageUseCase _deleteMessage;
  final GetMembersUseCase _getMembers;
  final GetOnlineMembersUseCase _getOnline;
  final ConnectToChatUseCase _connect;
  final DisconnectFromChatUseCase _disconnect;

  StreamSubscription<WsEventEntity>? _wsSub;

  ChatNotifier({
    required this.groupId,
    required this.currentStaffId,
    required this.currentUserId,
    required GetMessagesUseCase getMessages,
    required SendTextMessageUseCase sendText,
    required SendImageUseCase sendImage,
    required SendVideoUseCase sendVideo,
    required SendAudioUseCase sendAudio,
    required SendVoiceUseCase sendVoice,
    required SendFileUseCase sendFile,
    required MarkMessageReadUseCase markRead,
    required MarkAllReadUseCase markAllRead,
    required DeleteMessageUseCase deleteMessage,
    required GetMembersUseCase getMembers,
    required GetOnlineMembersUseCase getOnline,
    required ConnectToChatUseCase connect,
    required DisconnectFromChatUseCase disconnect,
  }) : _getMessages = getMessages,
       _sendText = sendText,
       _sendImage = sendImage,
       _sendVideo = sendVideo,
       _sendAudio = sendAudio,
       _sendVoice = sendVoice,
       _sendFile = sendFile,
       _markRead = markRead,
       _markAllRead = markAllRead,
       _deleteMessage = deleteMessage,
       _getMembers = getMembers,
       _getOnline = getOnline,
       _connect = connect,
       _disconnect = disconnect,
       super(const ChatState()) {
    _init();
  }

  Future<void> _init() async {
    await Future.wait([
      loadMessages(refresh: true),
      _loadMembers(),
      _loadOnline(),
    ]);
    _connectWs();
    _markAllRead(groupId).ignore();
  }

  // ── Load Messages ──────────────────────────────────────────────────────────

  Future<void> loadMessages({bool refresh = false}) async {
    if (state.loadingMessages) return;
    if (!refresh && !state.hasMore) return; // ← was missing this guard

    state = state.copyWith(
      loadingMessages: true,
      clearError: true,
      // reset cursor on refresh
      clearOldestId: refresh,
    );

    try {
      final fetched = await _getMessages(
        groupId: groupId,
        beforeId: refresh ? null : state.oldestMessageId,
        limit: 50,
      );

      final ordered = fetched.reversed.toList();
      final all = refresh ? ordered : [...state.messages, ...ordered];

      state = state.copyWith(
        messages: all,
        loadingMessages: false,
        hasMore: fetched.length == 50,
        // last item after reversing = oldest = next cursor
        oldestMessageId: fetched.isNotEmpty
            ? fetched
                  .last
                  .messageId // fetched is DESC from API, last = oldest
            : state.oldestMessageId,
      );
    } catch (e) {
      state = state.copyWith(loadingMessages: false, error: e.toString());
    }
  }

  Future<void> _loadMembers() async {
    try {
      state = state.copyWith(members: await _getMembers(groupId));
    } catch (_) {}
  }

  Future<void> _loadOnline() async {
    try {
      state = state.copyWith(onlineStaffIds: await _getOnline(groupId));
    } catch (_) {}
  }

  // ── WebSocket ──────────────────────────────────────────────────────────────

  void _connectWs() {
    _wsSub?.cancel();
    _wsSub = _connect(groupId).listen(
      _handleWsEvent,
      onError: (_) => Future.delayed(const Duration(seconds: 3), _connectWs),
    );
  }

  void _handleWsEvent(WsEventEntity event) {
    switch (event.eventType) {
      case WsEventType.newMessage:
        final msg = ChatMessageModel.fromWsPayload(event.payload);
        if (msg.senderId == currentUserId && _pendingLocalIds.isNotEmpty) {
          final localId = _pendingLocalIds.first; // ← localId defined here
          _pendingLocalIds.remove(localId);
          state = state.copyWith(
            messages: state.messages
                .map((m) => m.messageId == localId ? msg : m)
                .toList(),
          );
          break;
        }
        if (!state.messages.any((m) => m.messageId == msg.messageId)) {
          state = state.copyWith(messages: [msg, ...state.messages]);
        }
        break;

      case WsEventType.messageDeleted:
        final id = event.payload['message_id'] as int;
        _updateMessage(id, _asDeleted);
        break;

      case WsEventType.messageRead:
        final id = event.payload['message_id'] as int;
        _updateMessage(id, _asRead);
        break;

      case WsEventType.allMessagesRead:
        state = state.copyWith(messages: state.messages.map(_asRead).toList());
        break;

      case WsEventType.userOnline:
        final sid = event.payload['staff_id'] as int;
        if (!state.onlineStaffIds.contains(sid)) {
          state = state.copyWith(
            onlineStaffIds: [...state.onlineStaffIds, sid],
          );
        }
        break;

      case WsEventType.userOffline:
        final sid = event.payload['staff_id'] as int;
        state = state.copyWith(
          onlineStaffIds: state.onlineStaffIds
              .where((id) => id != sid)
              .toList(),
        );
        break;

      case WsEventType.membersAdded:
      case WsEventType.memberRemoved:
        _loadMembers();
        break;

      default:
        break;
    }
  }

  void _updateMessage(
    int id,
    ChatMessageEntity Function(ChatMessageEntity) transform,
  ) {
    state = state.copyWith(
      messages: state.messages
          .map((m) => m.messageId == id ? transform(m) : m)
          .toList(),
    );
  }

  ChatMessageEntity _asDeleted(ChatMessageEntity m) => ChatMessageModel(
    messageId: m.messageId,
    groupId: m.groupId,
    companyId: m.companyId,
    senderId: m.senderId,
    senderName: m.senderName,
    messageType: m.messageType,
    isDeleted: true,
    isRead: m.isRead,
    createdAt: m.createdAt,
  );

  ChatMessageEntity _asRead(ChatMessageEntity m) => ChatMessageModel(
    messageId: m.messageId,
    groupId: m.groupId,
    companyId: m.companyId,
    senderId: m.senderId,
    senderName: m.senderName,
    messageType: m.messageType,
    content: m.content,
    fileUrl: m.fileUrl,
    fileName: m.fileName,
    fileSize: m.fileSize,
    durationSecs: m.durationSecs,
    replyToId: m.replyToId,
    replyTo: m.replyTo,
    isDeleted: m.isDeleted,
    isRead: true,
    createdAt: m.createdAt,
  );

  // ── Outgoing Actions ───────────────────────────────────────────────────────

  Future<void> sendText(String content, {int? replyToId}) async {
    if (content.trim().isEmpty) return;
    final localId =
        DateTime.now().millisecondsSinceEpoch; // ← rename to localId

    _pendingLocalIds.add(localId);

    _pendingLocalIds.add(localId); // ← add here

    final optimisticMessage = ChatMessageModel(
      messageId: localId, // ← use localId
      groupId: groupId,
      companyId: 0,
      senderId: currentUserId, // ← fixed from previous step
      senderName: 'Me',
      messageType: MessageType.text,
      content: content,
      replyToId: replyToId,
      isDeleted: false,
      isRead: false,
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      messages: [optimisticMessage, ...state.messages],
      sendingMessage: true,
      clearError: true,
    );

    try {
      await _sendText(groupId: groupId, content: content, replyToId: replyToId);
      state = state.copyWith(sendingMessage: false);
    } catch (e) {
      _pendingLocalIds.remove(localId); // ← clean up on failure
      state = state.copyWith(
        messages: state.messages.where((m) => m.messageId != localId).toList(),
        sendingMessage: false,
        error: e.toString(),
      );
    }
  }

  Future<void> sendImage(File file, {int? replyToId}) async {
    final localId = DateTime.now().microsecondsSinceEpoch;

    final optimistic = ChatMessageModel(
      messageId: localId,
      groupId: groupId,
      companyId: 0,
      senderId: currentStaffId, // will fix isMe display temporarily
      senderName: 'Me',
      messageType: MessageType.image,
      fileUrl: file.path, // ← local file path renders in UI
      isDeleted: false,
      isRead: false,
      createdAt: DateTime.now(),
      replyToId: replyToId,
    );

    state = state.copyWith(
      messages: [optimistic, ...state.messages],
      sendingMessage: true,
      clearError: true,
    );
    try {
      final sent = await _sendImage(
        groupId: groupId,
        file: file,
        replyToId: replyToId,
      );
      state = state.copyWith(
        messages: state.messages
            .map((m) => m.messageId == localId ? sent : m)
            .toList(),
        sendingMessage: false,
      );
    } catch (e) {
      state = state.copyWith(
        messages: state.messages.where((m) => m.messageId != localId).toList(),
        sendingMessage: false,
        error: e.toString(),
      );
    }
  }

  Future<void> sendVideo(File file, {int? replyToId}) async {
    state = state.copyWith(sendingMessage: true, clearError: true);
    try {
      await _sendVideo(groupId: groupId, file: file, replyToId: replyToId);
      state = state.copyWith(sendingMessage: false);
    } catch (e) {
      state = state.copyWith(sendingMessage: false, error: e.toString());
    }
  }

  Future<void> sendAudio(
    File file, {
    bool isVoice = false,
    int? replyToId,
  }) async {
    state = state.copyWith(sendingMessage: true, clearError: true);
    try {
      if (isVoice) {
        await _sendVoice(groupId: groupId, file: file, replyToId: replyToId);
      } else {
        await _sendAudio(groupId: groupId, file: file, replyToId: replyToId);
      }
      state = state.copyWith(sendingMessage: false);
    } catch (e) {
      state = state.copyWith(sendingMessage: false, error: e.toString());
    }
  }

  Future<void> sendFile(File file, {int? replyToId}) async {
    state = state.copyWith(sendingMessage: true, clearError: true);
    try {
      await _sendFile(groupId: groupId, file: file, replyToId: replyToId);
      state = state.copyWith(sendingMessage: false);
    } catch (e) {
      state = state.copyWith(sendingMessage: false, error: e.toString());
    }
  }

  Future<void> deleteMessage(int messageId) async {
    try {
      await _deleteMessage(groupId: groupId, messageId: messageId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> markRead(int messageId) async {
    try {
      await _markRead(messageId: messageId);
    } catch (_) {}
  }

  @override
  void dispose() {
    _wsSub?.cancel();
    _disconnect(groupId);
    super.dispose();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Family provider — chatProvider(groupId)
// ✅ No empty/noop pattern — screen guards ensure providers are ready first
// ─────────────────────────────────────────────────────────────────────────────

final chatProvider = StateNotifierProvider.family<ChatNotifier, ChatState, int>(
  (ref, groupId) {
    return ChatNotifier(
      groupId: groupId,
      currentStaffId: ref.watch(currentStaffIdProvider).requireValue,
      currentUserId: ref.watch(currentUserIdProvider).requireValue,
      getMessages: ref.watch(getMessagesUCProvider),
      sendText: ref.watch(sendTextUCProvider),
      sendImage: ref.watch(sendImageUCProvider),
      sendVideo: ref.watch(sendVideoUCProvider),
      sendAudio: ref.watch(sendAudioUCProvider),
      sendVoice: ref.watch(sendVoiceUCProvider),
      sendFile: ref.watch(sendFileUCProvider),
      markRead: ref.watch(markReadUCProvider),
      markAllRead: ref.watch(markAllReadUCProvider),
      deleteMessage: ref.watch(deleteMessageUCProvider),
      getMembers: ref.watch(getMembersUCProvider),
      getOnline: ref.watch(getOnlineMembersUCProvider),
      connect: ref.watch(connectChatUCProvider),
      disconnect: ref.watch(disconnectChatUCProvider),
    );
  },
);

// ─────────────────────────────────────────────────────────────────────────────
// Unread count per group
// ─────────────────────────────────────────────────────────────────────────────

final unreadCountProvider = FutureProvider.family<int, int>((
  ref,
  groupId,
) async {
  final uc = ref.watch(getUnreadCountUCProvider);
  return uc(groupId);
});
