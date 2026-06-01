import 'package:frontendmobile/features/communication/chat/domain/entities/chat_member_entity.dart';
import 'package:frontendmobile/features/communication/chat/domain/entities/chat_message_entity.dart';

class ChatState {
  final List<ChatMessageEntity> messages;
  final List<ChatMemberEntity> members;
  final List<int> onlineStaffIds;
  final bool loadingMessages;
  final bool sendingMessage;
  final String? error;
  final bool hasMore;
  final int? oldestMessageId;

  const ChatState({
    this.messages = const [],
    this.members = const [],
    this.onlineStaffIds = const [],
    this.loadingMessages = false,
    this.sendingMessage = false,
    this.error,
    this.hasMore = true,
    this.oldestMessageId, // ← add
  });

  ChatState copyWith({
    List<ChatMessageEntity>? messages,
    List<ChatMemberEntity>? members,
    List<int>? onlineStaffIds,
    bool? loadingMessages,
    bool? sendingMessage,
    String? error,
    bool? hasMore,
    bool clearError = false,
    int? oldestMessageId,
    bool clearOldestId = false,
  }) => ChatState(
    messages: messages ?? this.messages,
    members: members ?? this.members,
    onlineStaffIds: onlineStaffIds ?? this.onlineStaffIds,
    loadingMessages: loadingMessages ?? this.loadingMessages,
    sendingMessage: sendingMessage ?? this.sendingMessage,
    error: clearError ? null : (error ?? this.error),
    hasMore: hasMore ?? this.hasMore,
    oldestMessageId: clearOldestId
        ? null
        : (oldestMessageId ?? this.oldestMessageId), // ← add
  );
}
