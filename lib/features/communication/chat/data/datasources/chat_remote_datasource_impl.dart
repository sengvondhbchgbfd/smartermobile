import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frontendmobile/core/constants/ApiEndpoints.dart';
import 'package:frontendmobile/core/constants/api_constants.dart';
import 'package:frontendmobile/core/network/dio_client.dart';
import 'package:frontendmobile/core/storage/secure_storage_service.dart';
import 'package:frontendmobile/features/communication/chat/data/datasources/chat_remote_datasource.dart';
import 'package:frontendmobile/features/communication/chat/data/models/chat_group_model.dart';
import 'package:frontendmobile/features/communication/chat/data/models/chat_member_model.dart';
import 'package:frontendmobile/features/communication/chat/data/models/chat_message_model.dart';
import 'package:frontendmobile/features/communication/chat/domain/entities/ws_event_entity.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatRemoteDatasourceImpl implements ChatRemoteDatasource {
  final DioClient _client;
  final SecureStorageService _storage;

  //////////////////////////////////
  /// one WS channel per group
  /////////////////////////////////
  final Map<int, WebSocketChannel> _channels = {};

  ChatRemoteDatasourceImpl({
    required DioClient client,
    required SecureStorageService storage,
  }) : _client = client,
       _storage = storage;
  Dio get _dio => _client.dio;

  /////////////////////////////////
  /// Helper
  /////////////////////////////////

  T _parse<T>(Response res, T Function(Map<String, dynamic>) fromJson) {
    if (res.statusCode != null && res.statusCode! >= 400) {
      throw Exception(
        res.data is Map ? res.data['detail'] : 'Error ${res.statusCode}',
      );
    }
    return fromJson(res.data as Map<String, dynamic>);
  }

  List<T> _parseList<T>(
    Response res,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (res.statusCode != null && res.statusCode! >= 400) {
      throw Exception(
        res.data is Map ? res.data["detail"] : 'Error ${res.statusCode}',
      );
    }

    return (res.data as List)
        .map((e) => fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /////////////////////////////
  ///Group
  ////////////////////////////
  @override
  Future<ChatGroupModel> createGroup(Map<String, dynamic> body) async {
    final res = await _dio.post(ApiEndpoints.chatGroups, data: body);
    return _parse(res, ChatGroupModel.fromJson);
  }

  //////////////////////////
  ///
  ////////////////////////

  @override
  Future<ChatGroupModel> createDirectChat(int targetStaffId) async {
    final res = await _dio.post(
      ApiEndpoints.chatDirect,
      data: {'staff_id': targetStaffId},
    );
    return _parse(res, ChatGroupModel.fromJson);
  }

  //////////////////////////
  ///
  /////////////////////////
  @override
  Future<List<ChatGroupModel>> getMyGroups() async {
    final res = await _dio.get(ApiEndpoints.chatGroupsMy);
    return _parseList(res, ChatGroupModel.fromJson);
  }

  /////////////////////////
  ////
  ///////////////////////
  @override
  Future<List<ChatGroupModel>> getAllGroups() async {
    final res = await _dio.get(ApiEndpoints.chatGroups);
    return _parseList(res, ChatGroupModel.fromJson);
  }

  /////////////////////////
  ///
  ////////////////////////
  @override
  Future<ChatGroupModel> getGroup(int groupId) async {
    final res = await _dio.get(ApiEndpoints.chatGroupById(groupId));
    return _parse(res, ChatGroupModel.fromJson);
  }

  ////////////////////////
  ///
  ///////////////////////
  @override
  Future<void> deleteGroup(int groupId) =>
      _dio.delete(ApiEndpoints.chatGroupById(groupId));
  //////////////////////////////////////////////////////////////
  ///// ── Members ────────────────────────────────────────────
  /////////////////////////////////////////////////////////////
  @override
  Future<List<ChatMemberModel>> getMembers(int groupId) async {
    final res = await _dio.get(ApiEndpoints.chatGroupMembers(groupId));
    return _parseList(res, ChatMemberModel.fromJson);
  }

  @override
  Future<void> addMembers(int groupId, List<int> staffIds) => _dio.post(
    ApiEndpoints.chatGroupMembers(groupId),
    data: {'staff_ids': staffIds},
  );

  @override
  Future<void> removeMember(int groupId, int staffId) =>
      _dio.delete(ApiEndpoints.chatGroupMemberById(groupId, staffId));

  @override
  Future<List<int>> getOnlineMembers(int groupId) async {
    final res = await _dio.get(ApiEndpoints.chatGroupOnline(groupId));
    return List<int>.from(
      (res.data as Map<String, dynamic>)['online_staff_ids'] as List,
    );
  }

  ///////////////////////////////////////////////////////////////
  ///// ── Messages ────────────────────────────────────────────
  //////////////////////////////////////////////////////////////
  @override
  Future<ChatMessageModel> sendTextMessage(
    int groupId,
    String content,
    int? replyToId,
  ) async {
    final body = <String, dynamic>{'content': content};
    if (replyToId != null) body['reply_to_id'] = replyToId;
    final res = await _dio.post(
      ApiEndpoints.chatGroupMessages(groupId),
      data: body,
    );
    return _parse(res, ChatMessageModel.fromJson);
  }

  @override
  Future<ChatMessageModel> sendMedia(
    int groupId,
    String filePath,
    String endpoint,
    int? replyToId,
  ) async {
    final path = switch (endpoint) {
      'images' => ApiEndpoints.chatGroupImages(groupId),
      'videos' => ApiEndpoints.chatGroupVideos(groupId),
      'audio' => ApiEndpoints.chatGroupAudio(groupId),
      'voice' => ApiEndpoints.chatGroupVoice(groupId),
      _ => ApiEndpoints.chatGroupFiles(groupId),
    };

    final res = await _dio.post(
      path,
      data: FormData.fromMap({'file': await MultipartFile.fromFile(filePath)}),
      queryParameters: replyToId != null ? {'reply_to_id': '$replyToId'} : null,
      options: Options(contentType: 'multipart/form-data'),
    );
    return _parse(res, ChatMessageModel.fromJson);
  }

  @override
  Future<List<ChatMessageModel>> getMessages(
    int groupId,
    int? beforeId,
    int limit,
  ) async {
    final res = await _dio.get(
      ApiEndpoints.chatGroupMessages(groupId),
      queryParameters: {'before_id': beforeId, 'limit': limit},
    );
    return _parseList(res, ChatMessageModel.fromJson);
  }

  @override
  Future<void> markMessageRead(int messageId) =>
      _dio.patch(ApiEndpoints.chatMessageRead(messageId));

  @override
  Future<void> markAllRead(int groupId) =>
      _dio.patch(ApiEndpoints.chatMessageReadAll(groupId));

  @override
  Future<int> getUnreadCount(int groupId) async {
    final res = await _dio.get(ApiEndpoints.chatMessageUnreadCount(groupId));
    return (res.data as Map<String, dynamic>)['unread_count'] as int? ?? 0;
  }

  @override
  Future<void> deleteMessage(int groupId, int messageId) =>
      _dio.delete(ApiEndpoints.chatMessageById(groupId, messageId));

  // ── WebSocket ────────────────────────────────────────────────────
  // Uses ApiConstants.wsBaseUrl — already computed from baseUrl
  @override
  Stream<WsEventEntity> connectWs(int groupId) async* {
    final token = await _storage.getAccessToken();
    if (token == null) throw Exception("No access token for WebSocket");
    ////////////////////////////////////////////////////////////////////////////
    /// ApiConstants.wsBaseUrl already handles http→ws and https→wss conversion
    /// // e.g. "http://192.168.250.130:8000" → "ws://192.168.250.130:8000"
    ////////////////////////////////////////////////////////////////////////////
    // final uri = Uri.parse(
    //   '${ApiConstants.wsBaseUrl} ${ApiConstants.apiVersion} ${ApiConstants.chatWs(groupId)}?token=$token',
    // );
    final uri = Uri.parse(
      '${ApiConstants.wsBaseUrl}${ApiConstants.apiVersion}${ApiConstants.chatWs(groupId)}?token=$token',
    );

    /////////////////////////////////
    ///
    ////////////////////////////////
    final channel = WebSocketChannel.connect(uri);
    _channels[groupId] = channel;
    await for (final raw in channel.stream) {
      try {
        final data = jsonDecode(raw as String) as Map<String, dynamic>;
        yield WsEventEntity(
          eventType: _parseEvent(data['event'] as String? ?? ''),
          payload: data,
        );
      } catch (_) {
        // skip malformed frames
      }
    }
  }

  @override
  void disconnectWs(int groupId) {
    _channels[groupId]?.sink.close();
    _channels.remove(groupId);
  }

  WsEventType _parseEvent(String e) => switch (e) {
    'new_message' => WsEventType.newMessage,
    'message_deleted' => WsEventType.messageDeleted,
    'message_read' => WsEventType.messageRead,
    'all_messages_read' => WsEventType.allMessagesRead,
    'members_added' => WsEventType.membersAdded,
    'member_removed' => WsEventType.memberRemoved,
    'group_deleted' => WsEventType.groupDeleted,
    'user_online' => WsEventType.userOnline,
    'user_offline' => WsEventType.userOffline,
    _ => WsEventType.unknown,
  };
}
