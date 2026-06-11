import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/notification_model.dart';

sealed class WsEvent {}

class WsConnectedEvent extends WsEvent {
  final int userId;
  final int unread;
  final int total;
  WsConnectedEvent({
    required this.userId,
    required this.unread,
    required this.total,
  });
}

///////////////////////////////////////////////////////////////////////
///
///////////////////////////////////////////////////////////////////////

class WsNewNotificationEvent extends WsEvent {
  final NotificationModel notification;
  WsNewNotificationEvent(this.notification);
}
///////////////////////////////////////////////////////////////////////
///
///////////////////////////////////////////////////////////////////////

class WsPongEvent extends WsEvent {}

class WsErrorEvent extends WsEvent {
  final String message;
  WsErrorEvent(this.message);
}

///////////////////////////////////////////////////////////////////////
///
///////////////////////////////////////////////////////////////////////

class NotificationWsDataSource {
  final String _wsBaseUrl;

  final Future<String?> Function() _getToken;

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _sub;
  Timer? _pingTimer;
  Timer? _reconnectTimer;

  final _controller = StreamController<WsEvent>.broadcast();

  Stream<WsEvent> get events => _controller.stream;
  bool get isConnected => _channel != null;

  NotificationWsDataSource({
    required String wsBaseUrl,
    required Future<String?> Function() getToken,
  }) : _wsBaseUrl = wsBaseUrl,
       _getToken = getToken;

  // ── Connection ─────────────────────────────────────────────────────────────

  Future<void> connect() async {
    if (_channel != null) return;
    ///////////////////////////////////////////////////////////////////////////////
    // Always fetch the latest token — may have been refreshed since last connect
    //////////////////////////////////////////////////////////////////////////////
    final token = await _getToken();
    if (token == null) {
      _controller.add(WsErrorEvent('No access token available'));
      return;
    }

    final uri = Uri.parse('$_wsBaseUrl/api/v1/ws/notifications?token=$token');
    print('🔌 WS URI: $uri');
    _channel = WebSocketChannel.connect(uri);
    // ✅ force handshake
    try {
      await _channel!.ready;
      print('✅ WS handshake success');
    } catch (e) {
      print('❌ WS handshake failed: $e');
      _channel = null;
      _controller.add(WsErrorEvent(e.toString()));
      _scheduleReconnect();
      return;
    }
    _sub = _channel!.stream.listen(
      _onMessage,
      onError: (e) {
        _controller.add(WsErrorEvent(e.toString()));
        _scheduleReconnect();
      },
      onDone: _scheduleReconnect,
    );

    ///////////////////////////////////////////////////////////////////////////////
    // Send ping every 30 s to keep the connection alive
    ///////////////////////////////////////////////////////////////////////////////

    _pingTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _send({'type': 'ping'}),
    );
  }

  // ── Message handling ───────────────────────────────────────────────────────

  void _onMessage(dynamic raw) {
    try {
      final map = jsonDecode(raw as String) as Map<String, dynamic>;
      final event = map['event'] as String?;
      final type = map['type'] as String?;

      if (event == 'connected') {
        _controller.add(
          WsConnectedEvent(
            userId: map['user_id'] as int? ?? 0,
            unread: map['unread'] as int? ?? 0,
            total: map['total'] as int? ?? 0,
          ),
        );
      } else if (event == 'new_notification') {
        _controller.add(
          WsNewNotificationEvent(NotificationModel.fromJson(map)),
        );
      } else if (type == 'pong') {
        _controller.add(WsPongEvent());
      }
    } catch (_) {}
  }

  // ── Outgoing ───────────────────────────────────────────────────────────────

  void _send(Map<String, dynamic> data) {
    try {
      _channel?.sink.add(jsonEncode(data));
    } catch (_) {}
  }

  // ── Reconnect ──────────────────────────────────────────────────────────────

  void _scheduleReconnect() {
    disconnect();
    _reconnectTimer?.cancel();
    // Re-fetches a fresh token on the next connect attempt
    _reconnectTimer = Timer(const Duration(seconds: 5), connect);
  }

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  void disconnect() {
    _pingTimer?.cancel();
    _reconnectTimer?.cancel();
    _sub?.cancel();
    _channel?.sink.close();
    _channel = null;
    _sub = null;
  }

  void dispose() {
    disconnect();
    _controller.close();
  }
}
